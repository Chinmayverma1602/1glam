import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageLeadNameButton extends StatefulWidget {
  final String clientName;
  final String clientMobileNo;
  final String currentStatus;

  const ManageLeadNameButton(
      {super.key,
      required this.clientName,
      required this.currentStatus,
      required this.clientMobileNo});

  @override
  State<ManageLeadNameButton> createState() => _ManageLeadNameButtonState();
}

class _ManageLeadNameButtonState extends State<ManageLeadNameButton> {
  // Function to determine status container color based on lead status
  Map<String, Color> getStatusColors(String status) {
    switch (status) {
      case "Inbound":
        return {
          'bg': Color(0xFFE0F2FE), // Light blue bg
          'text': Color(0xFF0284C7), // Blue text
        };
      case "Qualifying":
        return {
          'bg': Color(0xFFFDE68A), // Amber bg
          'text': Color(0xFFB45309), // Amber text
        };
      case "Proposal Sent":
        return {
          'bg': Color(0xFFDCFCE7), // Light green bg
          'text': Color(0xFF15803D), // Green text
        };
      case "Proposal Accepted":
        return {
          'bg': AppColors.proposalButtonColor, // Green bg
          'text': AppColors.proposalAcceptedTextColor, // Green text
        };
      case "Deposit Requested":
        return {
          'bg': Color(0xFFFBEDD8), // Orange bg
          'text': Color(0xFFEA580C), // Orange text
        };
      case "Deposit Received":
        return {
          'bg': Color(0xFFD8B4FE), // Purple bg
          'text': Color(0xFF7E22CE), // Purple text
        };
      case "Confirmed":
        return {
          'bg': AppColors.inquiryButtonColor, // Yellow bg
          'text': AppColors.inquiryTextColor, // Yellow text
        };
      case "Closed / Lost":
        return {
          'bg': Color(0xFFFECACA), // Red bg
          'text': Color(0xFFDC2626), // Red text
        };
      case "Waitlisted":
        return {
          'bg': Color(0xFFE5E7EB), // Gray bg
          'text': Color(0xFF4B5563), // Gray text
        };
      default:
        return {
          'bg': AppColors.hintText.withOpacity(0.2), // Gray bg
          'text': AppColors.hintText, // Gray text
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get status colors based on lead status
    final statusColors = getStatusColors(widget.currentStatus);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name, Phone Number and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.clientName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.phone,
                            size: 12,
                            color: AppColors.hintText,
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.clientMobileNo,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.hintText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColors['bg'],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    widget.currentStatus,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColors['text'],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Action buttons in a Row
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Edit Details button
                  Expanded(
                    child: _actionButton(
                      icon: FontAwesomeIcons.penToSquare,
                      text: 'Edit Details',
                      bgColor: AppColors.primary.withOpacity(0.1),
                      iconColor: AppColors.primary,
                      textColor: AppColors.primary,
                      onTap: () {},
                    ),
                  ),

                  SizedBox(width: 12),

                  // Change Status button
                  Expanded(
                    child: _actionButton(
                      icon: FontAwesomeIcons.flag,
                      text: 'Change Status',
                      bgColor: Colors.grey.withOpacity(0.1),
                      iconColor: Color(0xFF6B7280),
                      textColor: Color(0xFF6B7280),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
