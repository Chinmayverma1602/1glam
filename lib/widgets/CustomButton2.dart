import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glam1/constants/AppColors.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color fillColor; // New fill color parameter
  final String? leadingImage;
  final String? trailingImage;

  CustomButton2({
    Key? key,
    required this.text,
    required this.borderColor,
    this.fillColor = Colors.transparent, // Default is transparent
    this.leadingImage,
    this.trailingImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 50),
        elevation: 0,
        backgroundColor: fillColor, // Use the provided fill color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: () {
        // onPressed function
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadingImage != null)
            Row(
              children: [
                SvgPicture.asset(leadingImage!, height: 20, width: 20),
                const SizedBox(width: 8),
              ],
            ),
          Text(
            text,
            style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w400),
          ),
          if (trailingImage != null)
            Row(
              children: [
                const SizedBox(width: 8),
                SvgPicture.asset(trailingImage!, height: 20, width: 20),
              ],
            ),
        ],
      ),
    );
  }
}
