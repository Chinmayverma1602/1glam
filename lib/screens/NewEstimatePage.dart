import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glam1/widgets/BottomActionBar.dart';

class EstimateScreen extends StatelessWidget {
  const EstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Estimate",
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              "Preview",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.purpleAccent),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              "Business Details",
              _businessDetailsContent(),
              trailingWidget:
                  const Icon(Icons.edit, color: Colors.purpleAccent, size: 18),
            ),
            _buildCard("Services", _servicesContent(),
                trailingWidget: addServiceButton("Add Service")),
            _buildCard("Deposit", _depositContent(),
                trailingWidget: addDepositButton(true)),
            _buildCard("Attachments", _attachmentsContent(),
                trailingWidget: addServiceButton("Add File")),
            _buildCard(
              "Settings",
              _settingsContent(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        leftButtonText: "Save Draft",
        rightButtonText: "Send Estimate",
      ),
    );
  }

  Widget addServiceButton(String text) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, color: Colors.purpleAccent, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.purpleAccent,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

 Widget addDepositButton(bool value) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isSwitched = true; // Persistent state for toggle

      return GestureDetector(
        onTap: () {
          setState(() {
            isSwitched = !isSwitched; // Toggle switch on tap
          });
        },
        child: Row(
          children: [
            Text(
              "Required",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13, // Slightly smaller size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              setState(() {
                value = !value;
                // onChanged(value); // Callback for external state handling
              });
            },
            child: Transform.scale(
              scale: 0.8, // Reduce switch size
              child: Switch(
                value: value,
                onChanged: (val) {
                  setState(() {
                    value = val;
                   
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Color(0xFFC026D3),
              ),
            ),
          );
        },
      ),
          ],
        ),
      );
    },
  );
}



  Widget _buildCard(String title, Widget content, {Widget? trailingWidget}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              if (trailingWidget != null)
                trailingWidget, // ✅ Show only if passed
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _businessDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Business Name",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        Text("Glamour Studio",
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text("Contact Details",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        Text("+91 98765 43210",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        Text("glamour@studio.com",
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _servicesContent() {
    return Column(
      children: [
        _serviceItem("Bridal Makeup", "₹15,000"),
        const SizedBox(height: 6),
        const Divider(),
        const SizedBox(height: 6),
        _subtotalRow("Subtotal", "₹15,000"),
      ],
    );
  }

  Widget _serviceItem(String service, String price) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              Text(price,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.edit, color: Colors.purpleAccent, size: 18),
              SizedBox(width: 6),
              Icon(Icons.delete, color: Colors.red, size: 18),
            ],
          )
        ],
      ),
    );
  }

  Widget _subtotalRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(amount,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _depositContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text("Required", style: GoogleFonts.poppins(fontSize: 14)),
        //     Switch(value: true, onChanged: (val) {}),
        //   ],
        // ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "5000",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text("or", style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "30",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _attachmentsContent() {
    return Row(
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
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.delete, color: Colors.red, size: 18),
      ],
    );
  }

  Widget _settingsContent() {
    return Column(
      children: [
        _settingSwitch("Auto generate invoice on acceptance", false),
        _settingSwitch("Require signature", true),
      ],
    );
  }

  Widget _settingSwitch(String title, bool value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              setState(() {
                value = !value;
                // onChanged(value); // Callback for external state handling
              });
            },
            child: Transform.scale(
              scale: 0.8, // Reduce switch size
              child: Switch(
                value: value,
                onChanged: (val) {
                  setState(() {
                    value = val;
                   
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Color(0xFFC026D3),
              ),
            ),
          );
        },
      ),
    ],
  );
}

}
