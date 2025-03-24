import 'package:flutter/material.dart';
import 'package:glam1/model/booking_model.dart'; 

void showServiceBottomSheet(BuildContext context , Booking booking) {
  

  String servicename = booking.serviceName;
  int firstName = booking.price;

  TextEditingController serviceNameController = TextEditingController(text: servicename);
  TextEditingController costController = TextEditingController(text: firstName.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
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
                Text("Add Service", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Service Name Field
            TextField(
              controller: serviceNameController,
              decoration: InputDecoration(
                labelText: "Service Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Cost Field
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cost",
                border: OutlineInputBorder(),
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
}