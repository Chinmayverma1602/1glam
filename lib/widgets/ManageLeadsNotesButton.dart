import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class ManageLeadsNotes extends StatelessWidget {
  const ManageLeadsNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18
                    ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.primary, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Edit Booking',
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

          // Notes Text
          Text(
            "Client prefers natural looking makeup. Allergic to latex products.",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.018),

          // Image placeholders
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImagePlaceholder(context),
              SizedBox(width: 10),
              _buildImagePlaceholder(context),

            ],
          ),
        ],
      ),
    );
  }

  // Placeholder Widget for images
  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.4,
      height: MediaQuery.of(context).size.height*0.15,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        'any images goes here')
    );
  }
}
