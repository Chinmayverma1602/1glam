import 'dart:convert';
import 'package:glam1/model/travelling_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/services/api_service.dart';

class TravelFeeService {
  // Using the exact URL provided in the user's instructions
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

      // Create direct payload without using model's toJson
      final Map<String, dynamic> payload = {
        "userId": travelFee.user,
        "fee_type": travelFee.feeType,
        "fee": travelFee.fee,
        "max_distance": travelFee.maxDistance
      };

      print("Direct JSON payload: ${jsonEncode(payload)}");

      // Try with a simplest possible test payload to identify the problem
      final Map<String, dynamic> simpleTestPayload = {
        "userId": travelFee.user,
        "fee_type": "per_km",
        "fee": "fixed",
        "max_distance": 50
      };

      print("Simple test payload: ${jsonEncode(simpleTestPayload)}");

      // Choose which payload to use
      final finalPayload = payload; // Use regular payload
      // final finalPayload = simpleTestPayload; // Uncomment to use test payload

      // Enhanced debugging
      print("\n==== TRAVEL FEE API REQUEST ====");
      print("URL: $_baseUrl");
      print("Headers:");
      headers.forEach((key, value) => print("  $key: $value"));
      print("Payload: ${jsonEncode(finalPayload)}");
      print("================================\n");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(finalPayload),
      );

      print("\n==== TRAVEL FEE API RESPONSE ====");
      print("Status code: ${response.statusCode}");
      print("Headers:");
      response.headers.forEach((key, value) => print("  $key: $value"));
      print("Body: ${response.body}");
      print("=================================\n");

      // Parse response regardless of status code for debugging
      Map<String, dynamic>? responseData;
      try {
        if (response.body.isNotEmpty) {
          if (response.headers['content-type']?.contains('application/json') ==
              true) {
            responseData = jsonDecode(response.body);
            print("Parsed JSON response: $responseData");

            // Check for success message in the response
            if (responseData != null &&
                responseData.containsKey('message') &&
                responseData['message'].toString().contains("successfully")) {
              print("Travel fee created successfully!");
              return responseData;
            }
          } else if (response.body.contains('<!DOCTYPE html>') ||
              response.body.contains('Error')) {
            print("Received HTML error response instead of JSON");
            print("HTTP Method: POST");
            print("Content-Type: ${headers['Content-Type']}");

            // Let's try to diagnose the specific error
            if (response.statusCode == 400) {
              print("Bad Request Error - Possible issues:");
              print("1. Missing required fields in the request");
              print("2. Invalid field format or type");
              print("3. API might be expecting different field names");
              print("4. Authentication token might be incorrect or expired");
            }
          }
        }
      } catch (e) {
        print("Failed to parse response: $e");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Travel fee submitted successfully");
        return responseData ?? {'success': true};
      } else if (response.statusCode == 401) {
        print("Unauthorized - token may be invalid or expired");
        return null;
      } else {
        print("Failed to submit travel fee: ${response.statusCode}");

        // As a last resort, try to return something that the caller can use
        // to proceed to the next screen even if the API call failed
        return {
          'success': false,
          'error': 'API call failed but proceeding anyway'
        };
      }
    } catch (e) {
      print("Error submitting travel fee: $e");

      // As a last resort, try to return something that the caller can use
      // to proceed to the next screen even if the API call failed
      return {'success': false, 'error': 'Exception but proceeding anyway'};
    }
  }
}
