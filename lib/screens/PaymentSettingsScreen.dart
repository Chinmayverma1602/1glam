import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomeTextfield.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  final TextEditingController daysController = TextEditingController(text: '7');
  final TextEditingController depositController =
      TextEditingController(text: '50');
  final TextEditingController expiryDaysController =
      TextEditingController(text: '30');
  final TextEditingController termsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController estimateMessageController =
      TextEditingController();
  final TextEditingController invoiceMessageController =
      TextEditingController();
  int selectedDueDateIndex = 0;
  bool isStripeEnabled = false;
  bool ispaypalEnabled = false;

  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/leads');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/calendar');
        // Navigator.pushReplacementNamed(context, '/ShowInvoice');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // centerTitle: false,
        title: Text(
          'Payment Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Due Date Configuration'),
                  CustomTextField(
                    label: 'Days',
                    hintText: 'Enter days...',
                    controller: daysController,
                  ),
                  // SizedBox(height: 17,)
                  Text(
                    "Due Date Type",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),

                  _buildToggleButtons(
                      ['Before', 'After', 'On'], selectedDueDateIndex,
                      (newIndex) {
                    setState(() {
                      selectedDueDateIndex = newIndex;
                    });
                  }),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Reference Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                  _buildDropdownField('Booking Date'),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Payment Gateway'),
                  _buildToggleOption(
                      title: "Stripe",
                      value: isStripeEnabled,
                      svgPath: 'assets/images/stripe.svg',
                      onChanged: (newValue) {
                        setState(() {
                          isStripeEnabled = newValue;
                        });
                      }),
                  SizedBox(
                    height: 16,
                  ),
                  _buildToggleOption(
                      title: "PayPal",
                      value: ispaypalEnabled,
                      svgPath: 'assets/images/paypal1.svg',
                      onChanged: (newValue) {
                        setState(() {
                          ispaypalEnabled = newValue;
                        });
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Deposit Configuration'),
                  CustomTextField(
                    label: 'Deposit Percentage',
                    hintText: 'Enter percentage...',
                    controller: depositController,
                    suffix: '%',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Estimate Configuration'),
                  
                  CustomTextField(
                    label: 'Expiry Days',
                    hintText: 'Enter expiry days...',
                    controller: expiryDaysController,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Default Terms & Notes'),
                  CustomTextField(
                    label: 'Terms',
                    hintText: 'Enter default terms...',
                    controller: termsController,
                    maxLines: 4,
                  ),
                  CustomTextField(
                    label: 'Notes',
                    hintText: 'Enter default notes...',
                    controller: notesController,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Reminder Settings'),
                  Text(
                    'Estimate Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                  SizedBox(height: 18,),
                  Text(
                    "Schedule",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                  _buildDropdownField('Every 3 days'),
                  CustomTextField(
                    label: 'Message Template',
                    hintText: 'Enter reminder message...',
                    controller: estimateMessageController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Invoice Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                  SizedBox(height: 18,),
                  Text(
                    "Schedule",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff374151),
                    ),
                  ),
                  _buildDropdownField('3 days before due date'),
                  CustomTextField(
                    label: 'Message Template',
                    hintText: 'Enter reminder message...',
                    controller: invoiceMessageController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),


      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDropdownField(String? selectedValue) {
    List<String> options = [
      'Booking Date',
      'Invoice Date',
      '3 days before due date',
      'Every 3 days'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          // labelText: label,
          // border: OutlineInputBorder(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.12),
          ),
        ),
        value: options.contains(selectedValue) ? selectedValue : null,
        onChanged: (String? newValue) {},
        items: options
            .map((value) => DropdownMenuItem(
                  child: Text(value),
                  value: value,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildToggleButtons(
      List<String> options, int selectedIndex, Function(int) onSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;
        bool isSelected = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              onSelected(index); // Update the selection
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFF5D0FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? AppColors.primary : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String svgPath, // New parameter for SVG icon
    required bool value,
    required Function(bool) onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    svgPath,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Switch(
                value: value,
                onChanged: (bool newValue) {
                  setState(() => value = newValue); // Update the UI locally
                  onChanged(newValue); // Notify the parent
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
