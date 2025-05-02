import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glam1/constants/api_constants.dart';

class ApiConfig {
  static String get baseUrl => ApiConstants.baseUrl;
  static String get initialAuthToken => ApiConstants.authToken;
}

class TokenManager {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<void> clearTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_id');
  }

  static Future<bool> hasValidToken() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

class LoginServiceApi {
  static Future<Map<String, dynamic>?> createUser(String email, String password,
      {String? name}) async {
    final String url = "${ApiConfig.baseUrl}/api/resource/User";
    final Map<String, dynamic> body = {
      "email": email,
      "first_name": name != null && name.isNotEmpty
          ? name.split(' ').first
          : email.split('@')[0],
      "last_name":
          name != null && name.contains(' ') ? name.split(' ').last : "User",
      "enabled": 1,
      "new_password": password,
      "send_welcome_email": 0,
      "roles": [
        {"role": "Employee"}
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": ApiConfig.initialAuthToken,
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Save user token and id to shared preferences for future API calls
        await TokenManager.saveToken(responseData['token']);
        await TokenManager.saveUserId(responseData['user']['_id']);

        // Also save the email for convenience
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);

        return responseData;
      } else {
        print("Error Response: ${response.body}");
        try {
          return {
            "error":
                jsonDecode(response.body)['message'] ?? "Error creating user"
          };
        } catch (e) {
          return {"error": "Error creating user"};
        }
      }
    } catch (e) {
      print("Exception: $e");
      return {"error": "Something went wrong. Please try again."};
    }
  }

  static Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      String? token = await TokenManager.getToken();

      if (token == null) {
        return {"error": "No authentication token found"};
      }

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/resource/User"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await TokenManager.clearTokens();
        return {"error": "Session expired. Please login again."};
      } else {
        print("Error Response: ${response.body}");
        return {"error": "Failed to fetch user details"};
      }
    } catch (e) {
      print("Exception: $e");
      return {"error": "Something went wrong. Please try again."};
    }
  }

  static Future<void> logout() async {
    await TokenManager.clearTokens();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login'); // Redirect to login page
  }
}
