import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

import 'package:google_fonts/google_fonts.dart';

class CheckBox extends StatefulWidget {
  final String location;
  final bool isRequired;
  const CheckBox(
   
    {
       required this.location,
       this.isRequired = false,
      super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
            height: MediaQuery.of(context).size.height*0.06,
            width: double.infinity,
            decoration: BoxDecoration(
               border: widget.isRequired
              ? Border.all(color: AppColors.primary)
              : null, 
              borderRadius: BorderRadius.circular(18),
              
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Icon(Icons.check_box_outline_blank, color: AppColors.primary),
                SizedBox(width: 10,),
                Text("${widget.location} " ,style: GoogleFonts.lato(fontSize: 14),)
              ],),
            ),
      
          ),
    );;
  }
}