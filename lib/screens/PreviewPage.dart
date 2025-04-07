import 'package:flutter/material.dart';
import 'package:glam1/widgets/BottomActionBar.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatePreviewScreen extends StatelessWidget {
  const EstimatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 234, 234),
        appBar: AppBar(
          title: Text("Preview",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          // centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding:
                  EdgeInsets.only(right: 12), // Adjust right padding if needed
              child: Row(
                spacing: 3,
                mainAxisSize:
                    MainAxisSize.min, // Ensures minimum space is taken
                children: [
                  const Icon(Icons.share, color: Colors.pinkAccent, size: 19),
                  const Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.red),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                const SizedBox(height: 16),
                _buildDetails(),
                const SizedBox(height: 30),
                _buildAttachments(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomActionBar(
            leftButtonText: "Edit", rightButtonText: "Send Estimate"),);
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade300,
          child: Text("GS",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 8),
        Text("Glamour Studio",
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("+91 98765 43210",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        Text("glamour@studio.com",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow("Estimate #", "EST-001", false),
        _buildDetailRow("Date", "Jan 15, 2025", false),
        const SizedBox(height: 15),
        Text("Services",
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        const Divider(),
        _buildDetailRow("Bridal Makeup", "₹15,000", true),
        const Divider(),
        _buildDetailRow("Subtotal", "₹15,000", false),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 243, 247), // Lighter shade for better match
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Ensures ₹5,000 is right-aligned
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Required Deposit",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "30% of total amount",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                "₹5,000",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, bool isService) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isService
              ? Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500))
              : Text(title,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Attachments",
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 243, 247),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Terms.pdf",
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  Text("250 KB",
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildButtons(BuildContext context) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: ElevatedButton(
  //           onPressed: () {},
  //           style: ElevatedButton.styleFrom(
  //             foregroundColor: Colors.black,
  //             backgroundColor: Colors.grey.shade300,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //           child: Text("Edit", style: GoogleFonts.poppins(fontSize: 14)),
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: ElevatedButton(
  //           onPressed: () {},
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.pinkAccent,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //           child: Text("Send Estimate",
  //               style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
