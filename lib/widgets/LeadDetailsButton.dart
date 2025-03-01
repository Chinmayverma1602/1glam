import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';

class LeadDetailsButton extends StatefulWidget {
  const LeadDetailsButton({super.key});

  @override
  State<LeadDetailsButton> createState() => _LeadDetailsButtonState();
}

class _LeadDetailsButtonState extends State<LeadDetailsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
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
                        ),
                  ),
                  CustomSubTitle(
                      subtitle: "Bridal Makeup",
                      color: AppColors.hintText),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.inquiryButtonColor, 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Inquiry Received",
                  style: TextStyle(
                    color: AppColors.inquiryTextColor,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 16),

         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoContainer(
                icon: FontAwesomeIcons.calendar,
                text: "20 Feb 2025",
                
                iconColor: AppColors.primary
              ),
              _infoContainer(
                icon: FontAwesomeIcons.clock,
                text: "10:00 AM",
                // bgColor: Colors.green.shade50,
                iconColor: AppColors.primary
              ),
            ],
          ),

          SizedBox(height: 16),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionButton(
                icon: FontAwesomeIcons.whatsapp,
                text: "Message",
                bgColor: AppColors.primary,
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
              _actionButton(
                icon: FontAwesomeIcons.telegram,
                text: "Send Form",
                bgColor: AppColors.primary.withOpacity(0.1),
                iconColor: AppColors.primary,
                textColor:  AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoContainer({
    required IconData icon,
    required String text,
    
    required Color iconColor,
  }) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: iconColor),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
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
  }) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 20, color: iconColor),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}
