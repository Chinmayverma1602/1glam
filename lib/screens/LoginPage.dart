import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/services/api_service.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final response = await LoginServiceApi.createUser(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (response != null && response.containsKey("data")) {
      print("Success Response: $response");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Account created for ${response['data']['email']}")),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
    } else {
      print("Failed Response: $response");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response?["error"] ?? "Failed to create account")),
      );
    }
  }

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
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.99,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    SvgPicture.asset('assets/images/div.svg', fit: BoxFit.fill),
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
                    style: TextStyle(fontSize: 15, color: Colors.purple),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomTextInputField(
                  hintText: "Enter your email",
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomTextInputField(
                  hintText: "Enter your password",
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: _isLoading ? "Creating Account..." : "Continue",
                color: AppColors.subtitle,
                onPressed: _isLoading ? null : _handleLogin,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                      child: Divider(color: AppColors.primary, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "or continue with",
                      style: TextStyle(fontSize: 14, color: AppColors.primary),
                    ),
                  ),
                  const Expanded(
                      child: Divider(color: AppColors.primary, thickness: 1)),
                ],
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Continue with Google",
                borderThickness: 0.4,
                svgIcon: 'assets/images/google.svg',
                textColor: Colors.black,
                border: true,
                borderColor: Colors.grey.withOpacity(0.4),
                color: Colors.transparent,
                icon: Icons.abc,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Continue with Apple",
                icon: Icons.apple,
                iconColor: Colors.white,
                color: Colors.black,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Continue with Facebook",
                icon: Icons.facebook,
                color: AppColors.facebookBlue,
                iconColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton2(
                    text: "Country",
                    borderColor: AppColors.primary,
                    leadingImage: 'assets/images/Frame.svg',
                    trailingImage: 'assets/images/i.svg', 
                    fillColor:Colors.transparent,
                  ),
                  CustomButton2(
                    text: "Language",
                    borderColor: AppColors.primary,
                      fillColor:Colors.transparent,
                    leadingImage: 'assets/images/Frame-1.svg',
                    trailingImage: 'assets/images/i.svg',
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  "By continuing, you agree to our Terms of Service and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.purple),
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
