import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ManageLeadPage.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class LeadDetailsButton extends StatefulWidget {
  final LeadsResponse lead; // Accepts a lead object

  const LeadDetailsButton({super.key, required this.lead});

  @override
  State<LeadDetailsButton> createState() => _LeadDetailsButtonState();
}

String formatTime(String timeString) {
  try {
    DateTime dateTime =
        DateTime.parse("1970-01-01 $timeString"); // Add a dummy date
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
    final statusColors = getStatusColors(widget.lead.data.leadStatus);

    // Determine the second action button text based on lead status
    String actionButtonText;
    IconData actionButtonIcon = FontAwesomeIcons.telegram;

    switch (widget.lead.data.leadStatus) {
      case "Inbound":
        actionButtonText = "Call";
        actionButtonIcon = FontAwesomeIcons.phone;
        break;
      case "Qualifying":
        actionButtonText = "Send Estimate";
        break;
      case "Proposal Sent":
        actionButtonText = "Reminder";
        break;
      case "Proposal Accepted":
        actionButtonText = "Invoice";
        actionButtonIcon = FontAwesomeIcons.fileInvoice;
        break;
      case "Deposit Requested":
        actionButtonText = "Reminder";
        break;
      case "Deposit Received":
        actionButtonText = "Confirm";
        break;
      case "Confirmed":
        actionButtonText = "Complete";
        actionButtonIcon = FontAwesomeIcons.check;
        break;
      case "Closed / Lost":
        actionButtonText = "NA";
        actionButtonIcon = FontAwesomeIcons.ban;
        break;
      case "Waitlisted":
        actionButtonText = "Proposal";
        break;
      default:
        actionButtonText = "Send Form";
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManageLeadPage(lead: widget.lead.data)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: MediaQuery.of(context).size.height * 0.22,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 12),
                      child: Text(
                        widget.lead.data.clientName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                            : "No Service Selected",
                        color: AppColors.hintText,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColors['bg'],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    widget.lead.data.leadStatus,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColors['text'],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoContainer(
                  icon: FontAwesomeIcons.calendar,
                  text: formatDate(widget.lead.data.bookingDate),
                  iconColor: AppColors.primary,
                ),
                _infoContainer(
                  icon: FontAwesomeIcons.clock,
                  text: formatTime(widget.lead.data.fromTime),
                  iconColor: AppColors.primary,
                ),
              ],
            ),
            SizedBox(height: 12),
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
                  icon: actionButtonIcon,
                  text: actionButtonText,
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
      height: 40,
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.light.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 16, color: iconColor),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
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
      height: 40,
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (bgColor == AppColors.primary)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 14, color: iconColor),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
