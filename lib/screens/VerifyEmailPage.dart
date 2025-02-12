import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/EnterDetailsPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          "Verify Email",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.title,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              // child: SvgPicture.asset("assets/images/email.svg", fit: BoxFit.fill,),
              radius: 75,
              backgroundColor: AppColors.primary.withOpacity(0.4),
            ),
            const SizedBox(height: 10),
            Text(
              "Check your email",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.title,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We've sent a verification code to",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.primary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "example@email.com",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.title,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            Pinput(
              length: 6,
              onCompleted: (pin) {
                print("Entered PIN: $pin");
              },
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  text: "Continue",
                  color: AppColors.subtitle,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnterDetailsPage()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Didn't receive the code?",
              style: GoogleFonts.inter(
                color: AppColors.primary.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Resend Code  (45s)",
              style: GoogleFonts.inter(
                color: AppColors.title,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.title,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Change Email Address",
                    style: GoogleFonts.inter(
                      color: AppColors.primary.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
