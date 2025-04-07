import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ManageLeadPage.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:intl/intl.dart'; // Import the model

class LeadDetailsButton extends StatefulWidget {
  final LeadsResponse lead; // Accepts a lead object

  const LeadDetailsButton({super.key, required this.lead});

  @override
  State<LeadDetailsButton> createState() => _LeadDetailsButtonState();
}

String formatTime(String timeString) {
  try {
    DateTime dateTime = DateTime.parse("1970-01-01 $timeString"); // Add a dummy date
    return DateFormat.jm().format(dateTime); // Converts to 12-hour AM/PM format
  } catch (e) {
    return timeString; // Fallback in case of error
  }
}

String formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("d MMM yyyy").format(date).toUpperCase(); // "1 APR 2025"
  } catch (e) {
    return dateString; // Return as-is if parsing fails
  }
}

class _LeadDetailsButtonState extends State<LeadDetailsButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageLeadPage(lead:widget.lead.data  ,)),
        );
      },
      child: Container(
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
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        widget.lead.data.clientName, // Using dynamic data
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: CustomSubTitle(
                        subtitle: widget.lead.data.servicesOpted.isNotEmpty
                            ? widget.lead.data.servicesOpted.length == 1
                                ? widget
                                    .lead.data.servicesOpted.first.serviceName
                                : "${widget.lead.data.servicesOpted.first.serviceName} + ${widget.lead.data.servicesOpted.length - 1}"
                            : "No Service Selected", // Using dynamic data
                        color: AppColors.hintText,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.inquiryButtonColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    widget.lead.data.leadStatus, // Using dynamic data
                    style: TextStyle(color: AppColors.inquiryTextColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoContainer(
                  icon: FontAwesomeIcons.calendar,
                  text: formatDate(widget.lead.data.bookingDate), // Using dynamic data
                  iconColor: AppColors.primary,
                ),
                _infoContainer(
                  icon: FontAwesomeIcons.clock,
                  text: formatTime(widget.lead.data.fromTime), // Using dynamic data
                  iconColor: AppColors.primary,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  textColor: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
