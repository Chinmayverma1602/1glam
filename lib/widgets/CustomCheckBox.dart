import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomCheckBox extends StatefulWidget {
  final String location;
  final bool isRequired;
  CustomCheckBox(
      {required this.location,
      this.isRequired = false,
      super.key,
      required Null Function(bool? value) onChanged,
      required Color activeColor});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: double.infinity,
      decoration: BoxDecoration(
        border: widget.isRequired
            ? Border.all(color: AppColors.primary.withOpacity(0.2))
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.check_box_outline_blank,
                color: AppColors.primary.withOpacity(0.4)),
            SizedBox(
              width: 10,
            ),
            Text(
              "${widget.location} ",
              style: GoogleFonts.lato(fontSize: 14),
            )
          ],
        ),
      ),
    );
    ;
  }
}
