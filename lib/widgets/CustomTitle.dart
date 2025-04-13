import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final double fontSize;
    const CustomTitle({
    required this.title,
    this.fontSize = 24,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: fontSize, fontWeight: FontWeight.bold, color:AppColors.title ),)
      ],
    );
  }
}