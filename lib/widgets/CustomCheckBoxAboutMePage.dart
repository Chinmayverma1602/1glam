import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomCheckBox.dart';

class CustomCheckBoxAboutMePage extends StatelessWidget {
  final String checkboxLabel;
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckBoxAboutMePage({
    super.key,
    required this.checkboxLabel,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: ShapeDecoration(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.travelFeeTextFields,
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomCheckBox(
          onChanged: onChanged,
          activeColor: AppColors.primary,
          location: checkboxLabel,
        ),
      ),
    );
  }
}