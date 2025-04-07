import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:intl/intl.dart';

void showBookingServiceSheetTime(BuildContext context, Booking booking) {
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  


  startTimeController.text = DateFormat('h:mm a').format(booking.startTime);
  endTimeController.text = DateFormat('h:mm a').format(booking.endTime);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void _pickTime(TextEditingController controller) async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() {
                controller.text = picked.format(context);
              });
            }
          }

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

                // Start Time Picker Field
                TextField(
                  controller: startTimeController,
                  readOnly: true,
                  onTap: () => _pickTime(startTimeController),
                  decoration: InputDecoration(
                    labelText: "Start Time",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                SizedBox(height: 10),

                // End Time Picker Field
                TextField(
                  controller: endTimeController,
                  readOnly: true,
                  onTap: () => _pickTime(endTimeController),
                  decoration: InputDecoration(
                    labelText: "End Time",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),

                SizedBox(height: 20),

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
                          backgroundColor: AppColors.primary,
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
