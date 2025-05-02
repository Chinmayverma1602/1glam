import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glam1/model/address_model.dart';
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/services/api_service.dart';

class AddressService {
  // Direct URL string instead of using the constant for debugging
  static final String apiBaseUrl =
      "https://1glambackend-production.up.railway.app";
  static final String addressEndpoint = "/api/resource/userAddress";
  static final String fullApiUrl = "$apiBaseUrl$addressEndpoint";

  static final String _userUrl =
      "${ApiConstants.baseUrl}/api/method/frappe.auth.get_logged_user";

  Future<String?> getLoggedInUserEmail() async {
    // Placeholder - API implementation to be added
    return "user@example.com"; // Return a sample email
  }

  Future<UserAddress?> saveAddress(UserAddress address) async {
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
        "user": address.user,
        "address_line_1": address.addressLine1,
        "address_line_2": address.addressLine2 ?? "",
        "city": address.city,
        "zip_code": address.zipCode,
        "state": address.state,
        "is_shared_location": address.isSharedLocation ? 1 : 0,
        "booth_no": address.boothNo ?? "",
      };

      // Log the request details with direct URL for verification
      print("Making API request to: $fullApiUrl");
      print("With user ID: ${address.user}");
      final requestBody = jsonEncode(requestMap);
      print("Request body: $requestBody");

      final response = await http.post(
        Uri.parse(fullApiUrl), // Use the full direct URL here
        headers: headers,
        body: requestBody,
      );

      // Log response details
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Address created: ${responseData['message']}");

        // Parse the address from the response
        return UserAddress.fromJson(responseData['address']);
      } else {
        print("Error creating address: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception creating address: $e");
      return null;
    }
  }
}
