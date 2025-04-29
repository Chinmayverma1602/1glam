import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageLeadsNotes extends StatelessWidget {
  const ManageLeadsNotes({super.key});

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
          // Notes Header with "Edit Notes" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notes",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              _actionButton(
                icon: FontAwesomeIcons.penToSquare,
                text: 'Edit Notes',
                bgColor: AppColors.primary.withOpacity(0.1),
                iconColor: AppColors.primary,
                textColor: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: 16),

          // Notes Text or Empty State
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.light.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              "Client prefers natural looking makeup. Allergic to latex products.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Image placeholders
          Row(
            children: [
              Expanded(child: _buildImagePlaceholder(context)),
              SizedBox(width: 10),
              Expanded(child: _buildImagePlaceholder(context)),
            ],
          ),
        ],
      ),
    );
  }

  // Placeholder Widget for images
  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.image,
            color: Colors.grey.shade400,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            'Image placeholder',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 12,
              color: iconColor,
            ),
            SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
