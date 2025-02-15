import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class TravellingInfoPage extends StatefulWidget {
  const TravellingInfoPage({super.key});

  @override
  State<TravellingInfoPage> createState() => _TravellingInfoPageState();
}

class _TravellingInfoPageState extends State<TravellingInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CustomHeader(),
          SizedBox(height: 35,),
          CustomTitle(title: "What is your travel fee?"),
          SizedBox(height: 35,),
          CustomButton2(text: "Select Fee Type", borderColor: AppColors.primary, leadingImage: "", trailingImage: "",),
          SizedBox(height: 15,),
          CustomTextInputField(hintText: "Travel Fee per km/mile", icon: Icons.monetization_on),
           SizedBox(height: 15,),
          CustomButton(text: "123 Main St, New Yors, NY 100001", color: Colors.transparent.withOpacity(0.4), onPressed: (){}),
           SizedBox(height: 15,),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
        
            ),
            // Image to be added later
          ),
           SizedBox(height: 15,),
          CustomSubTitle(subtitle: "Travel & Fee Policy (Optional)", color: AppColors.text),
           SizedBox(height: 15,),
          Container(
            height: MediaQuery.of(context).size.height*0.12,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12,),
              border: Border.all(color: AppColors.primary),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Travel to restricted areas, congested zone,..."),
            ),
        
          ),
           SizedBox(height: 35,),
          CustomButton(text: "Skip for now", color: Colors.transparent.withOpacity(0.1), onPressed: (){}),
           SizedBox(height: 15,),
          CustomButton(text: "Continue", color: AppColors.subtitle, onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ServicesInfoPage()));
          })
        
        ],),
      ),
    );
  }
}