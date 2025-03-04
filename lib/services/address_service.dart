import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glam1/model/address_model.dart';

class AddressService {
  static const String _baseUrl =
      "http://1glam.local:8000/api/resource/userAddress";
  static const String _userUrl =
      "http://1glam.local:8000/api/method/frappe.auth.get_logged_user";

  static const Map<String, String> _headers = {
    'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
    'Content-Type': 'application/json',
  };

  Future<String?> getLoggedInUserEmail() async {
    try {
      final response = await http.get(Uri.parse(_userUrl), headers: _headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message']; // Returns logged-in user's email
      } else {
        throw Exception("Failed to fetch logged-in user");
      }
    } catch (e) {
      print("Error fetching user email: $e");
      return null;
    }
  }

  Future<UserAddress?> saveAddress(UserAddress address) async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: _headers,
            body: jsonEncode(address.toJson()),
          )
          .timeout(Duration(seconds: 10));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return UserAddress.fromJson(responseData['data']);
      } else {
        throw Exception(
            'Failed to save address: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error saving address: $e');
    }
  }
}
