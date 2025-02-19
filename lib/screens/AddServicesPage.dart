import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({Key? key}) : super(key: key);

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Service"),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton2(
                    fillColor: AppColors.primary.withOpacity(0.2),
                    text: "Bundle",
                    borderColor: AppColors.primary.withOpacity(0.2),
                  ),
                  CustomButton2(
                    
                    text: "Single",
                    borderColor: AppColors.primary,
                  ),
                ],
              ),
               SizedBox(height: 16.0),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Total time:"),
                  Text("4 hours"),
                  Text("Total price:"),
                  Text("65,000"),
                ],
              ),
               SizedBox(height: 16.0),
             
            Material(
            elevation: 1,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bridal Makeup Bundle",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
          ],
                ),
              ),
            ),
          )
          ,
               SizedBox(height: 16.0),
          
              CustomServiceSelectionContainer(
              title: 'Makeup', 
              serviceCategory: 'Luxury', 
              buttonBorderColor: AppColors.hintText, 
              borderColor: AppColors.hintText, 
              hintText: 'Service description', 
          
              borderRadius: 16, 
              durationLabel: '2', 
              priceLabel: '40,000', 
              artistName: 'Emma Wilson',
               artistSpecialization: 'Hair Specialist',
                serviceType: 'Mobile Service',
                serviceIcon: 'assets/images/f.svg',
                leadingIconColor: AppColors.primary,
                mobileServiceIcon: 'assets/images/slide.svg',
                trailingIconColor: AppColors.primary, 
                artistImage: 'assets/images/img.svg',
          
              ),
              SizedBox(height: 16,),
              CustomServiceSelectionContainer(title: 'HairStyling', 
              serviceCategory: 'Premium', 
              buttonBorderColor: AppColors.hintText, 
              borderColor: AppColors.hintText, 
              hintText: 'Service description', 
              borderRadius: 16, 
              durationLabel: '2', 
              priceLabel: '25,000', 
              artistName: 'Sophie Chen ',
               artistSpecialization: 'Hair Specialist',
                serviceType: 'Mobile Service',
                serviceIcon: 'assets/images/f.svg',
                leadingIconColor: AppColors.primary,
                mobileServiceIcon: 'assets/images/img.svg',
                trailingIconColor: AppColors.primary, 
                artistImage: 'assets/images/img.svg',
          
              ),
                 SizedBox(height: 16,),
              CustomButton(icon: Icons.add,text: "Add Another Service ", color: Colors.transparent, onPressed: (){}),
              SizedBox(height: 16,),
              CustomButton(text: "Save Service", color: AppColors.primary, onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

              })
            ],
          ),
        ),
      ),
    );
  }
}
