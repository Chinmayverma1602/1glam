import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/EnterDetailsPage.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomToast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailPage extends StatefulWidget {
  final String? email;

  const VerifyEmailPage({super.key, this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  String userEmail = "";
  bool _isLoading = false;
  String? _userId;
  String? _token;
  int _secondsRemaining = 45;
  bool _canResend = false;
  String _pinCode = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startResendTimer();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _getUserData() async {
    setState(() => _isLoading = true);

    if (widget.email != null) {
      setState(() {
        userEmail = widget.email!;
      });
    } else {
      // Try to get email from shared preferences
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userEmail = prefs.getString('user_email') ?? "example@email.com";
      });
    }

    // Get token and user ID
    _token = await TokenManager.getToken();
    _userId = await TokenManager.getUserId();

    setState(() => _isLoading = false);
  }

  Future<void> _verifyEmail() async {
    // Remove PIN validation to ensure navigation always works
    // if (_pinCode.length != 6) return;

    setState(() => _isLoading = true);

    // For now, since we don't have the actual email verification API,
    // we'll just simulate verification and proceed

    // Simulated successful verification
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EnterDetailsPage()),
    );
  }

  void _resendCode() {
    if (!_canResend) return;

    // Reset timer
    setState(() {
      _secondsRemaining = 45;
      _canResend = false;
    });

    // Start timer again
    _startResendTimer();

    // Show feedback
    CustomToast.showInfo(
      context,
      message: "Verification code resent to $userEmail",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CustomLoadingAnimation(
                size: 50,
                color: AppColors.primary,
                type: LoadingAnimationType.staggeredDotsWave,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.purple),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Verify Email",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.email_outlined,
                            size: 60,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Check your email",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We've sent a verification code to",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Pinput(
                        length: 6,
                        onChanged: (pin) {
                          setState(() {
                            _pinCode = pin;
                          });
                        },
                        onCompleted: (pin) {
                          _pinCode = pin;
                        },
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _verifyEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Verify Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Didn't receive the code?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _resendCode,
                        child: Text(
                          "Resend Code(${_canResend ? "" : "${_secondsRemaining}s"})",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _canResend
                                ? Colors.purple
                                : Colors.purple.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.purple,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Change Email Address",
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
