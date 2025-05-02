import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glam1/model/address_model.dart';
import 'package:glam1/constants/api_constants.dart';

class AddressService {
  static final String _baseUrl =
      "${ApiConstants.baseUrl}/api/resource/userAddress";
  static final String _userUrl =
      "${ApiConstants.baseUrl}/api/method/frappe.auth.get_logged_user";

  static final Map<String, String> _headers = {
    'Authorization': ApiConstants.authToken,
    'Content-Type': 'application/json',
  };

  Future<String?> getLoggedInUserEmail() async {
    // Placeholder - API implementation to be added
    return "user@example.com"; // Return a sample email
  }

  Future<UserAddress?> saveAddress(UserAddress address) async {
    // Placeholder - API implementation to be added
    // Return the same address object that was passed in
    return address;
  }
}
