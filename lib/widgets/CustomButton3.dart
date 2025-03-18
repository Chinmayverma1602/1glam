import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButton3 extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final double textSize;
  final bool isBold;
  final IconData leadingIcon;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  const CustomButton3({
    Key? key,
    required this.text,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.textSize,
    required this.isBold,
    required this.leadingIcon,
    this.gradientColors,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradientColors != null
            ? LinearGradient(colors: gradientColors!)
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(175, 60),
          elevation: 0,
          backgroundColor:
              gradientColors == null ? borderColor : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                FaIcon(leadingIcon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
