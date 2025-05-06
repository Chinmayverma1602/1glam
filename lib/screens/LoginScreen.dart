import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/LoginPage.dart';
import 'package:glam1/services/login_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomHeader(), // Header stays at the top
            Expanded(
              child: Center(
                // Centers only the remaining widgets
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Prevents unnecessary stretching
                  children: [
                    const SizedBox(height: 35),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    CustomTextInputField(
                      controller: _emailController,
                      hintText: "Enter your registered email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    CustomTextInputField(
                      controller: _passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    const SizedBox(height: 25),
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.subtitle,
                          )
                        : CustomButton(
                            onPressed: _handleLogin,
                            text: "Log In",
                            color: AppColors.subtitle,
                          ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to signup screen
                            Get.to(() => LoginPage());
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await LoginService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.success) {
        // Navigation is handled in the service, but we can add a backup here
        if (Get.currentRoute != '/home') {
          Get.offAllNamed('/home');
        }
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
        _isLoading = false;
      });
    }
  }
}
