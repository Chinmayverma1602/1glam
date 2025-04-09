import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/bussiness_model.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/services/bussiness_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomCheckBox.dart';
import 'package:glam1/widgets/CustomCheckBoxAboutMePage.dart';
import 'package:glam1/widgets/CustomHeader.dart';
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
  String _selectedCode = '+91';
  final List<Map<String, String>> countryList = [
    {'code': '+91', 'flag': '🇮🇳'},
    {'code': '+1', 'flag': '🇺🇸'},
    {'code': '+44', 'flag': '🇬🇧'},
    {'code': '+81', 'flag': '🇯🇵'},
    {'code': '+49', 'flag': '🇩🇪'},
    {'code': '+33', 'flag': '🇫🇷'},
    {'code': '+61', 'flag': '🇦🇺'},
    {'code': '+86', 'flag': '🇨🇳'},
    {'code': '+34', 'flag': '🇪🇸'},
    {'code': '+39', 'flag': '🇮🇹'},
    {'code': '+7', 'flag': '🇷🇺'},
    {'code': '+82', 'flag': '🇰🇷'},
    {'code': '+55', 'flag': '🇧🇷'},
    {'code': '+27', 'flag': '🇿🇦'},
    {'code': '+966', 'flag': '🇸🇦'},
    {'code': '+971', 'flag': '🇦🇪'},
  ];

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                CustomHeader(),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "About You",
                    style: GoogleFonts.inter(
                      color: const Color.fromRGBO(74, 4, 78, 1),
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Tell us more about your business",
                    style: GoogleFonts.inter(
                      color: const Color.fromRGBO(162, 28, 175, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: CustomTextInputField(
                    hintText: "Business Name",
                    icon: Icons.store,
                    keyboardType: TextInputType.name,
                    controller: _businessNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: CustomTextInputField(
                    hintText: "Your Name",
                    icon: Icons.person,
                    keyboardType: TextInputType.name,
                    controller: _ownerNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Row(
                    children: [
                      // Country Code Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.travelFeeTextFields, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCode,
                            items: countryList.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['code'],
                                child: Text(
                                    '${country['flag']} ${country['code']}'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCode = val!;
                              });
                            },
                          ),
                        ),
                      ),
                    
                      SizedBox(width: 12),
                    
                      // Phone Number Field (Half Width)
                      Expanded(
                        child: CustomTextInputField(
                          hintText: "Phone number",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    "Where do you provide your services?",
                    style: GoogleFonts.lato(color: AppColors.title),
                  ),
                ),
                CustomCheckBoxAboutMePage(
                  checkboxLabel: 'At My Place',
                  value: _atMyPlace,
                  onChanged: (bool? value) {
                    setState(() {
                      _atMyPlace = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
                CustomCheckBoxAboutMePage(
                  checkboxLabel: 'At Client Location',
                  value: _atClientLocation,
                  onChanged: (bool? value) {
                    setState(() {
                      _atClientLocation = value ?? false;
                    });
                  },
                ),
              ],
            ),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
