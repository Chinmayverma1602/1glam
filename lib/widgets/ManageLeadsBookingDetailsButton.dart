import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageLeadsBookingDetailsButton extends StatelessWidget {
  final String bookingDate;
  final String startTime;
  final String endTime;

  const ManageLeadsBookingDetailsButton(
      {super.key,
      required this.bookingDate,
      required this.startTime,
      required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Details",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          // Calendar Icon + Date
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.light.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.calendar,
                  color: AppColors.primary,
                  size: 14,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bookingDate,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Clock Icon + Time
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.light.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.clock,
                  color: AppColors.primary,
                  size: 14,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${startTime} - ${endTime}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Edit Booking & View Conversation Buttons in a Row
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _actionButton(
                    icon: FontAwesomeIcons.penToSquare,
                    text: 'Edit Booking',
                    bgColor: AppColors.primary.withOpacity(0.1),
                    iconColor: AppColors.primary,
                    textColor: AppColors.primary,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    icon: FontAwesomeIcons.comments,
                    text: 'View Conversation',
                    bgColor: Colors.grey.withOpacity(0.1),
                    iconColor: Color(0xFF6B7280),
                    textColor: Color(0xFF6B7280),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 12,
              color: iconColor,
            ),
            SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
