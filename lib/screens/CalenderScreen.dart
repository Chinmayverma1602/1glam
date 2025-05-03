import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:glam1/screens/EditBookingScreen.dart';
// import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/services/BookingController.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomeNewBooking.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Simple Event class for the calendar
class CalendarEvent {
  final String title;
  const CalendarEvent(this.title);
}

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat =
      CalendarFormat.week; //to select the format of the calender from the enum
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool isLoading = false;
  bool _initialDaySelected = false;
  int _selectedIndex = 2; // Moved outside of build method

  // Initialize BookingController
  final BookingController bookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    // Immediately refresh the bookings data
    _refreshData();
  }

  // Centralized refresh method
  Future<void> _refreshData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      print('Fetching bookings directly from API...');

      // Ensure the controller is initialized
      if (!Get.isRegistered<BookingController>()) {
        Get.put(BookingController());
      }

      // Force a fresh fetch from API
      await bookingController.fetchBookingsFromApi();

      // Manually trigger a rebuild
      if (mounted) {
        setState(() {
          _selectedDay = DateTime.now();
          _focusedDay = DateTime.now();
        });
      }
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Simple utility to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get bookings for a specific day - simplified
  List<Booking> _getBookingsForDay(DateTime day) {
    List<Booking> result = [];

    // Print available bookings for debugging
    print('Looking for bookings on ${DateFormat('yyyy-MM-dd').format(day)}');
    print('Available bookings: ${bookingController.bookings.length}');

    // Check each booking with a simple date comparison
    for (var booking in bookingController.bookings) {
      if (_isSameDay(booking.date, day)) {
        print('Found matching booking: ${booking.customerName}');
        result.add(booking);
      }
    }

    print('Total matching bookings: ${result.length}');
    return result;
  }

  // Get today's bookings
  List<Booking> _getTodaysBookings() {
    DateTime today = DateTime.now();

    // Print debug info
    print(
        'Getting bookings for today: ${DateFormat('yyyy-MM-dd').format(today)}');

    // Compare only year, month, day for accurate matching
    return bookingController.bookings.where((booking) {
      // For debugging
      print(
          'Comparing today with booking: ${DateFormat('yyyy-MM-dd').format(booking.date)}');

      return booking.date.year == today.year &&
          booking.date.month == today.month &&
          booking.date.day == today.day;
    }).toList();
  }

  // Get title for the bookings section based on selected date
  String _getBookingsSectionTitle() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedNormalized =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

    if (selectedNormalized.isAtSameMomentAs(today)) {
      return "Today's Bookings";
    } else {
      // Format date as "Feb 21 Bookings" or similar
      return "${DateFormat('MMM d').format(_selectedDay)} Bookings";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug print all bookings in build method to ensure they're loaded
    print(
        '** DEBUG BUILD: Total bookings: ${bookingController.bookings.length}');
    bookingController.bookings.forEach((booking) {
      print(
          '** DEBUG BUILD: Booking ${booking.id} - ${booking.customerName} on ${DateFormat('yyyy-MM-dd').format(booking.date)}');
    });

    // Try to map bookings to a simpler format for debugging
    Map<String, List<String>> dateToBookingsMap = {};
    bookingController.bookings.forEach((booking) {
      String dateKey = DateFormat('yyyy-MM-dd').format(booking.date);
      if (!dateToBookingsMap.containsKey(dateKey)) {
        dateToBookingsMap[dateKey] = [];
      }
      dateToBookingsMap[dateKey]!.add(booking.customerName);
    });

    print('** DEBUG BUILD: Dates with bookings:');
    dateToBookingsMap.forEach((date, bookings) {
      print(
          '** DEBUG BUILD: Date $date has ${bookings.length} bookings: ${bookings.join(', ')}');
    });

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          //_buildCalendarViewOptions(),
          _buildCalendar(),
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
              : Obx(() => _buildSelectedDayBookings()),
        ],
      ),
      floatingActionButton: NewBookingButton(),
    );
  }

  //return the calendar head on the top of the screen
  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Calendar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              //color: Colors.red, //testing purposes
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              NewBookingButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarViewOptions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildViewOption('Month', true),
          _buildViewOption('Week', false),
          _buildViewOption('Day', false),
        ],
      ),
    );
  }

  Widget _buildViewOption(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    // Create a map of dates to booking counts for all dates
    Map<DateTime, int> bookingCountMap = {};

    // Process all bookings to prepare the event map
    for (var booking in bookingController.bookings) {
      // Normalize the date to avoid time comparison issues
      DateTime normalizedDate =
          DateTime(booking.date.year, booking.date.month, booking.date.day);

      // Count bookings per date
      bookingCountMap[normalizedDate] =
          (bookingCountMap[normalizedDate] ?? 0) + 1;
    }

    // For debugging, print all dates with bookings
    print('Dates with bookings:');
    bookingCountMap.forEach((date, count) {
      print('${DateFormat('yyyy-MM-dd').format(date)}: $count bookings');
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TableCalendar(
        firstDay: DateTime(DateTime.now().year - 1),
        lastDay: DateTime(DateTime.now().year + 1, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return _isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          // Debug selected day's bookings
          List<Booking> selectedDayBookings = _getBookingsForDay(selectedDay);
          print(
              'Selected ${DateFormat('yyyy-MM-dd').format(selectedDay)}: ${selectedDayBookings.length} bookings');
          for (var booking in selectedDayBookings) {
            print('- ${booking.customerName}: ${booking.serviceName}');
          }
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        // Use eventLoader to signal which days have bookings
        eventLoader: (day) {
          // Normalize day to midnight
          DateTime normalizedDay = DateTime(day.year, day.month, day.day);

          // Check if this day has any bookings
          int count = bookingCountMap[normalizedDay] ?? 0;
          return count > 0
              ? List.generate(count, (_) => CalendarEvent('Booking'))
              : [];
        },
        // Style settings
        calendarStyle: CalendarStyle(
          markersMaxCount: 4,
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        rowHeight: 60,
      ),
    );
  }

  Widget _buildSelectedDayBookings() {
    // Get bookings for the selected day using our helper method
    final bookingsForSelectedDay = _getBookingsForDay(_selectedDay);

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and refresh button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getBookingsSectionTitle(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Refresh button
                IconButton(
                  icon: Icon(Icons.refresh, color: AppColors.primary),
                  onPressed: () {
                    print('Manual refresh triggered');
                    _refreshData();
                  },
                ),
              ],
            ),

            SizedBox(height: 8),

            // Debug info
            Text(
              'Found ${bookingsForSelectedDay.length} bookings',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            SizedBox(height: 8),

            // Display bookings or no bookings message
            Expanded(
              child: bookingsForSelectedDay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No bookings for this date",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookingsForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final booking = bookingsForSelectedDay[index];
                        return _buildBookingItem(context, booking);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Booking booking) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditBookingScreen(booking: booking)),
        ).then((_) {
          // Refresh bookings when returning from edit screen
          _refreshData();
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.customerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(BookingStatus.confirmed),
              ],
            ),
            SizedBox(height: 4),
            Text(
              booking.serviceName,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4),
                Text(
                  "${DateFormat('h:mm a').format(booking.startTime)} - ${DateFormat('h:mm a').format(booking.endTime)}",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            // Date display
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.primary,
                ),
                SizedBox(width: 4),
                Text(
                  DateFormat('EEE, MMM d').format(booking.date),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color backgroundColor;
    String text;

    switch (status) {
      case BookingStatus.pending:
        backgroundColor = Colors.amber[100]!;
        text = 'Pending';
        break;
      case BookingStatus.confirmed:
        backgroundColor = Colors.green[100]!;
        text = 'Confirmed';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        text = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: status == BookingStatus.pending
              ? Colors.amber[800]
              : Colors.green[800],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/leads');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/calender');
        break;
      case 3:
        // This should be payments based on BottomNavBar.dart
        // Navigate accordingly
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }
}

enum BookingStatus {
  pending,
  confirmed,
}
