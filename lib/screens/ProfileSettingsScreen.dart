import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/bussiness_model.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomToast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();

  bool _isLoading = true;
  bool _isEditing = false;
  String? _userId;
  BusinessProfile? _profile;
  String _selectedCode = '+91';
  bool _atMyPlace = false;
  bool _atClientLocation = false;

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
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(Duration(seconds: 1)); // Simulating API call

      // In a real app, you would fetch this data from API
      // For now, using mock data
      _profile = BusinessProfile(
        user: "user123",
        businessName: "Glamour Studio",
        businessType: "Makeup Artist",
        ownerName: "John Anderson",
        phone: "+1 (555) 123-4567",
        address: "123 Fashion Ave, New York, NY 10001",
        atMyPlace: true,
        atClientLocation: true,
      );

      _businessNameController.text = _profile!.businessName;
      _ownerNameController.text = _profile!.ownerName;
      _emailController.text = "john@example.com";

      // Parse phone number to extract country code
      String phone = _profile!.phone;
      if (phone.contains("+")) {
        int spaceIndex = phone.indexOf(" ");
        if (spaceIndex > 0) {
          _selectedCode = phone.substring(0, spaceIndex);
          _phoneController.text = phone
              .substring(spaceIndex + 1)
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll("-", "");
        } else {
          _phoneController.text = phone;
        }
      } else {
        _phoneController.text = phone;
      }

      _addressController.text = _profile!.address;
      _businessTypeController.text = _profile!.businessType;
      _atMyPlace = _profile!.atMyPlace;
      _atClientLocation = _profile!.atClientLocation;
    } catch (e) {
      print("Error loading profile: $e");
      CustomToast.showError(
        context,
        message: "Failed to load profile information",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(Duration(seconds: 1)); // Simulating API call

      // In a real app, you would update the profile via API
      _profile = BusinessProfile(
        user: _profile!.user,
        businessName: _businessNameController.text,
        businessType: _businessTypeController.text,
        ownerName: _ownerNameController.text,
        phone: "$_selectedCode ${_phoneController.text}",
        address: _addressController.text,
        atMyPlace: _atMyPlace,
        atClientLocation: _atClientLocation,
      );

      CustomToast.showSuccess(
        context,
        message: "Profile updated successfully",
      );

      setState(() => _isEditing = false);
    } catch (e) {
      print("Error saving profile: $e");
      CustomToast.showError(
        context,
        message: "Failed to update profile",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.title,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.primary,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading profile...",
                    style: GoogleFonts.poppins(
                      color: AppColors.hintText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildProfileHeader(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Business Information'),
                        const SizedBox(height: 12),
                        _buildInfoContainer([
                          _buildTextField(
                            'Business Name',
                            _businessNameController,
                            icon: Icons.business,
                            enabled: _isEditing,
                          ),
                          _buildTextField(
                            'Business Type',
                            _businessTypeController,
                            icon: Icons.category,
                            enabled: _isEditing,
                          ),
                          _buildTextField(
                            'Business Address',
                            _addressController,
                            icon: Icons.location_on,
                            enabled: _isEditing,
                          ),
                        ]),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Personal Information'),
                        const SizedBox(height: 12),
                        _buildInfoContainer([
                          _buildTextField(
                            'Full Name',
                            _ownerNameController,
                            icon: Icons.person,
                            enabled: _isEditing,
                          ),
                          _buildTextField(
                            'Email',
                            _emailController,
                            icon: Icons.email,
                            enabled: false, // Email is not editable
                          ),
                          _buildPhoneField(),
                        ]),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Service Locations'),
                        const SizedBox(height: 12),
                        _buildInfoContainer([
                          _buildServiceLocationTile(
                            'At my place',
                            _atMyPlace,
                            (value) {
                              if (_isEditing) {
                                setState(() {
                                  _atMyPlace = value!;
                                });
                              }
                            },
                          ),
                          Divider(color: Colors.grey.shade200, height: 1),
                          _buildServiceLocationTile(
                            'At client location',
                            _atClientLocation,
                            (value) {
                              if (_isEditing) {
                                setState(() {
                                  _atClientLocation = value!;
                                });
                              }
                            },
                          ),
                        ]),
                        if (_isEditing) ...[
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: "Cancel",
                                  color: Colors.grey.shade300,
                                  textColor: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                      _loadUserProfile(); // Reset form
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  text: "Save Changes",
                                  color: AppColors.primary,
                                  textColor: Colors.white,
                                  onPressed: _saveProfile,
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Add extra padding at the bottom for scrolling
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Settings tab
        onTap: (index) {
          if (index == 4) return; // Already on settings

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/leads');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/calender');
              break;
            case 3:
              // Payments tab - add appropriate navigation when available
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  Color(0xFF8B5CF6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitials(_ownerNameController.text),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _ownerNameController.text,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _businessTypeController.text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.title,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color: AppColors.primary.withOpacity(0.7),
                      size: 22,
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.borderTextField,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.borderTextField,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              filled: !enabled,
              fillColor: enabled ? null : Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceLocationTile(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone Number',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isEditing
                        ? AppColors.borderTextField
                        : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: !_isEditing ? Colors.grey.shade100 : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCode,
                    onChanged: _isEditing
                        ? (String? newValue) {
                            setState(() {
                              _selectedCode = newValue!;
                            });
                          }
                        : null,
                    items: countryList.map((country) {
                      return DropdownMenuItem<String>(
                        value: country['code'],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "${country['flag']} ${country['code']}",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
                    borderRadius: BorderRadius.circular(12),
                    isDense: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: _isEditing
                          ? AppColors.primary.withOpacity(0.7)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppColors.primary.withOpacity(0.7),
                      size: 22,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.borderTextField,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.borderTextField,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    filled: !_isEditing,
                    fillColor: _isEditing ? null : Colors.grey.shade100,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "?";

    List<String> nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }
}

void showLoadingDialog(BuildContext context,
    {String? text,
    LoadingAnimationType type = LoadingAnimationType.staggeredDotsWave}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLoadingAnimation(
              size: 40,
              text: text ?? "Loading...",
              type: type,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
      );
    },
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
