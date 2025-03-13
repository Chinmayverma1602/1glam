import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginServiceApi {
  static const String baseUrl = "http://1glam.local:8000/api/resource/User";
  static const String loginUrl = "http://1glam.local:8000/api/method/login";

  static const Map<String, String> headers = {
    "Authorization": "token eb6cdc62a0caeef:b4f7342a55e5049",
    "Content-Type": "application/json"
  };

  static Future<Map<String, dynamic>?> createUser(
      String email, String password) async {
    final Map<String, dynamic> body = {
      "email": email,
      "first_name": email.split('@')[0], // Extracts first part of email
      "last_name": "User",
      "enabled": 1,
      "new_password": password,
      "send_welcome_email": 0,
      "roles": [
        {"role": "Employee"}
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "token eb6cdc62a0caeef:b4f7342a55e5049",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error Response: ${response.body}");
        return {
          "error": jsonDecode(response.body)['message'] ?? "Error creating user"
        };
      }
    } catch (e) {
      print("Exception: $e");
      return {"error": "Something went wrong. Please try again."};
    }
  }

  static Future<void> loginUser(
      {required String email, required String password}) async {
    final Map<String, String> body = {
      "usr": email,
      "pwd": password,
    };

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        Get.toNamed('/verify');
      } else {
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login'); // Redirect to login page
  }
}
