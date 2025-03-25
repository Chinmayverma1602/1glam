import 'package:flutter/material.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:intl/intl.dart';

void showBookingServiceSheetDate(BuildContext context , Booking booking) {

  TextEditingController dateController = TextEditingController();


  dateController.text = DateFormat("dd-MM-yyyy").format(booking.date);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _pickDate() async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                dateController.text = DateFormat("yyyy-MM-dd").format(picked);
              });
            }
          }

          // void _pickTime() async {
          //   TimeOfDay? picked = await showTimePicker(
          //     context: context,
          //     initialTime: TimeOfDay.now(),
          //   );
          //   if (picked != null) {
          //     setState(() {
          //       timeController.text = picked.format(context);
          //     });
          //   }
          // }

          return Padding(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Book Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Date Picker Field
                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    labelText: "Select Date",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 10),

                // // Time Picker Field
                // TextField(
                //   controller: timeController,
                //   readOnly: true,
                //   onTap: _pickTime,
                //   decoration: InputDecoration(
                //     labelText: "Start Time",
                //     border: OutlineInputBorder(),
                //     suffixIcon: Icon(Icons.access_time),
                //   ),
                // ),
                // SizedBox(height: 10),

                // // Duration Field
                // TextField(
                //   controller: durationController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     labelText: "Duration (minutes)",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                // SizedBox(height: 20),

                // Cancel & Save Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.close, color: Colors.black54),
                        label: Text("Cancel", style: TextStyle(color: Colors.black54)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: Handle Save Logic
                          Navigator.pop(context);
                        },
                        child: Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}
