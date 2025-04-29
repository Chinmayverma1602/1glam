import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManageLeadsPaymentButton extends StatelessWidget {
  const ManageLeadsPaymentButton({super.key});

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payments",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Flexible(
                child: Wrap(
                  spacing: 8,
                  children: [
                    _actionButton(
                      icon: FontAwesomeIcons.fileInvoice,
                      text: 'New Estimate',
                      bgColor: AppColors.primary.withOpacity(0.1),
                      iconColor: AppColors.primary,
                      textColor: AppColors.primary,
                      onTap: () {},
                    ),
                    _actionButton(
                      icon: FontAwesomeIcons.fileInvoiceDollar,
                      text: 'New Invoice',
                      bgColor: AppColors.primary.withOpacity(0.1),
                      iconColor: AppColors.primary,
                      textColor: AppColors.primary,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Estimates Section
          Text(
            "Estimates",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          EstimateCard(
            estimateNumber: 'Estimate #1',
            sentDate: 'Feb 15, 2025',
            dueDate: 'Feb 25, 2025',
            amount: 'Total: ₹20,000',
            status: 'Pending',
            statusColor: Colors.orange,
          ),

          SizedBox(height: 24),

          Text(
            "Invoices",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          InvoiceCard(
            invoiceNumber: 'Invoice #1',
            issuedDate: 'Jan 15, 2025',
            paidDate: 'Jan 18, 2025',
            amount: 'Total: ₹20,000',
            status: 'Paid',
            statusColor: Colors.green,
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 10,
              color: iconColor,
            ),
            SizedBox(width: 4),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11,
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

class EstimateCard extends StatelessWidget {
  final String estimateNumber;
  final String sentDate;
  final String dueDate;
  final String amount;
  final String status;
  final Color statusColor;

  const EstimateCard({
    super.key,
    required this.estimateNumber,
    required this.sentDate,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard([
      _buildTitleWithBadge(context, estimateNumber, status, statusColor),
      _buildInfoRow(FontAwesomeIcons.calendar, "Sent: $sentDate"),
      _buildInfoRow(FontAwesomeIcons.clock, "Due: $dueDate"),
      _buildAmount(amount),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          _buildActionButton("Accept", AppColors.primary),
          _buildActionButton("Decline", Colors.red),
          _buildActionButton("Send", AppColors.hintText),
        ],
      )
    ]);
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String issuedDate;
  final String paidDate;
  final String amount;
  final String status;
  final Color statusColor;

  const InvoiceCard({
    super.key,
    required this.invoiceNumber,
    required this.issuedDate,
    required this.paidDate,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard([
      _buildTitleWithBadge(context, invoiceNumber, status, statusColor),
      _buildInfoRow(FontAwesomeIcons.calendar, "Issued: $issuedDate"),
      _buildInfoRow(FontAwesomeIcons.clock, "Paid: $paidDate"),
      _buildAmount(amount),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          _buildActionButton("Send Invoice", AppColors.hintText),
          _buildActionButton("Download", AppColors.primary),
        ],
      )
    ]);
  }

  Widget _buildActionButton(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

Widget _buildCard(List<Widget> children) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          spreadRadius: 1,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...children.expand((widget) => [widget, SizedBox(height: 10)]).toList()
          ..removeLast(),
      ],
    ),
  );
}

Widget _buildTitleWithBadge(
    BuildContext context, String title, String status, Color badgeColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: badgeColor,
          ),
        ),
      ),
    ],
  );
}

Widget _buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: EdgeInsets.only(top: 4),
    child: Row(
      children: [
        FaIcon(icon, size: 12, color: AppColors.primary),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildAmount(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}
