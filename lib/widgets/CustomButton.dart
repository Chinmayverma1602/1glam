import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color color;
  final Color? iconColor;
  final Color textColor;
  final bool border;
  final Color borderColor;
  final bool dottedBorder;
  final double elevation;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    this.icon,
    required this.text,
    required this.color,
    this.iconColor,
    this.textColor = Colors.white,
    this.border = true,
    this.borderColor = Colors.white,
    this.dottedBorder = true,
    this.elevation = 0.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: border
          ? BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 2,
                style: dottedBorder ? BorderStyle.solid : BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: elevation,
          minimumSize: const Size(358, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: border ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: iconColor),
            if (icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
