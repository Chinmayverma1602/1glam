import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/address_model.dart';
import 'package:glam1/screens/TravellingInfo.dart';
import 'package:glam1/services/address_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:glam1/widgets/CustomTitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/constants/api_constants.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key});

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  bool isSharedLocation = false;
  String? selectedState;
  bool isLoading = false;
  bool isLoadingLocation = false;
  String? _userId;

  // Text controllers
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController boothController = TextEditingController();

  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    _fetchUserId();
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

    // 2. Check SharedPreferences directly as a last resort
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('user_id');
    if (storedUserId != null && storedUserId.isNotEmpty) {
      setState(() {
        _userId = storedUserId;
      });
      print("Using SharedPreferences userId: $_userId");
      return;
    }

    print("USER ID NOT FOUND - please log in again");
  }

  // List of Indian states
  final List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry'
  ];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      Position position = await _determinePosition();

      await _getAddressFromGeocoding(position);
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromNominatim(Position position) async {
    // Placeholder mock implementation instead of API call
    try {
      // Mock data
      final Map<String, dynamic> address = {
        'road': 'Example Street',
        'house_number': '123',
        'city': 'Sample City',
        'state': 'Delhi',
        'postcode': '110001'
      };

      String street = address['road'] ?? '';
      if (address['house_number'] != null) {
        street = "${address['house_number']} $street";
      }

      String city =
          address['city'] ?? address['town'] ?? address['village'] ?? '';
      String state = address['state'] ?? '';
      String postcode = address['postcode'] ?? '';

      setState(() {
        addressLine1Controller.text = street;
        cityController.text = city;
        zipController.text = postcode;

        if (state.isNotEmpty) {
          for (String indianState in indianStates) {
            if (indianState.toLowerCase().contains(state.toLowerCase()) ||
                state.toLowerCase().contains(indianState.toLowerCase())) {
              selectedState = indianState;
              break;
            }
          }
        }
      });
    } catch (e) {
      print('Error in mock address: $e');
      await _getAddressFromGeocoding(position);
    }
  }

  Future<void> _getAddressFromGeocoding(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print("Street: ${place.street}");
        setState(() {
          addressLine1Controller.text = place.street ?? '';
          cityController.text = place.locality ?? '';
          zipController.text = place.postalCode ?? '';

          String adminArea = place.administrativeArea ?? '';
          if (adminArea.isNotEmpty) {
            for (String indianState in indianStates) {
              if (indianState.toLowerCase().contains(adminArea.toLowerCase()) ||
                  adminArea.toLowerCase().contains(indianState.toLowerCase())) {
                selectedState = indianState;
                break;
              }
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching address from geocoding: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Could not determine address from your location')),
      );
    }
  }

  // Add this new method for direct API call
  Future<bool> _directApiCall(UserAddress address) async {
    try {
      // Get the auth token from TokenManager
      String? token = await TokenManager.getToken();
      if (token == null) {
        print("No auth token found, using default auth token");
        token = ApiConstants.authToken.replaceAll("Bearer ", "");
      }

      final String apiUrl =
          "https://1glambackend-production.up.railway.app/api/resource/userAddress";

      final Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Create the proper request body structure
      final Map<String, dynamic> requestMap = {
        "user": address.user,
        "address_line_1": address.addressLine1,
        "address_line_2": address.addressLine2 ?? "",
        "city": address.city,
        "zip_code": address.zipCode,
        "state": address.state,
        "is_shared_location": address.isSharedLocation ? 1 : 0,
        "booth_no": address.boothNo ?? "",
      };

      // Log the request details
      print("DIRECT CALL: Making API request to: $apiUrl");
      print("DIRECT CALL: With user ID: ${address.user}");
      final requestBody = jsonEncode(requestMap);
      print("DIRECT CALL: Request body: $requestBody");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      // Log response details
      print("DIRECT CALL: Response status code: ${response.statusCode}");
      print("DIRECT CALL: Response body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("DIRECT CALL: Exception: $e");
      return false;
    }
  }

  Future<void> _saveAddress() async {
    if (addressLine1Controller.text.isEmpty ||
        cityController.text.isEmpty ||
        zipController.text.isEmpty ||
        selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
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

    setState(() => isLoading = true);

    try {
      // Print debug info to verify API URL
      print("Creating address with user ID: $_userId");
      print(
          "API URL: https://1glambackend-production.up.railway.app/api/resource/userAddress");

      final address = UserAddress(
        user: _userId!, // Use the user ID
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text.isEmpty
            ? null
            : addressLine2Controller.text,
        city: cityController.text,
        zipCode: zipController.text,
        state: selectedState!,
        isSharedLocation: isSharedLocation,
        boothNo: boothController.text.isEmpty ? null : boothController.text,
      );

      // Debug print the actual address data being sent
      print("Address data being sent:");
      print("address_line_1: ${address.addressLine1}");
      print("address_line_2: ${address.addressLine2}");
      print("city: ${address.city}");
      print("state: ${address.state}");
      print("zip_code: ${address.zipCode}");
      print("is_shared_location: ${address.isSharedLocation}");
      print("booth_no: ${address.boothNo}");

      // First try with the service
      final savedAddress = await _addressService.saveAddress(address);

      // If service method fails, try direct API call
      bool success = false;
      if (savedAddress != null) {
        success = true;
      } else {
        print("Service method failed, trying direct API call...");
        success = await _directApiCall(address);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address saved successfully')),
        );

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TravellingInfoPage(
                      fullAddress: address.toString(),
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save address. Please try again.')),
        );
      }
    } catch (e) {
      print("Error saving address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    boothController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(),
            SizedBox(height: 25),
            CustomTitle(title: "Enter your address"),
            // Debug text to show user ID (remove in production)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "User ID: ${_userId ?? 'Not found'}",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            SizedBox(height: 25),
            // Redesigned location button to prevent overflow
            GestureDetector(
              onTap: isLoadingLocation ? null : _getCurrentLocation,
              child: Container(
                height: 45, // Fixed height instead of percentage
                // Use a flexible width with constraints
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // This ensures row takes only needed space
                    children: [
                      Icon(isLoadingLocation ? Icons.sync : Icons.pin_drop,
                          color: AppColors.subtitle, size: 18),
                      SizedBox(width: 8),
                      Flexible(
                        // Flexible allows text to resize
                        child: Text(
                          isLoadingLocation
                              ? "Getting location..."
                              : "Use current location",
                          style: TextStyle(
                            color: AppColors.subtitle,
                            fontSize: 13, // Slightly smaller font size
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Handle overflow with ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextInputField(
                      hintText: "Select address line 1",
                      icon: Icons.pin_drop_outlined,
                      controller: addressLine1Controller,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 15),
                    CustomTextInputField(
                      hintText: "Select address line 2 (optional)",
                      icon: Icons.padding_outlined,
                      controller: addressLine2Controller,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 15),
                    CustomTextInputField(
                      hintText: "City",
                      icon: Icons.apartment_outlined,
                      controller: cityController,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedState,
                                hint: Text("Select State"),
                                isExpanded: true,
                                items: indianStates.map((String state) {
                                  return DropdownMenuItem<String>(
                                    value: state,
                                    child: Text(state),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedState = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: CustomTextInputField(
                            hintText: "ZIP",
                            icon: Icons.tag,
                            controller: zipController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          value: isSharedLocation,
                          onChanged: (bool? value) {
                            setState(() {
                              isSharedLocation = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        CustomSubTitle(
                            subtitle: "This is a shared location",
                            color: AppColors.text),
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomTextInputField(
                      hintText: "Booth number",
                      icon: Icons.store_mall_directory_outlined,
                      controller: boothController,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: isLoading ? "Saving..." : "Continue",
                      color: AppColors.subtitle,
                      onPressed: isLoading ? null : _saveAddress,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
