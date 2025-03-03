import 'package:glam1/model/address_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressService {
  static const String _baseUrl =
      "http://1glam.local:8000/api/resource/userAddress";
  static const Map<String, String> _headers = {
    'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
    'Content-Type': 'application/json',
  };

  Future<UserAddress?> saveAddress(UserAddress address) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserAddress.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to save address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving address: $e');
    }
  }
}
