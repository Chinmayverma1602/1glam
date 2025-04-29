import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageLeadsBottomNavBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSendEstimate;

  const ManageLeadsBottomNavBar({
    super.key,
    required this.onBack,
    required this.onSendEstimate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Button - "Go Back"
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 18,
              ),
              label: Text(
                "Go Back",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          SizedBox(width: 12),

          // Right Button - "Send Estimate"
          Expanded(
            child: ElevatedButton(
              onPressed: onSendEstimate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Send Estimate",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
