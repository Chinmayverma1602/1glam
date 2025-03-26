import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';

class ManageLeadNameButton extends StatelessWidget {
  const ManageLeadNameButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.16,
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
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Name, Phone Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Priya Shah",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 18
                          ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.004),
                    CustomSubTitle(
                      subtitle: "+91-987654321",
                      color: AppColors.hintText,
                    ),
                  ],
                ),

                // pending
                Container(
                  margin: EdgeInsets.only(right: 4),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.inquiryButtonColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: AppColors.inquiryTextColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).size.height*0.02),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // edit details
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      Text(
                        'Edit Details',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 16),
                      )
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.03),

                // change status
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: const Color.fromARGB(255, 101, 101, 101),
                        size: 20,
                      ),
                      Text(
                        'Change Status',
                        style:
                            TextStyle(color: const Color.fromARGB(255, 101, 101, 101), fontSize: 16),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

