import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:glam1/services/api_service.dart';
import 'dart:math';

class BookingController extends GetxController {
  var isLoading = false.obs;
  RxList<Booking> bookings = <Booking>[].obs;

  @override
  void onInit() {
    fetchBookingsFromApi();
    super.onInit();
  }

  // Fetch bookings from the API
  Future<void> fetchBookingsFromApi() async {
    try {
      isLoading.value = true;

      // Clear existing bookings to avoid duplicates
      bookings.clear();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('user_token');

      if (token == null) {
        print('No token found, cannot fetch bookings');
        return;
      }

      print(
          'Fetching bookings with token: ${token.substring(0, min(10, token.length))}...');

      final response = await http.get(
        Uri.parse(
            'https://1glambackend-production.up.railway.app/api/resource/userBookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Bookings API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Successfully received bookings response');
        final data = json.decode(response.body);

        print(
            'Response data: ${json.encode(data).substring(0, min(100, json.encode(data).length))}...');

        if (data['customerBookings'] != null) {
          final List<dynamic> bookingsJson = data['customerBookings'];
          print('Found ${bookingsJson.length} bookings in response');

          if (bookingsJson.isNotEmpty) {
            // Print the first booking for debugging
            print(
                'First booking: ${json.encode(bookingsJson[0]).substring(0, min(100, json.encode(bookingsJson[0]).length))}...');
          }

          // Convert API response to Booking objects
          List<Booking> newBookings = [];
          for (var json in bookingsJson) {
            try {
              Booking booking = _convertApiBookingToModel(json);
              newBookings.add(booking);
              print(
                  'Added booking: ${booking.customerName} on ${DateFormat('yyyy-MM-dd').format(booking.date)}');
            } catch (e) {
              print('Error converting booking: $e');
            }
          }

          bookings.assignAll(newBookings);
          print('Total bookings loaded: ${bookings.length}');
        } else {
          print('No bookings found in response or invalid response format');
        }

        // After fetching, ensure we have test data for visibility testing
        if (bookings.isEmpty) {
          await ensureTestDataLoaded();
        }
      } else {
        print('Failed to fetch bookings: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Try to fetch with a different endpoint as fallback
        await _fetchBookingsAlternate(token);
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      // Add test data if fetch fails
      await ensureTestDataLoaded();
    } finally {
      isLoading.value = false;
    }
  }

  // Alternative method to fetch bookings (fallback)
  Future<void> _fetchBookingsAlternate(String token) async {
    try {
      print('Trying alternate booking endpoint...');

      final response = await http.get(
        Uri.parse(
            'https://1glambackend-production.up.railway.app/api/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Alternate endpoint status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          // Handle direct list response
          print('Found ${data.length} bookings in alternate endpoint');

          List<Booking> newBookings = [];
          for (var json in data) {
            try {
              Booking booking = _convertApiBookingToModel(json);
              newBookings.add(booking);
            } catch (e) {
              print('Error converting booking from alternate endpoint: $e');
            }
          }

          bookings.assignAll(newBookings);
          print(
              'Total bookings loaded from alternate endpoint: ${bookings.length}');
        } else if (data['bookings'] != null && data['bookings'] is List) {
          // Handle nested bookings structure
          final List<dynamic> bookingsJson = data['bookings'];
          print(
              'Found ${bookingsJson.length} bookings in alternate endpoint (nested)');

          List<Booking> newBookings = [];
          for (var json in bookingsJson) {
            try {
              Booking booking = _convertApiBookingToModel(json);
              newBookings.add(booking);
            } catch (e) {
              print('Error converting booking from alternate endpoint: $e');
            }
          }

          bookings.assignAll(newBookings);
          print(
              'Total bookings loaded from alternate endpoint: ${bookings.length}');
        }
      }
    } catch (e) {
      print('Error with alternate booking endpoint: $e');
    }
  }

  // Convert API booking format to our Booking model
  Booking _convertApiBookingToModel(Map<String, dynamic> json) {
    print(
        'Converting API booking: ${json.toString().substring(0, min(100, json.toString().length))}...');

    // Parse booking time string (e.g., "16:30:00 - 18:30:00")
    String timeString = json['booking_time'] ?? "00:00:00 - 00:00:00";
    List<String> timeParts = timeString.split(' - ');

    // Parse booking date with robust handling
    DateTime bookingDate = DateTime.now(); // Default to today
    try {
      // Get date value from possible fields
      dynamic dateValue =
          json['booking_date'] ?? json['date'] ?? json['bookingDate'];
      print(
          'Date value from API: $dateValue (type: ${dateValue?.runtimeType})');

      if (dateValue != null) {
        if (dateValue is String) {
          // Handle ISO date format with T
          if (dateValue.contains('T')) {
            bookingDate = DateTime.parse(dateValue);
            print('Parsed ISO date: $dateValue → ${bookingDate.toString()}');
          }
          // Handle YYYY-MM-DD format
          else if (dateValue.length >= 10 && dateValue.contains('-')) {
            try {
              bookingDate = DateTime.parse(dateValue.substring(0, 10));
              print(
                  'Parsed YYYY-MM-DD date: $dateValue → ${bookingDate.toString()}');
            } catch (e) {
              print('Error parsing YYYY-MM-DD: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing date: $e, using today\'s date');
    }

    // Ensure the date part is set correctly - strip time if needed
    bookingDate =
        DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    print('Final booking date (normalized): ${bookingDate.toString()}');

    // Parse start time
    DateTime startTime = bookingDate; // Default to start of day
    try {
      List<String> startTimeParts = timeParts[0].split(':');
      if (startTimeParts.length >= 2) {
        int hour = int.tryParse(startTimeParts[0]) ?? 0;
        int minute = int.tryParse(startTimeParts[1]) ?? 0;
        startTime = DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          hour,
          minute,
        );
        print('Parsed start time: ${startTime.hour}:${startTime.minute}');
      }
    } catch (e) {
      print('Error parsing start time: $e');
    }

    // Calculate duration
    Duration duration = Duration(hours: 1); // Default 1 hour
    try {
      if (timeParts.length > 1) {
        List<String> endTimeParts = timeParts[1].split(':');
        if (endTimeParts.length >= 2) {
          int hour = int.tryParse(endTimeParts[0]) ?? 0;
          int minute = int.tryParse(endTimeParts[1]) ?? 0;
          DateTime endTime = DateTime(
            bookingDate.year,
            bookingDate.month,
            bookingDate.day,
            hour,
            minute,
          );
          duration = endTime.difference(startTime);
          if (duration.inMinutes <= 0) {
            // If end time is before start time, default to 1 hour
            duration = Duration(hours: 1);
          }
        }
      }
    } catch (e) {
      print('Error calculating duration: $e');
    }

    // Extract other fields with fallbacks
    String customerName = json['customer_name'] ??
        json['customerName'] ??
        json['name'] ??
        'Unknown Customer';

    String phoneNo =
        json['phone_number'] ?? json['phoneNumber'] ?? json['phone_no'] ?? '';

    String serviceName = json['service_name'] ??
        json['serviceName'] ??
        json['service'] ??
        'Unknown Service';

    // Parse price safely
    int price = 0;
    try {
      dynamic priceValue = json['price'];
      if (priceValue is int) {
        price = priceValue;
      } else if (priceValue is String) {
        price = int.tryParse(priceValue) ?? 0;
      } else if (priceValue is double) {
        price = priceValue.toInt();
      }
    } catch (e) {
      print('Error parsing price: $e');
    }

    // Get ID
    String id = json['_id'] ??
        json['id'] ??
        'booking_${DateTime.now().millisecondsSinceEpoch}';

    print(
        'Created booking model: $customerName on ${DateFormat('yyyy-MM-dd').format(bookingDate)}');

    return Booking(
      id: id,
      customerName: customerName,
      phoneNo: phoneNo,
      date: bookingDate,
      serviceName: serviceName,
      price: price,
      duration: duration,
      startTime: startTime,
    );
  }

  // Add a method to check if the API is accessible
  Future<void> _checkApiAccessibility() async {
    try {
      final response = await http.get(
        Uri.parse('https://1glambackend-production.up.railway.app/api'),
      );

      print('API accessibility check status: ${response.statusCode}');
      print('API accessibility response: ${response.body}');
    } catch (e) {
      print('Error checking API accessibility: $e');
    }
  }

  // Add a new booking via API
  Future<bool> addBookingToApi(Map<String, dynamic> bookingData) async {
    try {
      isLoading.value = true;

      // Check if the API is accessible
      await _checkApiAccessibility();

      // Get the token and user ID using TokenManager
      String? token = await TokenManager.getToken();
      String? userId = await TokenManager.getUserId();

      print('Token: ${token != null ? 'Found' : 'Not found'}');
      print('User ID from TokenManager: $userId');

      if (token == null) {
        // Try to get token from shared preferences with different key
        SharedPreferences prefs = await SharedPreferences.getInstance();
        token = prefs.getString('user_token') ?? prefs.getString('token');
        print(
            'Token from SharedPreferences: ${token != null ? 'Found' : 'Not found'}');
      }

      if (userId == null || userId.isEmpty) {
        // Try to get user ID from shared preferences with different keys
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = prefs.getString('user_id') ??
            prefs.getString('userId') ??
            prefs.getString('id');

        // If still null, try to get from user email
        if (userId == null || userId.isEmpty) {
          String? email = prefs.getString('user_email');
          if (email != null && email.isNotEmpty) {
            // Use email as fallback
            print('Using email as fallback for user identification');
            // As a last resort, use a hardcoded ID for testing
            userId =
                "68147786cc7c79ccbf7e39f1"; // Hardcoded ID from your example
          }
        }

        print('User ID from SharedPreferences/Fallback: $userId');
      }

      if (token == null) {
        print('Authentication token not found');
        return false;
      }

      if (userId == null || userId.isEmpty) {
        print('User ID not found, using hardcoded ID for testing');
        userId = "68147786cc7c79ccbf7e39f1"; // Hardcoded ID as last resort
      }

      // Format booking date to YYYY-MM-DD
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(bookingData["date"]);

      // Format booking time as "HH:MM:SS - HH:MM:SS"
      String formattedTime =
          "${_formatTimeOfDay(bookingData["start_time"])} - ${_formatTimeOfDay(bookingData["end_time"])}";

      // Make sure phone number has proper format (add + if missing)
      String phoneNumber = bookingData["phone_no"].toString();
      if (!phoneNumber.startsWith('+') && !phoneNumber.startsWith('0')) {
        // Add + prefix if not present for international format
        phoneNumber = "+$phoneNumber";
      }

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "customer_name": bookingData["customer_name"],
        "user": userId,
        "booking_time": formattedTime,
        "booking_date": formattedDate,
        "service_name": bookingData["service_name"],
        "lead_status": "Confirmed",
        "phone_number": phoneNumber,
        "price": bookingData["price"],
        "notes": bookingData["notes"] ?? ""
      };

      print('============ Request body =============');
      print(json.encode(requestBody));
      print('======================================');

      // First try a simple direct approach
      try {
        print('Trying direct API approach first...');
        final response = await http.post(
          Uri.parse(
              'https://1glambackend-production.up.railway.app/api/resource/userBookings'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        print('Direct approach response status: ${response.statusCode}');
        print('Direct approach response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Booking created successfully with direct approach!');

          // Parse the response to get the newly created booking
          try {
            final responseData = json.decode(response.body);
            if (responseData['customerBooking'] != null) {
              print('Adding new booking from response to the bookings list');
              final newBooking =
                  _convertApiBookingToModel(responseData['customerBooking']);
              bookings.add(newBooking);
              print(
                  'Added new booking: ${newBooking.customerName} on ${DateFormat('yyyy-MM-dd').format(newBooking.date)}');
            } else {
              // If we can't get the booking from response, fetch all bookings
              print('No booking data in response, refreshing all bookings');
              await fetchBookingsFromApi();
            }
          } catch (e) {
            print('Error parsing booking response: $e');
            // Fall back to fetching all bookings
            await fetchBookingsFromApi();
          }

          return true;
        }
      } catch (e) {
        print('Error with direct approach: $e');
      }

      // If direct approach failed, try variations
      bool success = await _tryApiRequestWithVariations(token, requestBody);
      return success;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Try a request format that exactly matches the example
  Future<bool> _tryExactApiFormat(
      String token, Map<String, dynamic> requestBody) async {
    try {
      print('Trying with exact API format from example');

      // Using the exact format from the example
      final exactRequestBody = {
        "customer_name": requestBody["customer_name"],
        "user": requestBody["user"],
        "booking_time": requestBody["booking_time"],
        "booking_date": requestBody["booking_date"],
        "service_name": requestBody["service_name"],
        "lead_status": "Confirmed",
        "phone_number": requestBody["phone_number"],
        "price": requestBody["price"],
        "notes": requestBody["notes"]
      };

      print('Exact request body: ${json.encode(exactRequestBody)}');

      final response = await http.post(
        Uri.parse(
            'https://1glambackend-production.up.railway.app/api/resource/userBookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(exactRequestBody),
      );

      print('Exact format response status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Booking created successfully with exact format!');
        await fetchBookingsFromApi();
        return true;
      } else {
        print('Failed with exact format. Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error with exact format request: $e');
      return false;
    }
  }

  // Try API request with different content types and variations
  Future<bool> _tryApiRequestWithVariations(
      String token, Map<String, dynamic> requestBody) async {
    // First try the exact format that matches the example
    bool exactFormatSuccess = await _tryExactApiFormat(token, requestBody);
    if (exactFormatSuccess) {
      return true;
    }

    // If exact format failed, try other variations

    // List of possible content types to try
    List<Map<String, String>> headerVariations = [
      {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    ];

    // List of possible URL variations to try
    List<String> urlVariations = [
      'https://1glambackend-production.up.railway.app/api/resource/userBookings',
      'https://1glambackend-production.up.railway.app/api/resource/userBooking',
      'https://1glambackend-production.up.railway.app/api/userBookings',
      'https://1glambackend-production.up.railway.app/api/bookings'
    ];

    bool success = false;

    // Try each URL variation
    for (var url in urlVariations) {
      print('Trying URL: $url');

      // Try each header variation with current URL
      for (var headers in headerVariations) {
        print('Trying with headers: $headers');

        try {
          final response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: json.encode(requestBody),
          );

          print('Response status: ${response.statusCode}');
          print('Response headers: ${response.headers}');
          print('Response body length: ${response.body.length}');
          print(
              'Response body preview: ${response.body.substring(0, min(100, response.body.length))}...');

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Booking was created successfully
            print(
                'Booking created successfully with URL: $url and headers: $headers');
            await fetchBookingsFromApi(); // Refresh bookings list
            success = true;
            return success; // Exit early if successful
          } else {
            print('Failed with URL: $url and headers: $headers');

            // Try to parse error message if it's JSON
            try {
              if (response.body.contains('{') && response.body.contains('}')) {
                final errorData = json.decode(response.body);
                print('Error data: $errorData');
              } else {
                print('Error response is not JSON');
              }
            } catch (e) {
              print('Error parsing response: $e');
            }
          }
        } catch (e) {
          print('Error with request using URL $url and headers $headers: $e');
        }
      }
    }

    return success;
  }

  // Helper method to format TimeOfDay to string (HH:MM:SS)
  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void listenToFirestoreBookings() {
    // Keep this for backward compatibility or remove if not needed
  }

  Future<void> addBookingToFirestore(dynamic bookingData) async {
    // Keep this for backward compatibility or remove if not needed
  }

  // Add a utility method to ensure we have test data (for development)
  Future<void> ensureTestDataLoaded() async {
    if (bookings.isEmpty) {
      print('No bookings found - adding test data for visibility testing');

      // Today's booking
      DateTime today = DateTime.now();

      // Add at least one booking for today for testing
      final todayBooking = Booking(
        id: 'test_today_${DateTime.now().millisecondsSinceEpoch}',
        customerName: 'Test Customer',
        phoneNo: '+1234567890',
        date: today,
        serviceName: 'Test Service',
        price: 1500,
        duration: Duration(hours: 1),
        startTime: DateTime(today.year, today.month, today.day, 10, 0),
      );

      bookings.add(todayBooking);
      print('Added test booking for today');
    }
  }
}
