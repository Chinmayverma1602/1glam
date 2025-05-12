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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

    // Determine if we have bookings for the selected day
    bool hasBookings = bookingsForSelectedDay.isNotEmpty;

    // Debug output to verify we have bookings
    if (hasBookings) {
      print(
          'DEBUG: Found ${bookingsForSelectedDay.length} bookings for selected day: ${DateFormat('yyyy-MM-dd').format(_selectedDay)}');

      // Debug info for most recent booking
      Booking mostRecentBooking = bookingsForSelectedDay.last;
      print('DEBUG: Most recent booking details:');
      print('DEBUG:   Customer: ${mostRecentBooking.customerName}');
      print('DEBUG:   Phone: ${mostRecentBooking.phoneNo}');
      print('DEBUG:   Service: ${mostRecentBooking.serviceName}');
      print(
          'DEBUG:   Date: ${DateFormat('yyyy-MM-dd').format(mostRecentBooking.date)}');
      print(
          'DEBUG:   Time: ${DateFormat('HH:mm').format(mostRecentBooking.startTime)} - ${DateFormat('HH:mm').format(mostRecentBooking.endTime)}');
      print('DEBUG:   Price: ₹${mostRecentBooking.price}');
      print(
          'DEBUG:   Duration: ${mostRecentBooking.duration.inMinutes} minutes');
    } else {
      print(
          'DEBUG: No bookings found for selected day: ${DateFormat('yyyy-MM-dd').format(_selectedDay)}');
    }

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
                    fontSize: 20,
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

            // Show debug message about current booking status
            if (hasBookings)
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  "✓ Real booking data available",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[800],
                  ),
                ),
              ),

            // Expanded list that contains bookings
            Expanded(
              child: ListView(
                children: [
                  // Show REAL booking container when we have bookings
                  if (hasBookings)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                            width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified,
                                  size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                "User Booking",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildBookingDataContainer(
                              bookingsForSelectedDay.last),
                        ],
                      ),
                    )
                  // Show DUMMY container when no bookings
                  else
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Dummy Booking Preview",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          _buildDummyBookingContainer(),
                        ],
                      ),
                    ),

                  // List of all bookings for this date
                  if (hasBookings) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.event_available,
                              size: 18, color: Colors.green[700]),
                          SizedBox(width: 8),
                          Text(
                            "${bookingsForSelectedDay.length} Booking${bookingsForSelectedDay.length > 1 ? 's' : ''} for ${DateFormat("MMM d").format(_selectedDay)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...bookingsForSelectedDay
                        .map((booking) => _buildBookingItem(context, booking))
                        .toList(),
                  ],

                  // Message when no bookings exist
                  if (!hasBookings)
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          // child: Text(
                          //   "No bookings found for this date",
                          //   style: TextStyle(
                          //     color: Colors.grey[600],
                          //     fontSize: 14,
                          //   ),
                          // ),
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container to show real booking data
  Widget _buildBookingDataContainer(Booking booking) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with customer info - more compact
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        booking.phoneNo,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Confirmed",
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Compact details section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Service info with highlight
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.spa_outlined, size: 20, color: Colors.purple),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Service",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                            Text(
                              booking.serviceName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Date and Time info with highlight
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy')
                                .format(booking.date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "${DateFormat('h:mm a').format(booking.startTime)} - ${DateFormat('h:mm a').format(booking.endTime)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timelapse, size: 18, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "Duration: ${booking.duration.inMinutes} minutes",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price info with highlight
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.currency_rupee, size: 20, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                            Text(
                              "₹${booking.price}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact action buttons
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactActionButton(
                  icon: Icons.edit,
                  label: "Edit",
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditBookingScreen(booking: booking)),
                    ).then((_) {
                      _refreshData();
                    });
                  },
                ),
                _buildCompactActionButton(
                  icon: Icons.message_outlined,
                  label: "Message",
                  color: Colors.blue,
                  onTap: () {
                    // Implement messaging functionality
                  },
                ),
                _buildCompactActionButton(
                  icon: Icons.call,
                  label: "Call",
                  color: Colors.green,
                  onTap: () {
                    // Implement call functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Booking booking) {
    return GestureDetector(
      onTap: () {
        // Show bottom sheet for all bookings instead of navigating to edit screen
        showBookingDetailsBottomSheet(context, booking);
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

  // Show booking details in a bottom sheet
  void showBookingDetailsBottomSheet(BuildContext context, Booking booking) {
    showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Booking Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    // Edit button that navigates to full edit screen
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditBookingScreen(booking: booking)),
                    ).then((_) {
                      _refreshData();
                    });
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(thickness: 1.2),
            SizedBox(height: 8),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person,
                              size: 28, color: Colors.black54),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.customerName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(booking.phoneNo,
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Booking details - using similar style to EditBookingScreen
                    _bottomSheetTile(
                      icon: Icons.event_available,
                      title: "Service",
                      subtitle: booking.serviceName,
                    ),

                    _bottomSheetTile(
                      icon: Icons.access_time,
                      title: "Time",
                      subtitle:
                          "${DateFormat('h:mm a').format(booking.startTime)} - ${DateFormat('h:mm a').format(booking.endTime)}",
                    ),

                    _bottomSheetTile(
                      icon: Icons.calendar_month,
                      title: "Date",
                      subtitle: DateFormat("dd MMMM yyyy").format(booking.date),
                    ),

                    _bottomSheetTile(
                      icon: Icons.currency_rupee,
                      title: "Price",
                      subtitle: "₹${booking.price}",
                    ),

                    _bottomSheetTile(
                      icon: Icons.timer,
                      title: "Duration",
                      subtitle: "${booking.duration.inMinutes} mins",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for bottom sheet tiles
  Widget _bottomSheetTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
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

  // Dummy booking container to showcase booking fields
  Widget _buildDummyBookingContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with customer info - more compact
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shreya Singh",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "+91 98765 43210",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Confirmed",
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // Compact details section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // First row: Service and Time
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactDetailItem(
                        icon: Icons.spa_outlined,
                        value: "Bridal Makeup",
                      ),
                    ),
                    Expanded(
                      child: _buildCompactDetailItem(
                        icon: Icons.access_time,
                        value: "10:00 - 11:30 AM",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Second row: Date and Price
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactDetailItem(
                        icon: Icons.calendar_today,
                        value: "May 9, 2025",
                      ),
                    ),
                    Expanded(
                      child: _buildCompactDetailItem(
                        icon: Icons.currency_rupee,
                        value: "₹5,000",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Address displayed with wrapping
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "123 Park Street, Kolkata",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Compact action buttons
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactActionButton(
                  icon: Icons.edit,
                  label: "Edit",
                  color: AppColors.primary,
                ),
                _buildCompactActionButton(
                  icon: Icons.message_outlined,
                  label: "Message",
                  color: Colors.blue,
                ),
                _buildCompactActionButton(
                  icon: Icons.call,
                  label: "Call",
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for compact booking details
  Widget _buildCompactDetailItem({
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper for compact action buttons
  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
}
