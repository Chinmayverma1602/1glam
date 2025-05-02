import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/EnterDetailsPage.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
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

  @override
  void initState() {
    super.initState();
    _getUserData();
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

  Future<void> _verifyEmail(String code) async {
    setState(() => _isLoading = true);

    // For now, since we don't have the actual email verification API,
    // we'll just simulate verification and proceed

    // In a real app, you would call your API to verify the code:
    /*
    final verificationResponse = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/verify-email"),
      headers: {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "code": code,
        "userId": _userId,
      }),
    );
    
    if (verificationResponse.statusCode == 200) {
      // Email verified successfully
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EnterDetailsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid verification code")),
      );
    }
    */

    // Simulated successful verification
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EnterDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Verify Email",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.title,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Center(
              child: Column(
                children: [
                  CircleAvatar(
                    child: SvgPicture.asset(
                      'assets/images/Vector.svg',
                      fit: BoxFit.fill,
                    ),
                    radius: 75,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
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
                      color: AppColors.primary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: GoogleFonts.inter(
                      color: AppColors.title,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Pinput(
                    length: 6,
                    onCompleted: (pin) {
                      _verifyEmail(pin);
                    },
                    defaultPinTheme: PinTheme(
                      width: 55,
                      height: 65,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomButton(
                        text: _isLoading ? "Verifying..." : "Verify Email",
                        color: AppColors.subtitle,
                        onPressed: _isLoading
                            ? null
                            : () => _verifyEmail(
                                "123456"), // Use a default code for button
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
                  GestureDetector(
                    onTap: () {
                      // Here you would implement resend code functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Verification code resent to $userEmail")),
                      );
                    },
                    child: Text(
                      "Resend Code  (45s)",
                      style: GoogleFonts.inter(
                        color: AppColors.title,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                  ),
                ],
              ),
            ),
    );
  }
}
