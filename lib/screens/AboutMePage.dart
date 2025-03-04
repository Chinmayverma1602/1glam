import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomCheckBox.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Added scroll for better UI on smaller screens
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomHeader(),
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Text(
                "Tell us more about your business",
                style: GoogleFonts.lato(
                  color: AppColors.subtitle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: CustomTextInputField(
                hintText: "Business Name",
                icon: Icons.store,
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomTextInputField(
                hintText: "Your Name",
                icon: Icons.person,
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton2(
                      text: "+91",
                      borderColor: AppColors.primary.withOpacity(0.2),
                      leadingImage: 'assets/images/Frame.svg',
                      trailingImage: 'assets/images/i.svg',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: CustomTextInputField(
                      hintText: "Phone number",
                      icon: Icons.phone_callback,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                "Where do you provide your services?",
                style: GoogleFonts.lato(
                  color: AppColors.title,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomCheckBox(
                onChanged: (bool? value) {
                  setState(() {});
                },
                activeColor: AppColors.primary,
                location: 'At My Place',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomCheckBox(
                onChanged: (bool? value) {
                  setState(() {});
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressDetailsPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
