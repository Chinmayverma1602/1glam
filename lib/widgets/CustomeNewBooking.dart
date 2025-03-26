import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:glam1/screens/NewBookingPage.dart';

Widget NewBookingButton() {
  return ElevatedButton.icon(
    onPressed: () {
      Get.to(() => NewBookingScreen());
      // Get.to(NewBookingScreen());
    },
    icon: Icon(Icons.add, color: Colors.white, size: 19),
    label: Text(
      "New Booking",
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
