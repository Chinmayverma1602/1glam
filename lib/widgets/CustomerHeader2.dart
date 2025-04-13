import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';


class CustomHeader2 extends StatelessWidget {
  final String textValue;
  const CustomHeader2({super.key, required this.textValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 6, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.dark,
            ),
          ),
          Text(
            textValue,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
