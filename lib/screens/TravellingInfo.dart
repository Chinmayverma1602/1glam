import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/address_model.dart';
import 'package:glam1/model/travelling_model.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/services/address_service.dart';
import 'package:glam1/services/travelling_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomDistanceSlider.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravellingInfoPage extends StatefulWidget {
  final String fullAddress;
  const TravellingInfoPage({
    super.key,
    required this.fullAddress,
  });

  @override
  State<TravellingInfoPage> createState() => _TravellingInfoPageState();
}

class _TravellingInfoPageState extends State<TravellingInfoPage> {
  late SingleValueDropDownController _paymentController;
  TextEditingController addressController = TextEditingController();
  late SingleValueDropDownController _travelFeeController;
  final TravelFeeService _travelFeeService = TravelFeeService();
  SliderController sliderController = Get.put(SliderController());
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

  final List<DropDownValueModel> _paymentMethods = const [
    DropDownValueModel(name: "Free", value: "free"),
    DropDownValueModel(name: "Starts from", value: "starts from"),
    DropDownValueModel(name: "Fixed", value: "fixed"),
  ];

  final List<DropDownValueModel> _travelFeeOptions = const [
    DropDownValueModel(name: "Per km", value: "per_km"),
    DropDownValueModel(name: "Per mile", value: "per_mile"),
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
    String addressLine1 = addressLine1Controller.text.trim();
    String addressLine2 = addressLine2Controller.text.trim();
    String city = cityController.text.trim();
    String zip = zipController.text.trim();

    addressController.text = [addressLine1, addressLine2, city, zip]
        .where((element) => element.isNotEmpty)
        .join(', ');

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

          // if (state.isNotEmpty) {
          //   for (String indianState in indianStates) {
          //     if (indianState.toLowerCase().contains(state.toLowerCase()) ||
          //         state.toLowerCase().contains(indianState.toLowerCase())) {
          //       selectedState = indianState;
          //       break;
          //     }
          //   }
          // }
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
            // for (String indianState in indianStates) {
            //   if (indianState.toLowerCase().contains(adminArea.toLowerCase()) ||
            //       adminArea.toLowerCase().contains(indianState.toLowerCase())) {
            //     selectedState = indianState;
            //     break;
            //   }
            // }
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TravellingInfoPage(
                      fullAddress: address.toString(),
                    )));
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
  void initState() {
    super.initState();
    _paymentController = SingleValueDropDownController();
    _travelFeeController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _travelFeeController.dispose();
    super.dispose();
  }

  void _submitTravelFee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedEmail = prefs.getString('user_email') ?? "";
    TravelFee travelFee = TravelFee(
      user: selectedEmail,
      feeType: _travelFeeController.dropDownValue?.value ?? "",
      paymentMethod: _paymentController.dropDownValue?.value ?? "",
      maxDistance: sliderController.sliderValue.value.toInt().toString(),
    );

    bool success = await _travelFeeService.submitTravelFee(travelFee);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesInfoPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit travel fee.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              CustomHeader(),
              const SizedBox(height: 35),
              CustomTitle(title: "What is your travel fee?"),
              const SizedBox(height: 35),
              DropDownTextField(
                controller: _paymentController,
                listSpace: 2,
                dropdownRadius: 12,
                textFieldDecoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.travelFeeTextFields, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  hintText: "Select Payment Method",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/leading.svg',
                      width: 24,
                      height: 24,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                dropDownList: _paymentMethods,
              ),
              const SizedBox(height: 15),
              DropDownTextField(
                controller: _travelFeeController,
                listSpace: 2,
                dropdownRadius: 12,
                textFieldDecoration: InputDecoration(
                  hintText: "Travel Fee per km/mile",
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    size: 24,
                    color: AppColors.primary,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.travelFeeTextFields, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                dropDownList: _travelFeeOptions,
              ),
              const SizedBox(height: 15),
              CustomDistanceSlider(),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Enter Address',
                        prefixIcon:
                            Icon(Icons.location_on, color: AppColors.primary),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.travelFeeTextFields,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.travelFeeTextFields,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15), // spacing between field and icon
                  IconButton(
                    onPressed: isLoadingLocation ? null : _getCurrentLocation,
                    icon: Icon(isLoadingLocation ? Icons.sync : Icons.pin_drop,
                          color: AppColors.subtitle, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.hintText, width: 0.4)),
                child: SvgPicture.asset(
                  'assets/images/Frame.svg',
                  fit: BoxFit.contain,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              CustomSubTitle(
                subtitle: "Travel & Fee Policy (Optional)",
                color: AppColors.text,
              ),
              const SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.travelFeeTextFields, width: 1.4),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Travel to restricted areas, congested zone...",
                    style: TextStyle(fontSize: 16, color: AppColors.hintText),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              CustomButton(
                text: "Skip for now",
                color: Colors.white,
                textColor: AppColors.primary,
                onPressed: () {},
                border: false,
                elevation: 0.1,
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "Continue",
                color: AppColors.subtitle,
                onPressed: _submitTravelFee,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderController extends GetxController {
  RxDouble sliderValue = 0.0.obs;
}
