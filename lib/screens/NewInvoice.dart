import 'package:flutter/material.dart';
import 'package:glam1/widgets/BottomActionBar.dart';
import 'package:google_fonts/google_fonts.dart';

class NewInvoicePage extends StatelessWidget {
  const NewInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "New Invoice",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              "Preview",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.purple,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInfoCard("Business Details", [
                _buildInfoRow("Business Name", "Glamour Studio"),
                _buildInfoRow("Contact Details", "+91 98765 43210\nglamour@studio.com"),
              ]),
              _buildInfoCard("Client Details", [
                _buildInfoRow("Client Name", "Sarah Johnson"),
                _buildInfoRow("Contact Details", "+91 98765 43210\nsarah@email.com"),
              ]),
              _buildInfoCard("Invoice Details", [
                Padding(
                  padding: const EdgeInsets.only(right:48.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween
                    ,children: [
                    
                    Column(children: [_buildInfoRow("Invoice Number", "INV-2025-001"),
                  _buildInfoRow("Date", "Jan 15, 2025"),
                  
                    ],),
                    Column(
                      children: [
                        _buildInfoRow("Due Date", "Jan 30, 2025"),
                  _buildInfoRow("Payment Terms", "Net 15"),
                  
                      ],
                    )
                  ],),
                )
                
                
              ]),
              _buildItemsSection(),
              _buildTotalSection(),
              _buildInfoCard("Terms & Conditions", [
                _buildBulletPoint("Payment is due within 15 days"),
                _buildBulletPoint("Late payment will incur a 5% penalty"),
                _buildBulletPoint("All prices are inclusive of taxes"),
              ], showEditIcon: false),
              _buildInfoCard("Notes", [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    "Thank you for your business! Please make payment to Bank Account: XXXX-XXXX-XXXX-1234",
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ], showEditIcon: false),
              const SizedBox(height: 20),
              
              // _buildFooterButtons(),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        leftButtonText: "Save Draft",
        rightButtonText: "Send Invoice",
        onLeftPressed: () {
          // Handle Save Draft action
        },
        onRightPressed: () {
          // Handle Send Invoice action
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children, {bool showEditIcon = true}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                if (showEditIcon)
                  const Icon(Icons.edit, color: Colors.purple, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(value,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Items", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    const Icon(Icons.add, color: Colors.purple, size: 16),
                    Text(" Add Item",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.purple)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bridal Makeup", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text("₹15,000", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                  const Icon(Icons.edit, color: Colors.purple, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalRow("Subtotal", "₹15,000"),
            _buildTotalRow("Tax (18%)", "₹2,700"),
            const Divider(),
            _buildTotalRow("Total", "₹17,700", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
          Text(value,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  // Widget _buildFooterButtons() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: OutlinedButton(
  //           onPressed: () {},
  //           child: Text("Save Draft", style: GoogleFonts.poppins(fontSize: 13)),
  //         ),
  //       ),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: ElevatedButton(
  //           onPressed: () {},
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
  //           child: Text("Send Invoice", style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
