import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon; // For using Icon
  final String? svgIcon; // For using SVG image
  final String text;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final bool border;
  final Color borderColor;
  final double borderThickness;
  final double elevation;
  final VoidCallback? onPressed; // ✅ Made nullable
  final MainAxisAlignment alignment; // New Parameter

  const CustomButton({
    Key? key,
    this.icon,
    this.svgIcon,
    required this.text,
    required this.color,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.border = true,
    this.borderColor = Colors.white,
    this.borderThickness = 2.0,
    this.elevation = 0.0,
    this.alignment = MainAxisAlignment.center, // Default alignment
    this.onPressed, // ✅ Allowing null value
  }) : super(key: key);

  Widget _buildLeadingWidget() {
    if (svgIcon != null) {
      return SvgPicture.asset(svgIcon!, width: 24, height: 24);
    } else if (icon != null) {
      return Icon(icon, color: iconColor);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: border
          ? BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: borderThickness,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: ElevatedButton(
        onPressed:
            onPressed, // ✅ Button will be disabled if `onPressed` is null
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: elevation,
          minimumSize: const Size(358, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: border
                ? BorderSide(color: borderColor, width: borderThickness)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: alignment, // Dynamic alignment
          children: [
            if (svgIcon != null || icon != null) ...[
              _buildLeadingWidget(),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
