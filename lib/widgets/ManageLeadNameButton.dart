import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/ManageLeadsNameDropDownButton.dart';

class ManageLeadNameButton extends StatefulWidget {
  final String name;
  final String mobileNumber;
  final String initialStatus;

  const ManageLeadNameButton({
    super.key,
    this.name = "Priya Shah",
    this.mobileNumber = "+91-987654321",
    this.initialStatus = "Pending",
  });

  @override
  _ManageLeadNameButtonState createState() => _ManageLeadNameButtonState();
}

class _ManageLeadNameButtonState extends State<ManageLeadNameButton> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
  }

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case "qualified lead":
        return AppColors.qualifiedButtonColor;
      case "proposal accepted":
        return AppColors.proposalButtonColor;
      default:
        return AppColors.inquiryButtonColor; 
    }
  }

  Color getStatusTextColor() {
    switch (status.toLowerCase()) {
      case "qualified lead":
        return AppColors.qualifiedLeadTextColor;
      case "proposal accepted":
        return AppColors.proposalAcceptedTextColor;
      default:
        return AppColors.inquiryTextColor;
    }
  }

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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.004),
                  CustomSubTitle(
                    subtitle: widget.mobileNumber,
                    color: AppColors.hintText,
                  ),
                ],
              ),

              // Status Dropdown
              StatusDropDownManageLeads(
                status: status,
                onStatusChanged: (newStatus) {
                  setState(() {
                    status = newStatus;
                  });
                },
                statusColor:
                    getStatusColor(), 
                statusTextColor:
                    getStatusTextColor(),
              ),
            ]),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Edit details
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                // Change status
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
                        style: TextStyle(
                            color: const Color.fromARGB(255, 101, 101, 101),
                            fontSize: 16),
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



