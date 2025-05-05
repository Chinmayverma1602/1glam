import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomeTextfield.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        title: Text(
          'Payment Settings',
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Due Date Configuration'),
            const SizedBox(height: 12),
            _buildContainer([
              CustomTextField(
                label: 'Days',
                hintText: 'Enter days...',
                controller: daysController,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Date Type",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildToggleButtons(
                      ['Before', 'After', 'On'], selectedDueDateIndex,
                      (newIndex) {
                    setState(() {
                      selectedDueDateIndex = newIndex;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reference Date',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownField('Booking Date'),
                ],
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Gateway'),
            const SizedBox(height: 12),
            _buildContainer([
              _buildToggleOption(
                  title: "Stripe",
                  value: isStripeEnabled,
                  svgPath: 'assets/images/stripe.svg',
                  onChanged: (newValue) {
                    setState(() {
                      isStripeEnabled = newValue;
                    });
                  }),
              const SizedBox(height: 16),
              _buildToggleOption(
                  title: "PayPal",
                  value: ispaypalEnabled,
                  svgPath: 'assets/images/paypal1.svg',
                  onChanged: (newValue) {
                    setState(() {
                      ispaypalEnabled = newValue;
                    });
                  }),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Deposit Configuration'),
            const SizedBox(height: 12),
            _buildContainer([
              CustomTextField(
                label: 'Deposit Percentage',
                hintText: 'Enter percentage...',
                controller: depositController,
                suffix: '%',
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Estimate Configuration'),
            const SizedBox(height: 12),
            _buildContainer([
              CustomTextField(
                label: 'Expiry Days',
                hintText: 'Enter expiry days...',
                controller: expiryDaysController,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Default Terms & Notes'),
            const SizedBox(height: 12),
            _buildContainer([
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
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Reminder Settings'),
            const SizedBox(height: 12),
            _buildContainer([
              Text(
                'Estimate Reminders',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownField('Every 3 days'),
                ],
              ),
              CustomTextField(
                label: 'Message Template',
                hintText: 'Enter reminder message...',
                controller: estimateMessageController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text(
                'Invoice Reminders',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownField('3 days before due date'),
                ],
              ),
              CustomTextField(
                label: 'Message Template',
                hintText: 'Enter reminder message...',
                controller: invoiceMessageController,
                maxLines: 3,
              ),
            ]),
            const SizedBox(height: 40),
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
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.title,
      ),
    );
  }

  Widget _buildContainer(List<Widget> children) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.text,
        ),
        value: options.contains(selectedValue) ? selectedValue : null,
        onChanged: (String? newValue) {},
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.primary.withOpacity(0.7),
        ),
        dropdownColor: Colors.white,
        items: options
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildToggleButtons(
      List<String> options, int selectedIndex, Function(int) onSelected) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: options.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          bool isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                onSelected(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin:
                    EdgeInsets.only(right: index < options.length - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFF5D0FE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isSelected ? AppColors.primary : AppColors.text,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String svgPath,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: value
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      svgPath,
                      width: 24,
                      height: 24,
                      colorFilter: value
                          ? null
                          : ColorFilter.mode(
                              Colors.grey.shade700, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Switch(
                value: value,
                onChanged: (bool newValue) {
                  setState(() => value = newValue);
                  onChanged(newValue);
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
