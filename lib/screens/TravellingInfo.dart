import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomDistanceSlider.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class TravellingInfoPage extends StatefulWidget {
  const TravellingInfoPage({super.key});

  @override
  State<TravellingInfoPage> createState() => _TravellingInfoPageState();
}

class _TravellingInfoPageState extends State<TravellingInfoPage> {
  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = [
    "Online Payment",
    "Cash Payment",
    "Net Banking"
  ];

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
              CustomHeader(),
              const SizedBox(height: 35),
              CustomTitle(title: "What is your travel fee?"),
              const SizedBox(height: 35),
              // Dropdown for Payment Methods
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.4), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedPaymentMethod,
                    // When no value is selected, we show a custom hint
                    hint: Row(
                      children: [
                        // Leading SVG Icon
                        SvgPicture.asset(
                          'assets/icons/leading.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Select Payment Method",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        // Trailing SVG Icon
                        SvgPicture.asset(
                          'assets/icons/globe.svg',
                          width: 24,
                          height: 24,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                    items: _paymentMethods.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Row(
                          children: [
                            // Option Leading Icon (can be same or different)
                            SvgPicture.asset(
                              'assets/icons/globe.svg',
                              width: 24,
                              height: 24,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              method,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPaymentMethod = newValue;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 15),
              CustomTextInputField(
                hintText: "Travel Fee per km/mile",
                icon: Icons.monetization_on,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              CustomButton(
                alignment: MainAxisAlignment.start,
                icon: Icons.pin_drop,
                iconColor: AppColors.primary,
                text: "123 Main St, New Yors, NY 100001",
                color: Colors.transparent.withOpacity(0.1),
                onPressed: () {},
                border: true,
                borderColor: AppColors.primary,
                borderThickness: 0.4,
                textColor: Colors.black,
              ),
              const SizedBox(height: 15),
              CustomDistanceSlider(),
              const SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/images/globe.svg',
                  fit: BoxFit.contain,
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
                  border: Border.all(color: AppColors.primary),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Travel to restricted areas, congested zone,...",
                    style: TextStyle(color: AppColors.hintText),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicesInfoPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
