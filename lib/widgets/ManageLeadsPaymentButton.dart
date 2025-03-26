import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class ManageLeadsPaymentButton extends StatelessWidget {
  const ManageLeadsPaymentButton({super.key});

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payments",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primary, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'New Estimate',
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),

                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primary, size: 16),
                        SizedBox(width: 2),
                        Text(
                          'New Invoice',
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),

          // Estimates Section
          Text(
            "Estimates",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 16),
          ),
          EstimateCard(
              estimateNumber: 'Estimate #1',
              sentDate: 'Feb 15, 2025',
              dueDate: 'Feb 25, 2025',
              amount: 'Total: ₹20,000',
              status: 'status',
              statusColor: Colors.black),

          SizedBox(height: MediaQuery.of(context).size.height * 0.04),

          Text(
            "Invoices",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 16),
          ),
          InvoiceCard(
              invoiceNumber: 'Invoice #1',
              issuedDate: 'Jan 15, 2025',
              paidDate: 'Jan 18, 2025',
              amount: 'Total: ₹20,000',
              status: 'status',
              statusColor: Colors.black),

          // Invoices Section
        ],
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
      _buildTitleWithBadge(estimateNumber, status, statusColor),
      _buildInfoRow(Icons.calendar_today, "Sent: $sentDate"),
      _buildInfoRow(Icons.access_time, "Due: $dueDate"),
      _buildAmount(amount),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton("Accept", AppColors.primary),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          _buildButton("Decline", Colors.red),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          _buildButton("Send", AppColors.hintText),
        ],
      )
    ]);
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
      _buildTitleWithBadge(invoiceNumber, status, statusColor),
      _buildInfoRow(Icons.calendar_today, "Issued: $issuedDate"),
      _buildInfoRow(Icons.access_time, "Paid: $paidDate"),
      _buildAmount(amount),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton("Send Invoice", AppColors.hintText),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          _buildButton("Download", AppColors.primary),
        ],
      )
    ]);
  }
}

Widget _buildCard(List<Widget> children) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...children.expand((widget) => [widget, SizedBox(height: 8)]).toList()
          ..removeLast(),
      ],
    ),
  );
}

Widget _buildTitleWithBadge(String title, String status, Color badgeColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Text(status,
                style:
                    TextStyle(color: badgeColor, fontWeight: FontWeight.w600)),
            Icon(Icons.arrow_drop_down, color: badgeColor, size: 18),
          ],
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
        Icon(icon, size: 16, color: Colors.purple),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}

Widget _buildAmount(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 8),
    child:
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}

Widget _buildButton(String text, Color color) {
  return OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
    ),
    child: Text(text, style: TextStyle(color: color)),
  );
}
