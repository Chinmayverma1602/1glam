import 'dart:convert';
import 'package:glam1/model/travelling_model.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/api_constants.dart';

class TravelFeeService {
  static final String _baseUrl =
      "${ApiConstants.baseUrl}/api/resource/Travel Fees";
  static final Map<String, String> _headers = {
    'Authorization': ApiConstants.authToken,
    'Content-Type': 'application/json',
  };

  Future<bool> submitTravelFee(TravelFee travelFee) async {
    // Placeholder - API implementation to be added
    return true;
  }
}
