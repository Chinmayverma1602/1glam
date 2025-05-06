import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/bussiness_model.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/services/bussiness_service.dart';
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
      // Get combined profile data from APIs
      final combinedProfile =
          await BusinessProfileService.getCombinedUserProfile();

      // Check if there's an error that might be due to token issues
      if (combinedProfile.containsKey('error') &&
          combinedProfile['error'] != null &&
          (combinedProfile['error'].toString().contains("401") ||
              combinedProfile['error'].toString().contains("Unauthorized"))) {
        // Try token refresh directly - using api_service's TokenManager
        String? newToken = await TokenManager.refreshToken();

        if (newToken != null) {
          // Token refreshed, try loading again
          final retryProfile =
              await BusinessProfileService.getCombinedUserProfile();
          if (!retryProfile.containsKey('error') ||
              retryProfile['error'] == null) {
            // Successfully loaded after refresh
            _handleProfileData(retryProfile);
            return;
          }
        }

        // If we couldn't refresh token through normal means, try a different approach
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Check if we have Firebase token as a backup
        String? firebaseToken = prefs.getString('firebase_token');
        if (firebaseToken != null && firebaseToken.isNotEmpty) {
          print("Using Firebase token as backup");
          await TokenManager.saveToken(firebaseToken);

          // Try loading with Firebase token
          final firebaseRetryProfile =
              await BusinessProfileService.getCombinedUserProfile();
          if (!firebaseRetryProfile.containsKey('error') ||
              firebaseRetryProfile['error'] == null) {
            _handleProfileData(firebaseRetryProfile);
            return;
          }
        }

        // If we reach here, all token refresh methods failed
        // Check if we at least have some data in SharedPreferences to display
        String? businessName = prefs.getString('user_business_name');
        String? userName = prefs.getString('user_name');
        String? userEmail = prefs.getString('user_email');

        if ((businessName != null && businessName.isNotEmpty) ||
            (userName != null && userName.isNotEmpty)) {
          // We have some data, let's use it to create a minimal profile
          Map<String, dynamic> offlineProfile = {
            'name': userName ?? "",
            'email': userEmail ?? "",
            'userId': prefs.getString('user_id') ?? userEmail ?? "",
            'profile': null
          };

          _handleProfileData(offlineProfile);

          // Show a warning that we're using cached data
          CustomToast.showWarning(
            context,
            message: "Using cached data. Some features may be limited.",
          );

          return;
        }

        // If we reach here, even token refresh failed and we don't have cached data
        CustomToast.showError(
          context,
          message: "Your session has expired. Please log in again.",
        );

        // Redirect to login after a short delay
        Future.delayed(Duration(seconds: 2), () {
          LoginServiceApi.logout();
        });
        return;
      }

      _handleProfileData(combinedProfile);
    } catch (e) {
      print("Error loading profile: $e");
      if (e.toString().contains("401") ||
          e.toString().contains("Unauthorized")) {
        // Try to use any locally cached data first
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? businessName = prefs.getString('user_business_name');
        String? userName = prefs.getString('user_name');
        String? userEmail = prefs.getString('user_email');

        if ((businessName != null && businessName.isNotEmpty) ||
            (userName != null && userName.isNotEmpty)) {
          // We have some data, let's use it to create a minimal profile
          Map<String, dynamic> offlineProfile = {
            'name': userName ?? "",
            'email': userEmail ?? "",
            'userId': prefs.getString('user_id') ?? userEmail ?? "",
            'profile': null
          };

          _handleProfileData(offlineProfile);

          // Show a warning that we're using cached data
          CustomToast.showWarning(
            context,
            message: "Using cached data. Some features may be limited.",
          );

          return;
        }

        CustomToast.showError(
          context,
          message: "Your session has expired. Please log in again.",
        );
        // Redirect to login
        Future.delayed(Duration(seconds: 2), () {
          LoginServiceApi.logout();
        });
      } else {
        CustomToast.showError(
          context,
          message: "Failed to load profile: ${e.toString()}",
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleProfileData(Map<String, dynamic> combinedProfile) {
    // Set the business profile from the combined data
    _profile = combinedProfile['profile'];

    if (_profile == null) {
      // If there's no profile yet, create a new empty one
      String? userId = combinedProfile['userId'];
      if (userId == null || userId.isEmpty) {
        // Try to get from shared preferences
        SharedPreferences.getInstance().then((prefs) {
          String? userIdFromPrefs =
              prefs.getString('user_id') ?? prefs.getString('user_email') ?? '';

          if (userIdFromPrefs == null || userIdFromPrefs.isEmpty) {
            throw Exception("Unable to determine user ID");
          }

          _createEmptyProfile(userIdFromPrefs, combinedProfile['name'] ?? "",
              combinedProfile['email'] ?? "");
        });
      } else {
        _createEmptyProfile(userId, combinedProfile['name'] ?? "",
            combinedProfile['email'] ?? "");
      }
    } else {
      // We have a profile, fill in fields
      _populateFields(combinedProfile);
    }
  }

  void _createEmptyProfile(String userId, String userName, String userEmail) {
    // Create an empty profile
    _profile = BusinessProfile(
      user: userId,
      businessName: "",
      businessType: "",
      ownerName: userName.isNotEmpty ? userName : "",
      phone: "",
      address: "",
      atMyPlace: false,
      atClientLocation: false,
    );

    // Populate the form fields with empty values
    _businessNameController.text = "";
    _ownerNameController.text = userName;
    _emailController.text = userEmail;
    _phoneController.text = "";
    _addressController.text = "";
    _businessTypeController.text = "";
    _atMyPlace = false;
    _atClientLocation = false;
  }

  void _populateFields(Map<String, dynamic> combinedProfile) {
    // Get user name and email from combined profile
    String userName = combinedProfile['name'] ?? "";
    String userEmail = combinedProfile['email'] ?? "";

    // If we have a name from the API but the profile owner name is empty, use the API name
    if (userName.isNotEmpty && _profile!.ownerName.isEmpty) {
      _profile = BusinessProfile(
        user: _profile!.user,
        businessName: _profile!.businessName,
        businessType: _profile!.businessType,
        ownerName: userName,
        phone: _profile!.phone,
        address: _profile!.address,
        atMyPlace: _profile!.atMyPlace,
        atClientLocation: _profile!.atClientLocation,
      );
    }

    // Check SharedPreferences for more recent business data
    _checkSharedPreferencesForBusinessData(_profile!);

    // Populate the form fields
    _businessNameController.text = _profile!.businessName;
    _ownerNameController.text = _profile!.ownerName;
    _emailController.text = userEmail;

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

    // Check if we have address data either from the API or SharedPreferences
    if (combinedProfile.containsKey('address') &&
        combinedProfile['address'] != null) {
      Map<String, dynamic> addressData = combinedProfile['address'];
      String fullAddress = "";

      if (addressData.containsKey('address_line_1') &&
          addressData['address_line_1'] != null) {
        fullAddress = addressData['address_line_1'];

        if (addressData.containsKey('address_line_2') &&
            addressData['address_line_2'] != null &&
            addressData['address_line_2'].toString().isNotEmpty) {
          fullAddress += ", ${addressData['address_line_2']}";
        }

        if (addressData.containsKey('city') && addressData['city'] != null) {
          fullAddress += ", ${addressData['city']}";
        }

        if (addressData.containsKey('state') && addressData['state'] != null) {
          fullAddress += ", ${addressData['state']}";
        }

        if (addressData.containsKey('zip_code') &&
            addressData['zip_code'] != null) {
          fullAddress += " - ${addressData['zip_code']}";
        }

        _addressController.text = fullAddress;
      }
    } else {
      // If no address data in combined profile, check SharedPreferences directly
      _checkSharedPreferencesForAddressData();
    }

    _businessTypeController.text = _profile!.businessType;
    _atMyPlace = _profile!.atMyPlace;
    _atClientLocation = _profile!.atClientLocation;

    // Only show success toast when we actually load a profile from the backend
    if (_profile!.businessName.isNotEmpty || _profile!.ownerName.isNotEmpty) {
      CustomToast.showSuccess(
        context,
        message: "Profile loaded successfully",
      );
    }
  }

  // Helper method to check SharedPreferences for business data
  Future<void> _checkSharedPreferencesForBusinessData(
      BusinessProfile profile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check for business name
      String? businessName = prefs.getString('user_business_name');
      if (businessName != null && businessName.isNotEmpty) {
        _profile = BusinessProfile(
          user: profile.user,
          businessName: businessName,
          businessType: profile.businessType,
          ownerName: profile.ownerName,
          phone: profile.phone,
          address: profile.address,
          atMyPlace: profile.atMyPlace,
          atClientLocation: profile.atClientLocation,
        );
      }

      // Check for business type
      String? businessType = prefs.getString('user_business_type');
      if (businessType != null && businessType.isNotEmpty) {
        _profile = BusinessProfile(
          user: _profile!.user,
          businessName: _profile!.businessName,
          businessType: businessType,
          ownerName: _profile!.ownerName,
          phone: _profile!.phone,
          address: _profile!.address,
          atMyPlace: _profile!.atMyPlace,
          atClientLocation: _profile!.atClientLocation,
        );
      }

      // Check for owner name
      String? ownerName = prefs.getString('user_owner_name');
      if (ownerName != null && ownerName.isNotEmpty) {
        _profile = BusinessProfile(
          user: _profile!.user,
          businessName: _profile!.businessName,
          businessType: _profile!.businessType,
          ownerName: ownerName,
          phone: _profile!.phone,
          address: _profile!.address,
          atMyPlace: _profile!.atMyPlace,
          atClientLocation: _profile!.atClientLocation,
        );
      }

      // Check for phone
      String? phone = prefs.getString('user_phone');
      if (phone != null && phone.isNotEmpty) {
        _profile = BusinessProfile(
          user: _profile!.user,
          businessName: _profile!.businessName,
          businessType: _profile!.businessType,
          ownerName: _profile!.ownerName,
          phone: phone,
          address: _profile!.address,
          atMyPlace: _profile!.atMyPlace,
          atClientLocation: _profile!.atClientLocation,
        );
      }
    } catch (e) {
      print("Error getting business data from SharedPreferences: $e");
    }
  }

  // Helper method to check SharedPreferences for address data
  Future<void> _checkSharedPreferencesForAddressData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? addressLine1 = prefs.getString('user_address_line1');
      String? addressLine2 = prefs.getString('user_address_line2');
      String? city = prefs.getString('user_city');
      String? state = prefs.getString('user_state');
      String? zipcode = prefs.getString('user_zipcode');

      // Build full address string
      if (addressLine1 != null && addressLine1.isNotEmpty) {
        String fullAddress = addressLine1;

        if (addressLine2 != null && addressLine2.isNotEmpty) {
          fullAddress += ", $addressLine2";
        }

        if (city != null && city.isNotEmpty) {
          fullAddress += ", $city";
        }

        if (state != null && state.isNotEmpty) {
          fullAddress += ", $state";
        }

        if (zipcode != null && zipcode.isNotEmpty) {
          fullAddress += " - $zipcode";
        }

        // Update address in UI
        _addressController.text = fullAddress;

        // Also update profile address
        if (_profile != null) {
          _profile = BusinessProfile(
            user: _profile!.user,
            businessName: _profile!.businessName,
            businessType: _profile!.businessType,
            ownerName: _profile!.ownerName,
            phone: _profile!.phone,
            address: fullAddress,
            atMyPlace: _profile!.atMyPlace,
            atClientLocation: _profile!.atClientLocation,
          );
        }
      }
    } catch (e) {
      print("Error getting address data from SharedPreferences: $e");
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      // Create updated profile object
      BusinessProfile updatedProfile = BusinessProfile(
        user: _profile!.user,
        businessName: _businessNameController.text,
        businessType: _businessTypeController.text,
        ownerName: _ownerNameController.text,
        phone: "$_selectedCode ${_phoneController.text}",
        address: _addressController.text,
        atMyPlace: _atMyPlace,
        atClientLocation: _atClientLocation,
      );

      // If no existing profile, create a new one
      bool success;
      if (_profile!.businessName.isEmpty && _profile!.ownerName.isEmpty) {
        success =
            await BusinessProfileService.createBusinessProfile(updatedProfile);
      } else {
        // Otherwise update existing one
        success =
            await BusinessProfileService.updateBusinessProfile(updatedProfile);
      }

      if (success) {
        // Update local profile state
        _profile = updatedProfile;

        CustomToast.showSuccess(
          context,
          message: "Profile updated successfully",
        );

        setState(() => _isEditing = false);
      } else {
        // Check if we should try to refresh token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool hasCredentials = prefs.containsKey('user_email') &&
            prefs.containsKey('user_password');

        if (hasCredentials) {
          // Try login again with stored credentials
          String email = prefs.getString('user_email')!;
          String password = prefs.getString('user_password')!;

          final loginResult = await LoginServiceApi.login(email, password);

          if (loginResult != null && !loginResult.containsKey('error')) {
            CustomToast.showInfo(
              context,
              message: "Token refreshed, trying again...",
            );

            // Try saving again after token refresh
            if (_profile!.businessName.isEmpty && _profile!.ownerName.isEmpty) {
              success = await BusinessProfileService.createBusinessProfile(
                  updatedProfile);
            } else {
              success = await BusinessProfileService.updateBusinessProfile(
                  updatedProfile);
            }

            if (success) {
              // Update local profile state
              _profile = updatedProfile;

              CustomToast.showSuccess(
                context,
                message: "Profile updated successfully",
              );

              setState(() => _isEditing = false);
              return;
            }
          }
        }

        throw Exception("Server returned an error");
      }
    } catch (e) {
      print("Error saving profile: $e");
      if (e.toString().contains("401") ||
          e.toString().contains("Unauthorized")) {
        CustomToast.showError(
          context,
          message: "Your session has expired. Please log in again.",
        );
        // Redirect to login
        Future.delayed(Duration(seconds: 2), () {
          LoginServiceApi.logout();
        });
      } else {
        CustomToast.showError(
          context,
          message: "Failed to update profile: ${e.toString()}",
        );
      }
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
          if (!_isLoading && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
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
                    "Loading profile data from server...",
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
    // Determine what name to display
    String displayName = _ownerNameController.text.isNotEmpty
        ? _ownerNameController.text
        : "Your Name";

    // Determine what initials to show
    String initials = _ownerNameController.text.isNotEmpty
        ? _getInitials(_ownerNameController.text)
        : _emailController.text.isNotEmpty
            ? _getInitials(_emailController.text)
            : "?";

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
          Stack(
            alignment: Alignment.center,
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
                    initials,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _isLoading
              ? SizedBox(
                  height: 22,
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 4),
          Text(
            _emailController.text.isNotEmpty
                ? _emailController.text
                : "Your Email",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Only show business type if it's available
          _businessTypeController.text.isNotEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                )
              : Container(),

          // Show business name if available
          _businessNameController.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _businessNameController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
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
