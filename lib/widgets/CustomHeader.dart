import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/services/leads_services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the status bar height to ensure proper spacing
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight +
            12, // Dynamic top padding based on status bar + extra space
        left: 16,
        right: 16,
        bottom: 10,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "1glam",
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.subtitle),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              lead: sampleLeads,
                            )));
              },
              child: Text(
                "Skip",
                style:
                    GoogleFonts.inter(fontSize: 14, color: AppColors.subtitle),
              )),
        ],
      ),
    );
  }
}
