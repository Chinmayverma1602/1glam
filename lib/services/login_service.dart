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
