import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color fillColor;
  final IconData? leadingIcon;
  final String? leadingImage;
  final IconData? trailingIcon;
  final String? trailingImage;
  final Color textColor;
  final double textSize;
  final bool isBold;
  final Color iconColor;
  final double iconSize;

  CustomButton2({
    Key? key,
    required this.text,
    required this.borderColor,
    this.fillColor = Colors.transparent,
    this.leadingIcon ,
    this.leadingImage,
    this.trailingIcon,
    this.trailingImage,
    this.textColor = AppColors.text,
    this.textSize = 14.0,
    this.isBold = false,
    this.iconColor = Colors.black,
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 60),
        elevation: 0,
        backgroundColor: fillColor,
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
          if (leadingIcon != null || leadingImage != null)
            Row(
              children: [
                if (leadingIcon != null)
                  FaIcon(leadingIcon, color: iconColor, size: iconSize)
                else if (leadingImage != null)
                  SvgPicture.asset(leadingImage!, height: iconSize, width: iconSize),
                const SizedBox(width: 8),
              ],
            ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          if (trailingIcon != null || trailingImage != null)
            Row(
              children: [
                const SizedBox(width: 8),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: iconColor, size: iconSize)
                else if (trailingImage != null)
                  SvgPicture.asset(trailingImage!, height: iconSize, width: iconSize),
              ],
            ),
        ],
      ),
    );
  }
}
