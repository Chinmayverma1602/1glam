import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomCheckBox.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';

import 'package:google_fonts/google_fonts.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomHeader(),
          ),

          Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 10),
            child: Text("About You" , style: GoogleFonts.lato(color: const Color.fromARGB(255, 75, 14, 83), fontWeight: FontWeight.bold, fontSize: 26),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Text("Tell us more about your business", style: GoogleFonts.lato(color: AppColors.primary,fontWeight: FontWeight.bold ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child:CustomTextInputField(hintText: "Business Name", icon: Icons.store),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: CustomTextInputField(hintText: "Your Name", icon: Icons.person),
          ),
          
          // Container(
          //   height: MediaQuery.of(context).size.height*0.06,
          //   width:double.infinity,
          //   decoration: BoxDecoration(
              
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Row(children: [
          //       Container(
          //         width: MediaQuery.of(context).size.width*0.35,
          //         height:MediaQuery.of(context).size.height*0.6 ,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: AppColors.primaryColor),
          //           borderRadius: BorderRadius.circular(18),
          //         ),
          //         child: Row(children: [
          //           Icon(Icons.circle),
          //           Text("+1"),
          //           Icon(Icons.arrow_downward),
                    
          //         ],),
          //       ),SizedBox(width: 5,),
          //        Container(
          //         height:MediaQuery.of(context).size.height*0.1,
          //         width: MediaQuery.of(context).size.width*0.58,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: AppColors.primaryColor),
          //           borderRadius: BorderRadius.circular(18),
          //         ),
          //         child: Row(children: [
          //           Icon(Icons.call),
          //           Text("Phone Number"),
                    
                    
          //         ],),
          //       ),
              
          //     ],),
          //   ),
          // ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text("Where do you provide your services ?", style: GoogleFonts.lato(color: AppColors.primary, fontWeight: FontWeight.bold),),
          ),
         
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
           child: CheckBox(location: "At my place", isRequired: true,),
         ), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: CheckBox(location: "At client's location", isRequired: true,),
            ),
          Center(child: CustomButton(text: "Continue", color: AppColors.subtitle, onPressed: (){},))
        ],
      ),
    );;
  }
}