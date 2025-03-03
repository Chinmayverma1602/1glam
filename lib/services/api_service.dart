import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://1glam.local:8000/api/resource/User";

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
}
