import 'dart:convert';
import 'package:glam1/model/travelling_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/services/api_service.dart';

class TravelFeeService {
  static final String _baseUrl =
      "https://1glambackend-production.up.railway.app/api/resource/TravelFees";

  Future<Map<String, dynamic>?> submitTravelFee(TravelFee travelFee) async {
    try {
      // Get the auth token from TokenManager
      String? token = await TokenManager.getToken();
      if (token == null) {
        print("No auth token found, using default auth token");
        token = ApiConstants.authToken.replaceAll("Bearer ", "");
      }

      // Prepare headers with the proper token
      final Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Create payload matching the example from the API
      final Map<String, dynamic> payload = {
        "user": travelFee.user,
        "fee_type": travelFee.feeType,
        "fee": travelFee.fee,
        "max_distance": travelFee.maxDistance
      };

      print("Sending request to: $_baseUrl");
      print("Request payload: ${jsonEncode(payload)}");
      print("Headers: $headers");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Parse response regardless of status code for debugging
      Map<String, dynamic>? responseData;
      try {
        if (response.body.isNotEmpty) {
          responseData = jsonDecode(response.body);
        }
      } catch (e) {
        print("Failed to parse response: $e");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Travel fee submitted successfully");
        return responseData;
      } else if (response.statusCode == 401) {
        print("Unauthorized - token may be invalid or expired");
        return null;
      } else {
        print("Failed to submit travel fee: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error submitting travel fee: $e");
      return null;
    }
  }
}
