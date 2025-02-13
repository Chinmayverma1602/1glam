import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubTitle extends StatelessWidget {
  final String subtitle;
  final Color color;
  const CustomSubTitle({
    required this.subtitle,
    required this.color,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(subtitle, style: GoogleFonts.inter(fontSize: 14,  color:color ),)
      ],
    );
  }
}