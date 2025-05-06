import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String baseUrl =
      'https://1glambackend-production.up.railway.app/api';

  static Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      print("Attempting login for email: $email");

      final response = await http.post(
        Uri.parse('$baseUrl/resource/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usr': email,
          'pwd': password,
        }),
      );

      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponseModel.fromJson(jsonResponse);

        print("Login response processed: success=${loginResponse.success}");

        // Save token if login is successful
        if (loginResponse.success && loginResponse.token != null) {
          print("Login successful, saving token");
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', loginResponse.token!);

          // Save user email
          await prefs.setString('user_email', email);

          // Save user data (name, etc.) if available
          String? userNameToSave = null;
          if (loginResponse.userData != null) {
            // Try to find user name in different possible keys
            var userData = loginResponse.userData!;

            // Look for name in common keys
            userNameToSave = userData['full_name'] ??
                userData['name'] ??
                userData['firstName'] ??
                userData['first_name'];

            if (userNameToSave != null && userNameToSave.isNotEmpty) {
              await prefs.setString('user_name', userNameToSave);
            } else {
              // If no name found, use email username part as fallback
              String emailName = email.split('@')[0];
              // Capitalize first letter
              if (emailName.isNotEmpty) {
                emailName = emailName[0].toUpperCase() + emailName.substring(1);
                userNameToSave = emailName;
                await prefs.setString('user_name', userNameToSave);
              }
            }
          } else {
            // If no user data available, just use email as fallback
            String emailName = email.split('@')[0];
            // Capitalize first letter
            if (emailName.isNotEmpty) {
              emailName = emailName[0].toUpperCase() + emailName.substring(1);
              userNameToSave = emailName;
              await prefs.setString('user_name', userNameToSave);
            }
          }

          // Save the name to a few alternative keys to ensure it's found
          if (userNameToSave != null && userNameToSave.isNotEmpty) {
            await prefs.setString('user_name', userNameToSave);
            await prefs.setString('userName', userNameToSave);
            await prefs.setString('name', userNameToSave);
            await prefs.setString('displayName', userNameToSave);
          }

          // Navigate to home screen
          print("Navigating to home screen");
          Get.offAllNamed('/home');
        } else {
          print("Login unsuccessful: ${loginResponse.message}");
        }

        return loginResponse;
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return LoginResponseModel.error('Failed to login. Please try again.');
      }
    } catch (e) {
      print("Login error: $e");
      return LoginResponseModel.error('Network error: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
