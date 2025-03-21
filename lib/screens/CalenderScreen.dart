import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:glam1/services/BookingController.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Initialize BookingController
  final BookingController bookingController = Get.put(BookingController());

  // @override
  // void initState() {
  //   super.initState();
  //   bookingController.fetchBookings(); // Fetch bookings when the page loads
  // }

  // Get bookings for a selected day
  List<Booking> _getBookingsForDay(DateTime day) {
    return bookingController.bookings
        .where((booking) => isSameDay(DateTime.parse(booking.date), day))
        .toList();
  }

  // Get title for the bookings section based on selected date
  String _getBookingsSectionTitle() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedNormalized = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    
    if (selectedNormalized.isAtSameMomentAs(today)) {
      return "Today's Bookings";
    } else {
      // Format date as "Feb 21 Bookings" or similar
      return "${DateFormat('MMM d').format(_selectedDay)} Bookings";
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;

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
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }
    
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
          Obx(() => _buildSelectedDayBookings()),
        ],
      ),
    );
  }

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
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
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
        color: isSelected ? Colors.purple : Colors.transparent,
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
  return TableCalendar(
    firstDay: DateTime.utc(2025, 1, 1),
    lastDay: DateTime.utc(2025, 12, 31),
    focusedDay: _focusedDay,
    calendarFormat: _calendarFormat,
    selectedDayPredicate: (day) {
      return isSameDay(_selectedDay, day);
    },
    onDaySelected: (selectedDay, focusedDay) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
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
    calendarStyle: CalendarStyle(
      markersMaxCount: 0, // Hide default markers, using custom ones
    ),
    calendarBuilders: CalendarBuilders(
      prioritizedBuilder: (context, day, focusedDay) {
        final bookingsForDay = _getBookingsForDay(day);
        bool isSelected = isSameDay(_selectedDay, day);
        bool isToday = isSameDay(day, DateTime.now());
  
        return Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Stack(
            children: [
              // Background Box for Event Days, Selected Day, and Today
              if (bookingsForDay.isNotEmpty || isSelected || isToday)
                Container(
                  width: 50,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isToday
                        ? const Color(0xFFE8CFFF) // Slightly darker for today
                        : const Color(0xFFF9EBFF), // Light purple for selected & events
                  ),
                ),
  
              // Date Text
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8,left: 6),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
  
              // Event Indicator (Only if there are events)
              if (bookingsForDay.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Container(
                      width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0,top: 4.0),
                            child: Text(
                              '${bookingsForDay.length}\nevents',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          // const Text(
                          //   'events',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //     color: Colors.purple,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
  
              // "No Events" Label for Selected Day without Events
              if (isSelected && bookingsForDay.isEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Container(
                      width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0,top: 4.0),
                          child: Text(
                            'No events',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
    eventLoader: (day) {
      return _getBookingsForDay(day);
    },
    rowHeight: 50,
  );
}


  Widget _buildSelectedDayBookings() {
    final bookingsForSelectedDay = _getBookingsForDay(_selectedDay);
    
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getBookingsSectionTitle(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            bookingsForSelectedDay.isEmpty
                ? Flexible(
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            "No bookings for this date",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                )
                : Expanded(
                    child: ListView.builder(
                      itemCount: bookingsForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final booking = bookingsForSelectedDay[index];
                        return _buildBookingItem(booking);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(Booking booking) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/EditBookingScreen');
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
                Text(
                  '${booking.services[0].serviceName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                //_buildStatusChip(booking.services[1]),
              ],
            ),
            SizedBox(height: 4),
            Text(
              '${booking.services[0].price}',
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
                  color: Colors.purple,
                ),
                SizedBox(width: 4),
                Text(
                  booking.time,
                  style: TextStyle(
                    color: Colors.grey[700],
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
          color: status == BookingStatus.pending ? Colors.amber[800] : Colors.green[800],
        ),
      ),
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
}
