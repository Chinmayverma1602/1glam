import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class ManageLeadsServicesButton extends StatelessWidget {
  const ManageLeadsServicesButton({super.key});

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

          // Services Header with "Add Service" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Services",
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
                    Icon(Icons.add, color: AppColors.primary, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Add Service',
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

          // Services List
          _buildServiceItem("Bridal Makeup", "₹15,000"),
          _buildServiceItem("Hair Styling", "₹5,000"),
        ],
      ),
    );
  }

  // Widget for each service item
  Widget _buildServiceItem(String serviceName, String price) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.edit, color: AppColors.primary, size: 20),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
