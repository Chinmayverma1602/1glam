import 'dart:convert';
import 'package:glam1/model/bussiness_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/services/api_service.dart';

class BusinessProfileService {
  static final String _baseUrl =
      "${ApiConstants.baseUrl}/api/resource/userBussiness";

  static Future<bool> createBusinessProfile(BusinessProfile profile) async {
    try {
      // Get the auth token from TokenManager
      String? token = await TokenManager.getToken();
      if (token == null) {
        print("No auth token found, using default auth token");
        token = ApiConstants.authToken.replaceAll("Bearer ", "");
      }

      final Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Create the proper request body structure
      final Map<String, dynamic> requestMap = {
        "userId": profile.user,
        "business_name": profile.businessName,
        "business_type": profile.businessType,
        "owner_name": profile.ownerName,
        "phone": profile.phone,
        "address": profile.address,
      };

      // Log the request details
      print("Making API request to: $_baseUrl");
      print("With user ID: ${profile.user}");
      final requestBody = jsonEncode(requestMap);
      print("Request body: $requestBody");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: requestBody,
      );

      // Log response details
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Business profile created: ${responseData['message']}");
        return true;
      } else {
        print("Error creating business profile: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception creating business profile: $e");
      return false;
    }
  }
}
