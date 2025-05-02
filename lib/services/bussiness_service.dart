import 'dart:convert';
import 'package:glam1/model/bussiness_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';

class BusinessProfileService {
  static final String _baseUrl =
      "${ApiConstants.baseUrl}/api/resource/BusinessProfile";
  static final Map<String, String> _headers = {
    "Authorization": ApiConstants.authToken,
    "Content-Type": "application/json",
  };

  static Future<bool> createBusinessProfile(BusinessProfile profile) async {
    // Placeholder - API implementation to be added
    return true;
  }
}
