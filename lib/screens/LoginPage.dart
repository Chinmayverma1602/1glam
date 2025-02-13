import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              
              const CustomHeader(),
              const SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.width*0.99, 
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset('assets/images/div.svg',fit: BoxFit.fill,),
              ),
             
              const Center(
                child: Text(
                  "AI-Powered Bookings for \nMakeup Artists",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.title,
                  ),
                ),
              ),
             
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Streamline your bookings with WhatsApp & Instagram \nintegration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomTextInputField(
                  hintText: "Enter your email",
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Continue",
                color: AppColors.subtitle,
                onPressed: () {
                  // navigation
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));

                },
              ),
              SizedBox(height: 10,),
              Row(
  children: [
    Expanded(
      child: Divider(
        color:AppColors.primary,
        thickness: 1,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "or continue with",
        style: TextStyle(fontSize: 14, color:AppColors.primary,),
      ),
    ),
    Expanded(
      child: Divider(
        color: AppColors.primary,
        thickness: 1,
      ),
    ),
  ],
),
               SizedBox(height: 12),
              

             
             
              CustomButton(
                text: "Continue with Google",
                color: Colors.transparent,
                icon: Icons.abc,
                onPressed: () {
                  // navigation
                  
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Continue with Apple",
                icon: Icons.apple,
                iconColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  // navigation
                  
                },
              ),
              const SizedBox(height: 12),
             CustomButton(
                text: "Continue with Facebook",
                icon: Icons.facebook,
                color: AppColors.facebookBlue,
                iconColor: Colors.white,
                onPressed: () {
                  // navigation
                  
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton2(text: "Country", borderColor: AppColors.primary, leadingImage: 'assets/images/Frame.svg',trailingImage: 'assets/images/i.svg',),
                  CustomButton2(text: "Language",borderColor: AppColors.primary, leadingImage: 'assets/images/Frame-1.svg',trailingImage: 'assets/images/i.svg',),
                ],
              ),
              
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: mini_reusable_container(
              //         leadingIcon: Icons.email,
              //         need: "Country",
              //         color: Colors.transparent,
              //         trailingIcon: Icons.arrow_downward,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: mini_reusable_container(
              //         leadingIcon: Icons.email,
              //         need: "Language",
              //         color: Colors.transparent,
              //         trailingIcon: Icons.arrow_downward,
              //       ),
              //     ),
              //   ],
              // ),
            
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  "By continuing, you agree to our Terms of Service and Privacy and Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.purple,
                    ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  
}
