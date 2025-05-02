// ignore_for_file: avoid_print

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/address_model.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:glam1/screens/CalenderScreen.dart';
import 'package:glam1/screens/TravellingInfo.dart';
import 'package:glam1/services/BookingController.dart';
import 'package:glam1/services/address_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 11, minute: 0);
  String selectedLocation = "Studio";

  final addressController = TextEditingController();
  final clientNameController = TextEditingController();
  final clientPhoneNumberController = TextEditingController();
  final _dropdownController = SingleValueDropDownController(
    data: DropDownValueModel(name: "Bridal Makeup", value: "Bridal Makeup"),
  );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 236, 237, 238), // Updated background color
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 237, 238),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("New Booking",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () async {
                // final bookingController = Get.find<BookingController>();
                final BookingController bookingController =
                    Get.put(BookingController());

                // Build new booking map using controller values
                final dynamic newBooking = {
                  "id": "booking_${(DateTime.now().millisecondsSinceEpoch)}",
                  "customer_name": clientNameController.text,
                  "phone_no": clientPhoneNumberController.text,
                  "date": selectedDate,
                  "service_name":
                      _dropdownController.dropDownValue?.name ?? "Unknown",
                  "price": 1000,
                  "duration": 60,
                  "start_time": startTime,
                };

                // Append newBooking to the jsonData list in BookingController
                // bookingController.jsonData.add(newBooking);
                // // bookingController.bookings.add(Booking.fromJson(newBooking)); // ✅ RIGHT

                // bookingController.fetchBookings();
                await bookingController.addBookingToFirestore(newBooking);

                // Optionally, navigate to the next screen which builds using jsonData:
                Get.to(() => CalenderPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionContainer("Date & Time", _dateTimeSelection()),
            _sectionContainer("Client Details", _clientDetails()),
            _sectionContainer("Location", _locationSelection()),
            _sectionContainer("Additional Notes", _notesField()),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

//   void saveAndGoToNextScreen() {
//   final newBooking = {
//     "id": "booking_${DateTime.now().millisecondsSinceEpoch}", // unique-ish
//     "customer_name": clientNameController.text,
//     "phone_no": clientPhoneNumberController.text,
//     "date": DateTime.now().toIso8601String(),
//     "service_name": _dropdownController.dropDownValue?.name ?? "Unknown",
//     "price": 1000, // placeholder, replace if needed
//     "duration": 60, // placeholder, replace if needed
//     "start_time": DateTime.now().toIso8601String(),
//   };

//   jsonData.add(newBooking);

//   Get.to(() => CalenderPage()); // replace with your screen widget
// }

  /// Section Container with rounded white background
  Widget _sectionContainer(String title, Widget child) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  /// Date and Time Selection UI
  Widget _dateTimeSelection() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            spacing: 10,
            children: [
              Text("Date: "),
              _datePickerButton(),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _timePickerButton("Start Time", startTime,
                    (newTime) => setState(() => startTime = newTime)),
                Text("Start Time"),
              ],
            )),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _timePickerButton("End Time", endTime,
                    (newTime) => setState(() => endTime = newTime)),
                Text("End Time"),
              ],
            )),
          ],
        ),
      ],
    );
  }

  /// Date Picker Button
  Widget _datePickerButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() => selectedDate = pickedDate);
        }
      },
      icon: Icon(Icons.calendar_today, size: 16, color: Colors.black),
      label: Text(DateFormat('dd/MM/yyyy').format(selectedDate),
          style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
      ),
    );
  }

  /// Time Picker Button
  Widget _timePickerButton(
      String label, TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
    return ElevatedButton.icon(
      onPressed: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      icon: Icon(Icons.access_time, size: 16, color: Colors.black),
      label: Text(time.format(context), style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
      ),
    );
  }

  /// Client Details Form
  Widget _clientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textInputField(
            "Client Name", "Enter client name", clientNameController),
        _textInputField(
            "Phone Number", "Enter phone number", clientPhoneNumberController),
        _dropdownField("Service Type", "Bridal Makeup"),
      ],
    );
  }

  /// Standard Input Field
  Widget _textInputField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// **Label Text**
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),

        /// **Text Field**
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500]),
            filled: true,
            fillColor: Color(0xFFF7F7F8),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String defaultValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// **Label Text**
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),

        /// **Dropdown Field**
        DropDownTextField(
          controller: _dropdownController,
          textFieldDecoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF7F7F8), // Matches the text field background
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: InputBorder.none, // No border
            enabledBorder: InputBorder.none, // No border when enabled
            focusedBorder: InputBorder.none, // No border when focused
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500]),
          ),
          dropDownList: [
            DropDownValueModel(name: "Bridal Makeup", value: "Bridal Makeup"),
            DropDownValueModel(name: "Hair Styling", value: "Hair Styling"),
            DropDownValueModel(name: "Facial", value: "Facial"),
          ],
          onChanged: (val) {
            print(val);
          },
          dropdownRadius: 8,
        ),
      ],
    );
  }

  /// Location Selection UI
  Widget _locationSelection() {
    return Column(
      children: [
        Row(
          children: [
            _locationButton(
                "Studio", Icons.location_on, selectedLocation == "Studio"),
            SizedBox(width: MediaQuery.of(context).size.width * 0.022),
            _locationButton("Client Location", Icons.home,
                selectedLocation == "Client Location"),
          ],
        ),
        if (selectedLocation == "Client Location")
          Row(
            children: [
              Expanded(
                  child: _textInputField(
                      "Address", "Enter address", addressController)),
              SizedBox(width: 15), // spacing between field and icon
              IconButton(
                onPressed: isLoadingLocation ? null : _getCurrentLocation,
                icon: Icon(isLoadingLocation ? Icons.sync : Icons.pin_drop,
                    color: AppColors.subtitle, size: 30),
              ),
            ],
          ),
      ],
    );
  }

  /// Location Selection Button
  Widget _locationButton(String title, IconData icon, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedLocation = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFFF8EAFB) : Colors.grey[100],
          foregroundColor: isSelected ? AppColors.primary : Colors.black87,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
              vertical: 14), // Increased for better spacing
          elevation: 0, // Removing shadow to match flat UI
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : Colors.black54,
                size: 22),
            SizedBox(height: 4), // Space between icon and text
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600, // Slightly bolder to match UI
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Notes Input Field
  Widget _notesField() {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Add any additional notes or requirements",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
