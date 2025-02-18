import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomServiceButton.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class ServicesInfoPage extends StatefulWidget {
  const ServicesInfoPage({super.key});

  @override
  State<ServicesInfoPage> createState() => _ServicesInfoPageState();
}

class _ServicesInfoPageState extends State<ServicesInfoPage> {
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
            CustomTitle(title: "Add your services"),
            SizedBox(height: 15,),
            CustomSubTitle(
              subtitle: "Group services info Bundles or you can add it later",
              color: Colors.grey,
            ),
           SizedBox(height: 35,),
          
            CustomServiceButton(title: "Natural Makeup", subtitle: "45 min"),
            SizedBox(height: 15),
         
            CustomServiceButton(title: "Evening Makeup", subtitle: "60 min"),
            SizedBox(height: 35),
            CustomButton(
              text: "Add Service",
              color: Colors.transparent,
              onPressed: () {},
            ),
            SizedBox(height: 15),
            CustomButton(
              text: "Continue",
              color: AppColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddServicesPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

 
}