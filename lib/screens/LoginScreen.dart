// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:glam1/constants/api_constants.dart';
// import 'package:glam1/services/api_service.dart';
// import 'package:glam1/widgets/CustomButton.dart';
// import 'package:glam1/widgets/CustomHeader.dart';
// import 'package:glam1/widgets/CustomTextInputField.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   LoginServiceApi loginServiceApi = LoginServiceApi();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             CustomHeader(), // ✅ Header stays at the top
//             Expanded(
//               child: Center(
//                 // ✅ Centers only the remaining widgets
//                 child: Column(
//                   mainAxisSize:
//                       MainAxisSize.min, // ✅ Prevents unnecessary stretching
//                   children: [
//                     SizedBox(height: 35),
//                     CustomTextInputField(
//                       controller: _emailController,
//                       hintText: "Enter your registered email",
//                       icon: Icons.email,
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     SizedBox(height: 15),
//                     CustomTextInputField(
//                       controller: _passwordController,
//                       hintText: "Enter your password",
//                       icon: Icons.lock,
//                       keyboardType: TextInputType.visiblePassword,
//                     ),
//                     SizedBox(height: 25),
//                     CustomButton(
//                       onPressed: () async {
//                         await LoginServiceApi.loginUser(
//                             email: _emailController.text,
//                             password: _passwordController.text);
//                       },
//                       text: "Log In",
//                       color: AppColors.subtitle,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
