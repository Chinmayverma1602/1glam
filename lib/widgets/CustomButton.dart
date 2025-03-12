import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final String text;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final bool border;
  final Color borderColor;
  final double borderThickness;
  final double elevation;
  final VoidCallback? onPressed;
  final MainAxisAlignment alignment;

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
    this.alignment = MainAxisAlignment.center,
    this.onPressed,
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
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height*0.065,
  decoration: BoxDecoration(
    color: border ? Colors.transparent : color, // ✅ Fix: Only set color inside decoration
    border: border
        ? Border.all(
            color: borderColor,
            width: borderThickness,
            style: BorderStyle.solid,
          )
        : null,
    borderRadius: BorderRadius.circular(16),
  ),

        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return color; // ✅ Force the button color
              },
            ),
            foregroundColor: MaterialStateProperty.all(textColor),
            elevation: MaterialStateProperty.all(elevation),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: border
                    ? BorderSide(color: borderColor, width: borderThickness)
                    : BorderSide.none,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: alignment,
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
      ),
    );
  }
}
