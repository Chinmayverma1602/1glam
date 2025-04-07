import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showEditContactBottomSheet(BuildContext context , Booking booking) {
  showMaterialModalBottomSheet(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _buildEditContactSheet(context , booking),
  );
}

Widget _buildEditContactSheet(BuildContext context, Booking booking) {
  // Split the customer name into first and last name
  List<String> nameParts = booking.customerName.split(' ');
  String firstName = nameParts.isNotEmpty ? nameParts.first : "";
  String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";

  final TextEditingController firstNameController = TextEditingController(text: firstName);
  final TextEditingController lastNameController = TextEditingController(text: lastName);
  final TextEditingController phoneController = TextEditingController(text: booking.phoneNo);

  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Edit Contact Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
          ],
        ),
        SizedBox(height: 10),
        _buildTextField("First Name", firstNameController),
        SizedBox(height: 10),
        _buildTextField("Last Name", lastNameController),
        SizedBox(height: 10),
        IntlPhoneField(
          initialCountryCode: 'IN',
          controller: phoneController,
          decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
          onChanged: (phone) {
            print(phone.completeNumber); // Handle number change
          },
        ),
        SizedBox(height: 20),
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
                  Navigator.pop(context);
                  // TODO: update the api to update the info
                },
                child: Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      SizedBox(height: 5),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    ],
  );
}