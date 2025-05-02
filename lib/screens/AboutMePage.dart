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
import 'package:glam1/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading = false;
  String? _userId;

  // List of country codes with flags
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

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    // Set default values for testing if needed
    _businessNameController.text = "Test Business";
    _ownerNameController.text = "Test Owner";
    _phoneController.text = "1234567890";
  }

  Future<void> _fetchUserId() async {
    // Try multiple sources for user ID

    // 1. Check if we have a direct user ID from TokenManager
    final userId = await TokenManager.getUserId();
    if (userId != null && userId.isNotEmpty) {
      setState(() {
        _userId = userId;
      });
      print("Using TokenManager userId: $_userId");
      return;
    }

    // 2. Check for selectedEmail from widget
    if (widget.selectedEmail != null && widget.selectedEmail.isNotEmpty) {
      setState(() {
        _userId = widget.selectedEmail;
      });
      print("Using selectedEmail as userId: $_userId");
      return;
    }

    // 3. Check SharedPreferences directly as a last resort
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('user_id');
    if (storedUserId != null && storedUserId.isNotEmpty) {
      setState(() {
        _userId = storedUserId;
      });
      print("Using SharedPreferences userId: $_userId");
      return;
    }

    // If all fails, use a mock ID for testing (remove in production)
    // setState(() {
    //   _userId = "68147786cc7c79ccbf7e39f1"; // Sample ID for testing
    // });
    // print("Using mock userId for testing: $_userId");

    print("USER ID NOT FOUND - please log in again");
  }

  void _submitForm() async {
    if (_businessNameController.text.isEmpty ||
        _ownerNameController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    // Fetch user ID again just to be sure
    if (_userId == null || _userId!.isEmpty) {
      await _fetchUserId();
    }

    // Final check for user ID
    if (_userId == null || _userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please log in again.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print("Creating business profile with user ID: $_userId");

    BusinessProfile profile = BusinessProfile(
      user: _userId!,
      businessName: _businessNameController.text,
      businessType:
          widget.bussinessType ?? "Other", // Default to "Other" if null
      ownerName: _ownerNameController.text,
      phone: "$_selectedCode${_phoneController.text}",
      address: "123 Main Street, NY", // Default address
      atMyPlace: _atMyPlace,
      atClientLocation: _atClientLocation,
    );

    try {
      bool success =
          await BusinessProfileService.createBusinessProfile(profile);
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressDetailsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to save business profile. Please try again.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
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
                // Debug text to show user ID (remove in production)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "User ID: ${_userId ?? 'Not found'}",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: AppColors.subtitle)
                    : CustomButton(
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
