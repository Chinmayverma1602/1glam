import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:switcher_button/switcher_button.dart';

class CustomServiceSelectionContainer extends StatelessWidget {
  final String title;
  final IconData deleteIcon;
  final String serviceCategory;
  final Color buttonBorderColor;
  final String trailingImage;
  final String hintText;
  final Color borderColor;
  final double borderRadius;
  final String durationLabel;
  final String priceLabel;
  final String artistLabel;
  final String changeLabel;
  final String artistName;
  final String artistSpecialization;
  final String serviceType;
  final String serviceIcon;
  // Removed mobileServiceIcon and replaced with switcher button
  final Color textColor;
  final Color leadingIconColor;
  final Color trailingIconColor;
  final Color backgroundColor;
  final double containerHeight;
  final String artistImage;

  const CustomServiceSelectionContainer({
    Key? key,
    required this.title,
    this.deleteIcon = Icons.delete,
    required this.serviceCategory,
    required this.buttonBorderColor,
    this.trailingImage = 'assets/images/i.svg',
    required this.hintText,
    required this.borderColor,
    required this.borderRadius,
    required this.durationLabel,
    required this.priceLabel,
    this.artistLabel = "Select Artist (Optional)",
    this.changeLabel = "Change",
    required this.artistName,
    required this.artistSpecialization,
    required this.serviceType,
    required this.serviceIcon,
    // Removed mobileServiceIcon parameter
    this.textColor = Colors.black,
    this.leadingIconColor = Colors.black,
    this.trailingIconColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.containerHeight = 0.6,
    required this.artistImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.61,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * containerHeight,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with title and delete icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(deleteIcon, color: textColor),
                ],
              ),
              const SizedBox(height: 8.0),
              // Custom Button2 with service category
              CustomButton2(
                text: serviceCategory,
                borderColor: buttonBorderColor,
                trailingImage: trailingImage,
              ),
              const SizedBox(height: 16.0),
              // Multiline TextField with hint text
              TextField(
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: AppColors.hintText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              // Row for Duration and Price fields
              Row(
                children: [
                  Text("  Duration", style: TextStyle(color: AppColors.secondaryText)),
                  const SizedBox(width: 85),
                  Text("Price", style: TextStyle(color:  AppColors.secondaryText)),
                ],
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Container(
                    
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: durationLabel,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text("hours", style: TextStyle(color: textColor)),
                  const SizedBox(width: 8.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: priceLabel,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Artist selection row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(artistLabel, style: TextStyle(color: textColor)),
                  Text(
                    changeLabel,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  SvgPicture.asset(artistImage, width: 50, height: 50),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artistName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        artistSpecialization,
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              // Service Type row with switcher button replacing mobile service icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        serviceIcon,
                        width: 24,
                        height: 24,
                        color: leadingIconColor,
                      ),
                      const SizedBox(width: 8.0),
                      Text(serviceType, style: TextStyle(color: textColor)),
                    ],
                  ),
                  // Switcher Button from the switcher_button package
                  SwitcherButton(
                    value: true,
                    onChange: (value) {
                      // Add your switch toggle functionality here.
                    },
                    onColor: AppColors.primary,
                    offColor: AppColors.hintText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
