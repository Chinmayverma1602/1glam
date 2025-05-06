import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomTextInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glam1/widgets/CustomToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  Future<void> _handleFacebookSignIn() async {
    try {
      setState(() {
        _isFacebookLoading = true;
      });

      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in with Firebase
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          bool isNewUser =
              userCredential.additionalUserInfo?.isNewUser ?? false;

          if (isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'name': _nameController.text,
              'email': user.email,
              'displayName': user.displayName,
              'photoURL': user.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
              'provider': 'facebook',
            });
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'lastLogin': FieldValue.serverTimestamp(),
            });
          }

          // Save user name to SharedPreferences for HomePage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userName = user.displayName ?? _nameController.text;
          if (userName.isNotEmpty) {
            await prefs.setString('user_name', userName);
            await prefs.setString('userName', userName);
            await prefs.setString('name', userName);
            await prefs.setString('displayName', userName);
          }

          // Also save email
          if (user.email != null) {
            await prefs.setString('user_email', user.email!);

            // Store Firebase token as a fallback for API token
            String? firebaseToken = await user.getIdToken();
            if (firebaseToken != null && firebaseToken.isNotEmpty) {
              await prefs.setString('firebase_token', firebaseToken);

              // Try to get an API token using the email
              try {
                // Generate a random password for API use (won't be needed by the user)
                String randomPassword =
                    DateTime.now().millisecondsSinceEpoch.toString();
                await prefs.setString('user_password', randomPassword);

                // Create an API user with this email
                await LoginServiceApi.createUser(
                  user.email!,
                  randomPassword,
                  name: user.displayName ?? userName,
                );
              } catch (e) {
                print("Error creating API user: $e");
              }
            }
          }

          CustomToast.showSuccess(
            context,
            message: "Signed in with Facebook as ${user.displayName}",
          );

          // Navigate to VerifyEmailPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerifyEmailPage()),
          );
        }
      } else {
        throw Exception("Facebook login failed: ${result.status}");
      }
    } catch (e) {
      setState(() => _isFacebookLoading = false);
      CustomToast.showError(
        context,
        message: "Facebook sign-in failed: ${e.toString()}",
      );
      print("Facebook sign-in error: $e");
    } finally {
      setState(() => _isFacebookLoading = false);
    }
  }

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
            'name': _nameController.text,
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

        // Save user name to SharedPreferences for HomePage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userName = user.displayName ?? _nameController.text;
        if (userName.isNotEmpty) {
          await prefs.setString('user_name', userName);
          await prefs.setString('userName', userName);
          await prefs.setString('name', userName);
          await prefs.setString('displayName', userName);
        }

        // Also save email
        if (user.email != null) {
          await prefs.setString('user_email', user.email!);

          // Store Firebase token as a fallback for API token
          String? firebaseToken = await user.getIdToken();
          if (firebaseToken != null && firebaseToken.isNotEmpty) {
            await prefs.setString('firebase_token', firebaseToken);

            // Try to get an API token using the email
            try {
              // Generate a random password for API use (won't be needed by the user)
              String randomPassword =
                  DateTime.now().millisecondsSinceEpoch.toString();
              await prefs.setString('user_password', randomPassword);

              // Create an API user with this email
              await LoginServiceApi.createUser(
                user.email!,
                randomPassword,
                name: user.displayName ?? userName,
              );
            } catch (e) {
              print("Error creating API user: $e");
            }
          }
        }

        CustomToast.showSuccess(
          context,
          message: "Signed in with Google as ${user.displayName}",
        );

        // Navigate to the appropriate screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmailPage()),
        );
      }
    } catch (e) {
      setState(() => _isGoogleLoading = false);
      CustomToast.showError(
        context,
        message: "Google sign-in failed: ${e.toString()}",
      );
      print("Google sign-in error: $e");
    }
  }

  Future<void> _handleLogin() async {
    if (_nameController.text.isEmpty) {
      CustomToast.showWarning(
        context,
        message: "Please enter your name",
      );
      return;
    }

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomToast.showWarning(
        context,
        message: "Please enter email and password",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // First try to log in with the provided credentials
      final loginResponse = await LoginServiceApi.login(
        _emailController.text,
        _passwordController.text,
      );

      if (loginResponse != null && loginResponse.containsKey("token")) {
        // Login successful
        setState(() => _isLoading = false);

        print("Login Success Response: $loginResponse");
        CustomToast.showSuccess(
          context,
          message: "Login successful!",
        );

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifyEmailPage()));
        return;
      }

      // If login failed, try to create a new account
      final response = await LoginServiceApi.createUser(
        _emailController.text,
        _passwordController.text,
        name: _nameController.text,
      );

      setState(() => _isLoading = false);

      if (response != null && response.containsKey("token")) {
        print("Account Creation Success Response: $response");

        // Also store password for token refresh
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_password', _passwordController.text);

        CustomToast.showSuccess(
          context,
          message: "Account created for ${response['user']['email']}",
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifyEmailPage()));
      } else {
        print("Failed Response: $response");
        CustomToast.showError(
          context,
          message: response?["error"] ?? "Failed to create account",
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      CustomToast.showError(
        context,
        message: "Error: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFAE8FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.brush, // This is a makeup brush icon
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "AI-Powered Booking for \nMakeup Artists",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Streamline your bookings with WhatsApp & Instagram \nintegration",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomTextInputField(
                      hintText: "Enter your name",
                      controller: _nameController,
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.text,
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
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: _isLoading ? "" : "Continue",
                    color: AppColors.subtitle,
                    onPressed: _isLoading ? null : _handleLogin,
                  ),

                  // Display loading animation separately when loading
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomLoadingAnimation(
                            size: 24,
                            color: AppColors.subtitle,
                            type: LoadingAnimationType.staggeredDotsWave,
                            showText: false,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Creating Account...",
                            style: TextStyle(
                              color: AppColors.subtitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  const Text(
                    "or continue with",
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "Continue with Google",
                    borderThickness: 0.4,
                    svgIcon: 'assets/images/google.svg',
                    textColor: Colors.black,
                    border: true,
                    borderColor: Colors.grey.withOpacity(0.4),
                    color: Colors.transparent,
                    icon: Icons.abc,
                    onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                  ),

                  // Display Google loading animation when Google is loading
                  if (_isGoogleLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomLoadingAnimation(
                            size: 24,
                            color: AppColors.primary,
                            type: LoadingAnimationType.staggeredDotsWave,
                            showText: false,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Signing in with Google...",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
                    onPressed:
                        _isFacebookLoading ? null : _handleFacebookSignIn,
                  ),

                  // Display Facebook loading animation when Facebook is loading
                  if (_isFacebookLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomLoadingAnimation(
                            size: 24,
                            color: AppColors.facebookBlue,
                            type: LoadingAnimationType.staggeredDotsWave,
                            showText: false,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Signing in with Facebook...",
                            style: TextStyle(
                              color: AppColors.facebookBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton2(
                          text: "Language",
                          borderColor: AppColors.primary.withOpacity(0.5),
                          leadingImage: 'assets/images/Frame-1.svg',
                          trailingImage: 'assets/images/i.svg',
                          fillColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomButton2(
                          text: "Country",
                          borderColor: AppColors.primary.withOpacity(0.5),
                          leadingImage: 'assets/images/Frame.svg',
                          trailingImage: 'assets/images/i.svg',
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "By continuing, you agree to our Terms of Service and Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
