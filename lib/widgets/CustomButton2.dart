import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final Color borderColor;
  final String? leadingImage;
  final String? trailingImage;

  CustomButton2({
    Key? key,
    required this.text,
    required this.borderColor,
    this.leadingImage,
    this.trailingImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(175, 50),
        elevation: 0,
        backgroundColor: Colors.transparent,  // Transparent background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1.5),  // Custom border color
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
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
