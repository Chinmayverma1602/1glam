import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20,left: 16,right: 16),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
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
