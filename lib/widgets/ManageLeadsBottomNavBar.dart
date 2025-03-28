import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 3,
            spreadRadius: 0.3,
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
              label: Text(
                "Go Back",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 225, 224, 224),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          SizedBox(width: MediaQuery.of(context).size.width*0.03),

          // Right Button - "Send Estimate"
          Expanded(
            child: ElevatedButton(
              onPressed: onSendEstimate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "Send Estimate",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
