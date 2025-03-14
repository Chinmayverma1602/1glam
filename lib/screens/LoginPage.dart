import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isGoogleLoading = true);

      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        setState(() => _isGoogleLoading = false);
        return;
      }

      // Obtain auth details from Google sign-in
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase with Google tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      setState(() => _isGoogleLoading = false);

      if (user != null) {
        // Check if this is a new user
        bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          // Save user data to Firestore for new users
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
            'provider': 'google',
          });
        } else {
          // Update last login time for existing users
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Signed in with Google as ${user.displayName}")),
        );

        // Navigate to the appropriate screen
        // For new users, you might want to redirect to a profile completion page
        // For existing users, redirect to home or dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmailPage()),
        );
      }
    } catch (e) {
      setState(() => _isGoogleLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: ${e.toString()}")),
      );
      print("Google sign-in error: $e");
    }
  }

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
                text:
                    _isGoogleLoading ? "Signing in..." : "Continue with Google",
                borderThickness: 0.4,
                svgIcon: 'assets/images/google.svg',
                textColor: Colors.black,
                border: true,
                borderColor: Colors.grey.withOpacity(0.4),
                color: Colors.transparent,
                icon: Icons.abc,
                onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
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
                    fillColor: Colors.transparent,
                  ),
                  CustomButton2(
                    text: "Language",
                    borderColor: AppColors.primary,
                    fillColor: Colors.transparent,
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
