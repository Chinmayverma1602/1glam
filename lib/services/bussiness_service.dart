import 'dart:convert';
import 'package:glam1/model/bussiness_model.dart';
import 'package:http/http.dart' as http;

class BusinessProfileService {
  static const String _baseUrl =
      "http://1glam.local:8000/api/resource/BusinessProfile";
  static const Map<String, String> _headers = {
    "Authorization": "token eb6cdc62a0caeef:b4f7342a55e5049",
    "Content-Type": "application/json",
  };

  static Future<bool> createBusinessProfile(BusinessProfile profile) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Successfully created profile
      } else {
        print("Error: ${response.body}");
        return false; // Failed request
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
