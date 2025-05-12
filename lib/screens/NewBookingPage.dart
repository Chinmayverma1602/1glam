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
import 'dart:async';

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
  final notesController = TextEditingController();
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

  void _saveBookingAndNavigate() async {
    // Validate form
    if (clientNameController.text.isEmpty ||
        clientPhoneNumberController.text.isEmpty ||
        _dropdownController.dropDownValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')));
      return;
    }

    // Show loading indicator
    setState(() => isLoading = true);

    try {
      final BookingController bookingController = Get.put(BookingController());

      // Calculate price based on service (in a real app, this would come from a service price list)
      int price = 0;
      switch (_dropdownController.dropDownValue?.name) {
        case "Bridal Makeup":
          price = 5000;
          break;
        case "Party Makeup":
          price = 2500;
          break;
        case "Hair Styling":
          price = 1500;
          break;
        case "Facial":
          price = 1000;
          break;
        case "Manicure & Pedicure":
          price = 800;
          break;
        default:
          price = 1000;
      }

      // Calculate booking duration based on start and end times
      int durationMinutes = (endTime.hour - startTime.hour) * 60 +
          (endTime.minute - startTime.minute);
      if (durationMinutes <= 0) {
        // Default to 1 hour if end time is earlier than start time
        durationMinutes = 60;
      }

      // Build new booking object with all user-entered data
      final dynamic newBooking = {
        "customer_name": clientNameController.text,
        "phone_no": clientPhoneNumberController.text,
        "date": selectedDate,
        "service_name": _dropdownController.dropDownValue?.name ?? "Unknown",
        "price": price,
        "start_time": startTime,
        "end_time": endTime,
        "duration_minutes": durationMinutes,
        "notes": notesController.text,
        "location": selectedLocation,
        "address": selectedLocation == "Client Location"
            ? addressController.text
            : "Studio",
      };

      // Print booking details for debugging
      print('Creating new booking:');
      print('Customer: ${newBooking["customer_name"]}');
      print('Phone: ${newBooking["phone_no"]}');
      print('Date: ${DateFormat('yyyy-MM-dd').format(newBooking["date"])}');
      print('Service: ${newBooking["service_name"]}');
      print(
          'Time: ${_formatTimeOfDay(newBooking["start_time"])} - ${_formatTimeOfDay(newBooking["end_time"])}');
      print('Location: ${newBooking["location"]}');
      print('Address: ${newBooking["address"]}');
      print('Notes: ${newBooking["notes"]}');

      // Save to API
      bool success = await bookingController.addBookingToApi(newBooking);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking created successfully')),
        );

        // Explicitly refresh bookings before navigating to ensure data is up to date
        await bookingController.fetchBookingsFromApi();

        // Print total bookings after refresh for debugging
        print(
            'Total bookings after creation: ${bookingController.bookings.length}');

        // Navigate to calendar with a slight delay to ensure data is loaded
        await Future.delayed(Duration(milliseconds: 500));
        Get.to(() => CalenderPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to create booking. Please try again.')),
        );
      }
    } catch (e) {
      print('Error saving booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving booking. Please try again.')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Helper function to format TimeOfDay to string
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Booking",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          isLoading
              ? Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: _saveBookingAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              title: "Date & Time",
              icon: Icons.calendar_today,
              child: _dateTimeSelection(),
            ),
            _buildSection(
              title: "Client Details",
              icon: Icons.person_outline,
              child: _clientDetails(),
            ),
            _buildSection(
              title: "Location",
              icon: Icons.location_on_outlined,
              child: _locationSelection(),
            ),
            _buildSection(
              title: "Additional Notes",
              icon: Icons.note_outlined,
              child: _notesField(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Section Container with icon header
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  /// Date and Time Selection UI
  Widget _dateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date selection
        Text(
          "Select Date",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() => selectedDate = pickedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Time selection
        Text(
          "Select Time",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeSelector(
                label: "Start",
                time: startTime,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() => startTime = pickedTime);
                  }
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildTimeSelector(
                label: "End",
                time: endTime,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() => endTime = pickedTime);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Time selector widget
  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Client Details Form
  Widget _clientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: "Client Name",
          hint: "Enter client's full name",
          controller: clientNameController,
          icon: Icons.person,
        ),
        SizedBox(height: 16),
        _buildTextField(
          label: "Phone Number",
          hint: "Enter client's phone number",
          controller: clientPhoneNumberController,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        _buildDropdownField(
          label: "Service Type",
          icon: Icons.spa,
        ),
      ],
    );
  }

  // Improved text field widget
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Improved dropdown field
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropDownTextField(
            controller: _dropdownController,
            textFieldDecoration: InputDecoration(
              hintText: "Select service type",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            dropDownList: [
              DropDownValueModel(name: "Bridal Makeup", value: "Bridal Makeup"),
              DropDownValueModel(name: "Party Makeup", value: "Party Makeup"),
              DropDownValueModel(name: "Hair Styling", value: "Hair Styling"),
              DropDownValueModel(name: "Facial", value: "Facial"),
              DropDownValueModel(
                  name: "Manicure & Pedicure", value: "Manicure & Pedicure"),
            ],
            dropdownRadius: 8,
            dropDownItemCount: 5,
          ),
        ),
      ],
    );
  }

  /// Location Selection UI
  Widget _locationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Where will the service be provided?",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildLocationOption(
              title: "Studio",
              icon: Icons.business,
              isSelected: selectedLocation == "Studio",
            ),
            SizedBox(width: 12),
            _buildLocationOption(
              title: "Client Location",
              icon: Icons.home,
              isSelected: selectedLocation == "Client Location",
            ),
          ],
        ),
        if (selectedLocation == "Client Location") ...[
          SizedBox(height: 20),
          Text(
            "Client Address",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Enter client's address",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  width: 48,
                  child: IconButton(
                    onPressed: isLoadingLocation ? null : _getCurrentLocation,
                    icon: isLoadingLocation
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          )
                        : Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Location option button
  Widget _buildLocationOption({
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedLocation = title;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.grey[600],
                size: 24,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Notes Input Field
  Widget _notesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Special Requirements or Notes",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Any special requirements or notes for this booking",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 12, right: 8, top: 12),
                child: Icon(
                  Icons.note,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              alignLabelWithHint: true,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}
