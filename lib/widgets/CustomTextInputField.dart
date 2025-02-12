import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

// ignore: must_be_immutable
class CustomTextInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
      CustomTextInputField({
    required this.hintText,
    required this.icon,
    super.key});
  TextEditingController _textEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: "$hintText",
          prefixIcon: Icon(icon , color: AppColors.primary.withOpacity(0.4),),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.primary.withOpacity(0.4),
            )
            
          ),
        
      
        ),
      
      ),
    );
  }
}