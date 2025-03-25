import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeaderLeadsPage extends StatelessWidget {
  const CustomHeaderLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Leads",
            style: GoogleFonts.inter(
                fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 30,
                      width: 30,
                      padding: EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                          color: AppColors.hintText, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_alt,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outlined,
                        color: AppColors.primary,
                        size: 35,
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
