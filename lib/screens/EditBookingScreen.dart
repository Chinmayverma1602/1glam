import 'package:flutter/material.dart';
import 'package:glam1/screens/EditBookingInfo.dart';
import 'package:glam1/screens/EditCustomerInfo.dart';
import 'package:glam1/screens/EditNodesInfo.dart';
import 'package:glam1/screens/EditServicesInfo.dart';
import 'package:glam1/services/BookingController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditBookingScreen extends StatefulWidget {
  final Booking? booking;

  const EditBookingScreen({Key? key, this.booking}) : super(key: key);

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final BookingController _bookingController = Get.find<BookingController>();
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  late String _selectedClientName;
  late String _selectedServiceName;

  // Time slots for the timeline (24-hour format)
  final List<int> _timeSlots =
      List.generate(13, (index) => index + 9); // 9 AM to 9 PM

  @override
  void initState() {
    super.initState();

    if (widget.booking != null) {
      _selectedDay = widget.booking!.date;
      _selectedClientName = widget.booking!.customerName;
      _selectedServiceName = widget.booking!.serviceName;
    } else {
      _selectedDay = DateTime.now();
      _selectedClientName = '';
      _selectedServiceName = '';
    }

    _focusedDay = _selectedDay;
    _calendarFormat = CalendarFormat.month;
  }

  String _formatTimeSlot(int hour) {
    if (hour < 12) {
      return '$hour AM';
    } else if (hour == 12) {
      return '12 PM';
    } else {
      return '${hour - 12} PM';
    }
  }

  Widget _buildBookingItem(Booking booking) {
    // Format time for display
    final timeFormat = DateFormat('h:mm a');
    final startTimeString = timeFormat.format(booking.startTime);
    final endTimeString = timeFormat.format(booking.endTime);

    return GestureDetector(
      onTap: () {
        _showBookingEditSheet(context , booking);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Booking',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${booking.serviceName}',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingEditSheet(BuildContext context  , Booking booking) {
    showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable Indicator
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Clickable Tiles
            _bottomSheetTile(
                icon: Icons.person_outline,
                title: "Client",
                subtitle: booking.customerName,
                onTap: () => showEditContactBottomSheet(context, booking)),

            _bottomSheetTile(
                icon: Icons.cut,
                title: "Services",
                subtitle: booking.serviceName,
                onTap: () => showServiceBottomSheet(context , booking)),

            _bottomSheetTile(
                icon: Icons.calendar_today_outlined,
                
                title: "Booking Details",
                subtitle: "${DateFormat('h:mm a').format(booking.startTime)} - ${DateFormat('h:mm a').format(booking.endTime)}",
                onTap: () => showBookingServiceSheet(context)),

            _bottomSheetTile(
                icon: Icons.note_outlined,
                title: "Notes",
                subtitle: "Add special instructions",

                onTap: () => showNotesBottomSheet(context) 
                
                ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    iconAlignment: IconAlignment.start,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Lighter grey
                      padding: EdgeInsets.symmetric(
                          vertical: 14), // Better vertical padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: Icon(Icons.arrow_back, color: Colors.black), // Cancel icon
                    label:
                        Text("Cancel", style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(width: 12), // Spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //TODO: Save changes action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(
                          vertical: 14), // Consistent padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text("Save Changes",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetTile(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.purple.withOpacity(0.1),
              child: Icon(icon, color: Colors.purple),
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
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // void _showBookingEditSheet(Booking booking) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Edit Booking',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 //color: Colors.red
  //               ),
  //             ),
  //             SizedBox(height: 16),
  //             Text('Booking ID: ${booking.id}'),
  //             SizedBox(height: 8),
  //             Text('Client: ${booking.customerName}'),
  //             SizedBox(height: 8),
  //             Text('Service: ${booking.serviceName}'),
  //             SizedBox(height: 8),
  //             Text('Date: ${DateFormat('yyyy-MM-dd').format(booking.date)}'),
  //             SizedBox(height: 8),
  //             Text('Time: ${DateFormat('h:mm a').format(booking.startTime)} - ${DateFormat('h:mm a').format(booking.endTime)}'),
  //             SizedBox(height: 16),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 OutlinedButton.icon(
  //                   icon: Icon(Icons.delete),
  //                   label: Text('Delete'),
  //                   onPressed: () {
  //                     // Handle booking deletion
  //                     Navigator.pop(context);
  //                     // You could add confirmation dialog here
  //                     _bookingController.deleteBooking(booking.id);
  //                     setState(() {}); // Refresh the UI
  //                   },
  //                   style: OutlinedButton.styleFrom(
  //                     foregroundColor: Colors.red,
  //                   ),
  //                 ),
  //                 ElevatedButton.icon(
  //                   icon: Icon(Icons.edit),
  //                   label: Text('Edit Details'),
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     // Navigate to a detailed edit screen or show another bottom sheet
  //                     // with form fields to edit the booking
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.purple,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 16),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  List<Booking> _getBookingsForSelectedDay() {
    return _bookingController.bookings.where((booking) {
      return booking.date.year == _selectedDay.year &&
          booking.date.month == _selectedDay.month &&
          booking.date.day == _selectedDay.day;
    }).toList();
  }

  Map<int, List<Booking>> _getBookingsByHour() {
    final bookingsForDay = _getBookingsForSelectedDay();
    final bookingsByHour = <int, List<Booking>>{};

    for (var booking in bookingsForDay) {
      final startHour = booking.startTime.hour;
      if (!bookingsByHour.containsKey(startHour)) {
        bookingsByHour[startHour] = [];
      }
      bookingsByHour[startHour]!.add(booking);
    }

    return bookingsByHour;
  }

  @override
  Widget build(BuildContext context) {
    final bookingsByHour = _getBookingsByHour();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
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
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    // Check if there are bookings for this date
                    final hasBookings =
                        _bookingController.bookings.any((booking) {
                      return booking.date.year == date.year &&
                          booking.date.month == date.month &&
                          booking.date.day == date.day;
                    });

                    if (hasBookings) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.black),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final hour = _timeSlots[index];
                    final timeText = _formatTimeSlot(hour);
                    final hasBookingsForHour = bookingsByHour.containsKey(hour);

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                timeText,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: hasBookingsForHour
                                  ? Column(
                                      children: bookingsByHour[hour]!
                                          .map((booking) =>
                                              _buildBookingItem(booking))
                                          .toList(),
                                    )
                                  : Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.close),
                      label: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Save Changes'),
                      onPressed: () {
                        // Save the updated booking
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
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
}
