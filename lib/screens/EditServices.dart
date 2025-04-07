import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

void editService(BuildContext context) {
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    // TODO: Handle adding new service
                  },
                  child: Text(
                    "+ Add Service",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Service List
            _serviceItem("Bridal Makeup", "₹15,000"),
            _serviceItem("Hair Styling", "₹5,000"),

            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

// Function to create a single service item
Widget _serviceItem(String title, String price) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(price, style: TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              // TODO: Handle edit action
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // TODO: Handle delete action
            },
          ),
        ],
      ),
    ),
  );
}
