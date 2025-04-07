import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHomeServicesButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const CustomHomeServicesButton({
    Key? key,
    required this.iconPath,
    required this.label,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width * 0.30,
        decoration: BoxDecoration(
          
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 3,
          //     offset: const Offset(0, 0),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.01),
            SvgPicture.asset(
              iconPath,
              height: 28,
              width: 28,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.015),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
