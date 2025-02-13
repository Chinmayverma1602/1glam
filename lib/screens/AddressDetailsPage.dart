import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key});

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(),
             SizedBox(height: 25,),
            CustomTitle(title: "Enter your address"),
             SizedBox(height: 25,),
            Container(
                  height: MediaQuery.of(context).size.height*0.041,
                  width: MediaQuery.of(context).size.width*0.45,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(Icons.pin_drop, color: AppColors.subtitle,size: 18,),
                      SizedBox(width: 5,),
                      Text("Use current location", style: TextStyle(color: AppColors.subtitle),)
                    ],),
                  )
                ),
             SizedBox(height: 35,),
            SizedBox(height: 15,),
            CustomTextInputField(hintText: "Select address line 1", icon: Icons.pin_drop_outlined),
             SizedBox(height: 15,),
            CustomTextInputField(hintText: "Select address line 2(optional)", icon: Icons.padding_outlined),
             SizedBox(height: 15,),
            CustomTextInputField(hintText: "City", icon: Icons.apartment_outlined),
            SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  flex: 3, 
                  child: CustomButton2(text: "Select Sate", borderColor: AppColors.primary.withOpacity(0.2), leadingImage: 'assets/images/Frame.svg',trailingImage: 'assets/images/i.svg',),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2, 
                  child: CustomTextInputField(
                    hintText: "ZIP",
                    icon: Icons.tag,
                  ),
                ),
              ],
            ),
             SizedBox(height: 15,),
            Row(
              children: [
                Icon(Icons.check_box_outline_blank, color: AppColors.primary.withOpacity(0.4),),
                SizedBox(width: 10,),
                CustomSubTitle(subtitle: "This is a shared location", color: AppColors.text),
              ],
            ),
             SizedBox(height: 15,),
            CustomTextInputField(hintText: "Booth number : 203", icon: Icons.store_mall_directory_outlined),
             SizedBox(height: 15,),
            CustomButton(text: "Continue", color: AppColors.primary, onPressed: (){})
        
          ],
        ),
      ),
    );
  }
}