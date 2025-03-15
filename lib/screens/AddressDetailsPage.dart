import 'package:flutter/material.dart';
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

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key});

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  bool isSharedLocation = false;
  String? selectedState;
  bool isLoading = false;

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
            Container(
              height: MediaQuery.of(context).size.height * 0.045,
              width: MediaQuery.of(context).size.width * 0.50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.pin_drop, color: AppColors.subtitle, size: 18),
                  SizedBox(width: 10),
                  Text("Use current location",
                      style: TextStyle(color: AppColors.subtitle))
                ]),
              ),
            ),
            SizedBox(height: 35),
            CustomTextInputField(
              hintText: "Select address line 1",
              icon: Icons.pin_drop_outlined,
              controller: addressLine1Controller,
              keyboardType: TextInputType.streetAddress,
            ),
            SizedBox(height: 15),
            CustomTextInputField(
              hintText: "Select address line 2(optional)",
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
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.2)),
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
                    keyboardType: TextInputType.streetAddress,
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
    );
  }
}
