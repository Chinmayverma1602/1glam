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

  static Future<String?> refreshToken() async {
    try {
      // Get stored credentials
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('user_email');
      String? password = prefs.getString('user_password');

      if (email == null || password == null) {
        print("No stored credentials for token refresh");

        // Try to use a refresh token endpoint if available
        String? token = prefs.getString('user_token');
        if (token != null && token.isNotEmpty) {
          try {
            final response = await http.post(
              Uri.parse("${ApiConfig.baseUrl}/api/method/refresh_token"),
              headers: {
                "Authorization": "Bearer $token",
                "Content-Type": "application/json",
                "Accept": "application/json",
              },
            );

            if (response.statusCode == 200) {
              final responseData = jsonDecode(response.body);
              if (responseData['token'] != null) {
                String newToken = responseData['token'];
                await saveToken(newToken);
                return newToken;
              }
            }
          } catch (e) {
            print("Error refreshing token via refresh endpoint: $e");
          }
        }

        // If no refresh token mechanism works, try the guest token
        return ApiConstants.authToken.replaceAll("Bearer ", "");
      }

      // Try to get a new token with stored credentials
      final String url = "${ApiConfig.baseUrl}/api/method/login";
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"usr": email, "pwd": password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['token'] != null) {
          String newToken = responseData['token'];
          // Save the new token
          await saveToken(newToken);
          return newToken;
        }
      }
      return null;
    } catch (e) {
      print("Error refreshing token: $e");
      return null;
    }
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

        // Store password securely for token refresh capability
        await prefs.setString('user_password', password);

        // Save user name
        String? userNameToSave = null;
        if (name != null && name.isNotEmpty) {
          userNameToSave = name;
          await prefs.setString('user_name', name);
        } else {
          // If no name provided, use email username as fallback
          String emailName = email.split('@')[0];
          // Capitalize first letter
          if (emailName.isNotEmpty) {
            emailName = emailName[0].toUpperCase() + emailName.substring(1);
            userNameToSave = emailName;
            await prefs.setString('user_name', emailName);
          }
        }

        // Save the name to multiple keys to ensure it's found
        if (userNameToSave != null && userNameToSave.isNotEmpty) {
          await prefs.setString('user_name', userNameToSave);
          await prefs.setString('userName', userNameToSave);
          await prefs.setString('name', userNameToSave);
          await prefs.setString('displayName', userNameToSave);
        }

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

  // Add a login method that stores credentials for token refresh
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final String url = "${ApiConfig.baseUrl}/api/method/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"usr": email, "pwd": password}),
      );

      print("Login response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token and credentials
        if (responseData['token'] != null) {
          await TokenManager.saveToken(responseData['token']);

          // Store credentials for token refresh
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', email);
          await prefs.setString('user_password', password);

          if (responseData['user_id'] != null) {
            await TokenManager.saveUserId(responseData['user_id']);
          }

          // Store user details if available
          if (responseData['full_name'] != null) {
            String userName = responseData['full_name'];
            await prefs.setString('user_name', userName);
            await prefs.setString('userName', userName);
            await prefs.setString('name', userName);
            await prefs.setString('displayName', userName);
          }
        }

        return responseData;
      } else {
        print("Login error: ${response.body}");
        try {
          return {
            "error": jsonDecode(response.body)['message'] ?? "Login failed"
          };
        } catch (e) {
          return {"error": "Login failed"};
        }
      }
    } catch (e) {
      print("Login exception: $e");
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

      print("User details response status: ${response.statusCode}");
      print("User details response body: ${response.body}");

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
    // Also clear password on logout for security
    await prefs.remove('user_password');
    await prefs.clear();
    Get.offAllNamed('/login'); // Redirect to login page
  }
}
