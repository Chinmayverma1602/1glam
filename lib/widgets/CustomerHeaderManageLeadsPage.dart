import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeaderManageLeadsPage extends StatelessWidget {
  const CustomHeaderManageLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 6, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.dark,
            ),
          ),
          Text(
            "Manage Lead",
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
