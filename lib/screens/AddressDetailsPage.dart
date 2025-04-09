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

  // Text controllers
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController boothController = TextEditingController();

  final AddressService _addressService = AddressService();

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
    final String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'Glam1App'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("API Response: ${response.body}");
        final Map<String, dynamic> address = data['address'];

        String street = address['road'] ?? '';
        if (address['house_number'] != null) {
          street = "${address['house_number']} $street";
        }

        String city =
            address['city'] ?? address['town'] ?? address['village'] ?? '';
        String state = address['state'] ?? '';
        String postcode = address['postcode'] ?? '';
        print("Street: $street");
        print("City: $city");
        print("State: $state");
        print("Postcode: $postcode");

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
      } else {
        await _getAddressFromGeocoding(position);
      }
    } catch (e) {
      print('Error fetching address from Nominatim: $e');
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

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? selectedEmail = prefs.getString('user_email');
      String? userEmail = selectedEmail;
      if (userEmail == null) {
        throw Exception("Failed to fetch user email.");
      }

      final address = UserAddress(
        user: userEmail, // Use dynamic user email
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text.isEmpty
            ? null
            : addressLine2Controller.text,
        city: cityController.text,
        zipCode: zipController.text,
        state: selectedState!,
        isSharedLocation: isSharedLocation,
        boothNo: boothController.text,
      );

      final savedAddress = await _addressService.saveAddress(address);
      if (savedAddress != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TravellingInfoPage()));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
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
            SizedBox(height: 25),
            // Modify the current location button to be clickable
            GestureDetector(
              onTap: isLoadingLocation ? null : _getCurrentLocation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.045,
                width: MediaQuery.of(context).size.width * 0.48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(isLoadingLocation ? Icons.sync : Icons.pin_drop,
                        color: AppColors.subtitle, size: 18),
                    SizedBox(width: MediaQuery.of(context).size.width*0.025),
                    Text(
                        isLoadingLocation
                            ? "Getting location..."
                            : "Use current location",
                        style: TextStyle(color: AppColors.subtitle))
                  ]),
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
