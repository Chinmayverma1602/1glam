import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomButton2 extends StatelessWidget {
  final String text;
  final Color color;
  final String? leadingImage;  
  final String? trailingImage; 

  CustomButton2({
    Key? key,
    required this.text,
    required this.color,
    this.leadingImage,
    this.trailingImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        elevation: 0.4,
        backgroundColor: color,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      onPressed: () {
        // onpressed function
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
            style: const TextStyle(color: Colors.black),
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
