import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/bussiness_model.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/services/bussiness_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomCheckBox.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMePage extends StatefulWidget {
  final bussinessType;
  final selectedEmail;
  const AboutMePage({super.key, this.bussinessType, this.selectedEmail});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _atMyPlace = false;
  bool _atClientLocation = false;

  void _submitForm() async {
    BusinessProfile profile = BusinessProfile(
      user: widget.selectedEmail,
      businessName: _businessNameController.text,
      businessType: widget.bussinessType,
      ownerName: _ownerNameController.text,
      phone: _phoneController.text,
      address: "123 Main Street, NY",
      atMyPlace: _atMyPlace,
      atClientLocation: _atClientLocation,
    );

    bool success = await BusinessProfileService.createBusinessProfile(profile);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddressDetailsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save business profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "About You",
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 75, 14, 83),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: CustomTextInputField(
                hintText: "Business Name",
                icon: Icons.store,
                keyboardType: TextInputType.name,
                controller: _businessNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomTextInputField(
                hintText: "Your Name",
                icon: Icons.person,
                keyboardType: TextInputType.name,
                controller: _ownerNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomTextInputField(
                hintText: "Phone number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                "Where do you provide your services?",
                style: GoogleFonts.lato(color: AppColors.title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomCheckBox(
                onChanged: (bool? value) {
                  setState(() {
                    _atMyPlace = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                location: 'At My Place',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomCheckBox(
                onChanged: (bool? value) {
                  setState(() {
                    _atClientLocation = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
                location: 'At Client Location',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: CustomButton(
                  text: "Continue",
                  color: AppColors.subtitle,
                  onPressed: _submitForm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
