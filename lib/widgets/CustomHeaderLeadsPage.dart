import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/services/leads_services.dart';
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
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.title,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Filter button
              Container(
                height: 36,
                width: 36,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColors.hintText.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_alt,
                    size: 20,
                    color: AppColors.hintText,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              // Add button
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(lead: sampleLeads),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
