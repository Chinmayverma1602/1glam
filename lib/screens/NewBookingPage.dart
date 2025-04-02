import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:intl/intl.dart';

class NewBookingScreen extends StatefulWidget {
  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 11, minute: 0);
  String selectedLocation = "Studio";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 237, 238), // Updated background color
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 237, 238),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("New Booking", style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
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
          padding: const EdgeInsets.only(left : 15.0),
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
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _timePickerButton("Start Time", startTime, (newTime) => setState(() => startTime = newTime)),
                Text("Start Time"),
              ],
            )),
            SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _timePickerButton("End Time", endTime, (newTime) => setState(() => endTime = newTime)),
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
      label: Text(DateFormat('dd/MM/yyyy').format(selectedDate), style: TextStyle(color: Colors.black)),
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
  Widget _timePickerButton(String label, TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
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
        _textInputField("Client Name", "Enter client name"),
        _textInputField("Phone Number", "Enter phone number"),
        _dropdownField("Service Type", "Bridal Makeup"),
      ],
    );
  }

  /// Standard Input Field
  Widget _textInputField(String label, String hint) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// **Label Text**
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),

      /// **Text Field**
      TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[500]),
          filled: true,
          fillColor: Color(0xFFF7F7F8), // Light background color
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: InputBorder.none, // Removes border
          enabledBorder: InputBorder.none, // No border when enabled
          focusedBorder: InputBorder.none, // No border when focused
        ),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    ],
  );
}


  /// Dropdown for Service Type
// import 'package:dropdown_textfield/dropdown_textfield.dart';
final _dropdownController = SingleValueDropDownController(
  data: DropDownValueModel(name: "Bridal Makeup", value: "Bridal Makeup"),
);

Widget _dropdownField(String label, String defaultValue) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// **Label Text**
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
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
          hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[500]),
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
            _locationButton("Studio", Icons.location_on, selectedLocation == "Studio"),
            SizedBox(width: 10),
            _locationButton("Client Location", Icons.home, selectedLocation == "Client Location"),
          ],
        ),
        if (selectedLocation == "Client Location") _textInputField("Enter Address", ""),
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
        padding: EdgeInsets.symmetric(vertical: 14), // Increased for better spacing
        elevation: 0, // Removing shadow to match flat UI
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : Colors.black54, size: 22),
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
