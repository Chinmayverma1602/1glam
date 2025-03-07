import 'dart:convert';
import 'package:glam1/model/travelling_model.dart';
import 'package:http/http.dart' as http;

class TravelFeeService {
  static const String _baseUrl =
      "http://1glam.local:8000/api/resource/Travel Fees";
  static const Map<String, String> _headers = {
    'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
    'Content-Type': 'application/json',
  };

  Future<bool> submitTravelFee(TravelFee travelFee) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(travelFee.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
