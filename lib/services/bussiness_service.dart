import 'dart:convert';
import 'package:glam1/model/bussiness_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileService {
  static final String _baseUrl =
      "${ApiConstants.baseUrl}/api/resource/userBusiness";

  static Future<String?> refreshToken() async {
    return TokenManager.refreshToken();
  }

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

      // Handle 401 Unauthorized - Try to refresh token and retry
      if (response.statusCode == 401) {
        print("Token expired, attempting to refresh...");
        String? newToken = await refreshToken();

        if (newToken != null) {
          // Retry with new token
          headers["Authorization"] = "Bearer $newToken";
          final retryResponse = await http.post(
            Uri.parse(_baseUrl),
            headers: headers,
            body: requestBody,
          );

          print("Retry response status code: ${retryResponse.statusCode}");
          print("Retry response body: ${retryResponse.body}");

          if (retryResponse.statusCode == 200 ||
              retryResponse.statusCode == 201) {
            final responseData = jsonDecode(retryResponse.body);
            print("Business profile created: ${responseData['message']}");
            return true;
          }
        } else {
          print("Failed to refresh token");
        }
      }

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

  // Method to get user's business profile
  static Future<BusinessProfile?> getUserBusinessProfile() async {
    try {
      // Get the auth token from TokenManager
      String? token = await TokenManager.getToken();
      if (token == null) {
        print("No auth token found, using default auth token");
        token = ApiConstants.authToken.replaceAll("Bearer ", "");
      }

      // Get user ID
      String? userId = await TokenManager.getUserId();
      if (userId == null || userId.isEmpty) {
        // Try to get from shared preferences as a fallback
        final prefs = await SharedPreferences.getInstance();
        userId = prefs.getString('user_id');

        if (userId == null || userId.isEmpty) {
          // Try to use email as a last resort
          final userEmail = prefs.getString('user_email');
          if (userEmail != null && userEmail.isNotEmpty) {
            userId = userEmail;
          } else {
            throw Exception("Unable to determine user ID");
          }
        }
      }

      final Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Construct the URL with the user ID as a query parameter
      final url = Uri.parse("$_baseUrl?userId=$userId");

      print("Fetching business profile from: $url");
      final response = await http.get(url, headers: headers);

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle 401 Unauthorized - Try to refresh token and retry
      if (response.statusCode == 401) {
        print("Token expired, attempting to refresh...");
        String? newToken = await refreshToken();

        if (newToken != null) {
          // Retry with new token
          headers["Authorization"] = "Bearer $newToken";
          final retryResponse = await http.get(url, headers: headers);

          print("Retry response status code: ${retryResponse.statusCode}");
          print("Retry response body: ${retryResponse.body}");

          if (retryResponse.statusCode == 200) {
            final responseData = jsonDecode(retryResponse.body);

            // Process response data as before
            if (responseData.containsKey('data') &&
                responseData['data'] is Map<String, dynamic>) {
              return BusinessProfile.fromJson(responseData['data']);
            } else if (responseData.containsKey('data') &&
                responseData['data'] is List &&
                responseData['data'].isNotEmpty) {
              return BusinessProfile.fromJson(responseData['data'][0]);
            } else if (responseData.containsKey('business_name') ||
                responseData.containsKey('userId')) {
              return BusinessProfile.fromJson(responseData);
            }
          }
        } else {
          print("Failed to refresh token");
        }
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check for a 'data' field with business profile information
        if (responseData.containsKey('data') &&
            responseData['data'] is Map<String, dynamic>) {
          return BusinessProfile.fromJson(responseData['data']);
        }
        // If data is a list, take the first one
        else if (responseData.containsKey('data') &&
            responseData['data'] is List &&
            responseData['data'].isNotEmpty) {
          return BusinessProfile.fromJson(responseData['data'][0]);
        }
        // Try to see if the response itself is the business profile
        else if (responseData.containsKey('business_name') ||
            responseData.containsKey('userId')) {
          return BusinessProfile.fromJson(responseData);
        } else {
          print("Unexpected response format: $responseData");
          return null;
        }
      } else {
        print("Error fetching business profile: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception fetching business profile: $e");
      return null;
    }
  }

  // Method to update user's business profile
  static Future<bool> updateBusinessProfile(BusinessProfile profile) async {
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
        "at_my_place": profile.atMyPlace ? 1 : 0,
        "at_client_location": profile.atClientLocation ? 1 : 0,
      };

      print("Updating business profile for user: ${profile.user}");
      final requestBody = jsonEncode(requestMap);

      // Use PATCH or PUT for updates based on API requirements
      final response = await http.put(
        Uri.parse("$_baseUrl/${profile.user}"),
        headers: headers,
        body: requestBody,
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle 401 Unauthorized - Try to refresh token and retry
      if (response.statusCode == 401) {
        print("Token expired, attempting to refresh...");
        String? newToken = await refreshToken();

        if (newToken != null) {
          // Retry with new token
          headers["Authorization"] = "Bearer $newToken";
          final retryResponse = await http.put(
            Uri.parse("$_baseUrl/${profile.user}"),
            headers: headers,
            body: requestBody,
          );

          print("Retry response status code: ${retryResponse.statusCode}");
          print("Retry response body: ${retryResponse.body}");

          return retryResponse.statusCode >= 200 &&
              retryResponse.statusCode < 300;
        } else {
          print("Failed to refresh token");
        }
      }

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print("Exception updating business profile: $e");
      return false;
    }
  }

  // Method to get combined user profile data
  static Future<Map<String, dynamic>> getCombinedUserProfile() async {
    Map<String, dynamic> result = {
      'name': '',
      'email': '',
      'profile': null,
      'address': null,
      'error': null
    };

    try {
      // Get user ID for direct endpoint calls
      String? userId = await TokenManager.getUserId();
      if (userId == null || userId.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = prefs.getString('user_id');
      }

      // Include userId in the result
      if (userId != null && userId.isNotEmpty) {
        result['userId'] = userId;
      }

      // First, try to get the business profile
      BusinessProfile? businessProfile = await getUserBusinessProfile();
      result['profile'] = businessProfile;

      // Try to get address data from SharedPreferences
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Check if we have address info saved in preferences
        String? addressData = prefs.getString('user_address');
        if (addressData != null && addressData.isNotEmpty) {
          Map<String, dynamic> addressMap = jsonDecode(addressData);
          result['address'] = addressMap;
        }
      } catch (e) {
        print("Error fetching address data: $e");
      }

      // Try to get user details from API
      if (userId != null && userId.isNotEmpty) {
        try {
          // Get the auth token from TokenManager
          String? token = await TokenManager.getToken();
          if (token == null) {
            token = ApiConstants.authToken.replaceAll("Bearer ", "");
          }

          final Map<String, String> headers = {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          };

          // Construct the URL to get specific user details
          final url =
              Uri.parse("${ApiConstants.baseUrl}/api/resource/User/$userId");

          print("Fetching user details from: $url");
          final response = await http.get(url, headers: headers);

          print("User details response status: ${response.statusCode}");
          print("User details response body: ${response.body}");

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);

            // Handle different response formats
            if (responseData.containsKey('data')) {
              final userData = responseData['data'];

              // Try to extract name from various fields
              if (userData.containsKey('first_name') &&
                  userData['first_name'] != null) {
                result['name'] = userData['first_name'];
                if (userData.containsKey('last_name') &&
                    userData['last_name'] != null) {
                  result['name'] += " ${userData['last_name']}";
                }
              } else if (userData.containsKey('name')) {
                result['name'] = userData['name'];
              }

              // Get email
              if (userData.containsKey('email')) {
                result['email'] = userData['email'];
              }
            } else if (responseData.containsKey('first_name') ||
                responseData.containsKey('name')) {
              // Try direct access if data is at top level
              if (responseData.containsKey('first_name') &&
                  responseData['first_name'] != null) {
                result['name'] = responseData['first_name'];
                if (responseData.containsKey('last_name') &&
                    responseData['last_name'] != null) {
                  result['name'] += " ${responseData['last_name']}";
                }
              } else if (responseData.containsKey('name')) {
                result['name'] = responseData['name'];
              }

              if (responseData.containsKey('email')) {
                result['email'] = responseData['email'];
              }
            }
          } else if (response.statusCode == 401) {
            result['error'] = "401 Unauthorized - Token expired";
          }
        } catch (e) {
          print("Error fetching user details: $e");
          // Continue processing, we'll try other sources
        }
      }

      // If we couldn't get a name from the user API, try to use owner_name from business profile
      if (result['name'].isEmpty &&
          businessProfile != null &&
          businessProfile.ownerName.isNotEmpty) {
        result['name'] = businessProfile.ownerName;
      }

      // If we still don't have a name or email, try getting from shared preferences
      if (result['name'].isEmpty || result['email'].isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (result['name'].isEmpty) {
          final savedName = prefs.getString('user_name') ??
              prefs.getString('name') ??
              prefs.getString('displayName');
          if (savedName != null && savedName.isNotEmpty) {
            result['name'] = savedName;
          }
        }

        if (result['email'].isEmpty) {
          final savedEmail = prefs.getString('user_email');
          if (savedEmail != null && savedEmail.isNotEmpty) {
            result['email'] = savedEmail;

            // If we still don't have a userId, use email as fallback
            if (!result.containsKey('userId') ||
                result['userId'] == null ||
                result['userId'].isEmpty) {
              result['userId'] = savedEmail;
            }
          }
        }
      }
    } catch (e) {
      print("Exception getting combined profile: $e");
      result['error'] = e.toString();
    }

    return result;
  }
}
