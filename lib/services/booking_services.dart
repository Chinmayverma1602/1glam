import 'dart:convert';
import 'package:glam1/model/bookingReq_model.dart';
import 'package:glam1/model/bookingRes-get_model.dart';
import 'package:glam1/model/bookingRes-post_model.dart';
import 'package:http/http.dart' as http;



List<BookingResponseGET> sampleBookings = [
  BookingResponseGET(
    data: BookingData(
      name: "bkg001",
      user: "user1@example.com",
      customerName: "Alice Smith",
      email: "alice@example.com",
      phoneNo: "9876543210",
      date: "2025-04-10",
      time: "14:30:00",
      location: "Salon A",
      notes: "Prefer early slot if available",
      address: "123 Main Street",
      services: [
        Service(
          name: "svc001",
          serviceName: "Haircut",
          price: 1500.0,
          idx: 1,
          parent: "bkg001",
          parentType: "Booking Events",
          parentField: "services",
          doctype: "Service Lists",
          unsaved: null,
        ),
        Service(
          name: "svc002",
          serviceName: "Hair Coloring",
          price: 2500.0,
          idx: 2,
          parent: "bkg001",
          parentType: "Booking Events",
          parentField: "services",
          doctype: "Service Lists",
          unsaved: null,
        ),
      ],
    ),
  ),
  BookingResponseGET(
    data: BookingData(
      name: "bkg002",
      user: "user2@example.com",
      customerName: "Bob Johnson",
      email: "bob@example.com",
      phoneNo: "9123456780",
      date: "2025-04-11",
      time: "16:00:00",
      location: "Salon B",
      notes: null,
      address: null,
      services: [
        Service(
          name: "svc003",
          serviceName: "Makeup",
          price: 3000.0,
          idx: 1,
          parent: "bkg002",
          parentType: "Booking Events",
          parentField: "services",
          doctype: "Service Lists",
          unsaved: null,
        ),
      ],
    ),
  ),
  BookingResponseGET(
    data: BookingData(
      name: "bkg003",
      user: "user3@example.com",
      customerName: "Charlie Lee",
      email: "charlie@example.com",
      phoneNo: "9988776655",
      date: "2025-04-12",
      time: "10:00:00",
      location: "Salon C",
      notes: "Allergic to some products",
      address: "Flat 204, Elegant Towers",
      services: [
        Service(
          name: "svc004",
          serviceName: "Hair Spa",
          price: 1800.0,
          idx: 1,
          parent: "bkg003",
          parentType: "Booking Events",
          parentField: "services",
          doctype: "Service Lists",
          unsaved: null,
        ),
        Service(
          name: "svc005",
          serviceName: "Facial",
          price: 2000.0,
          idx: 2,
          parent: "bkg003",
          parentType: "Booking Events",
          parentField: "services",
          doctype: "Service Lists",
          unsaved: null,
        ),
      ],
    ),
  ),
];


class BookingService {
  static const String _baseUrl = 'http://1glam.local:8000/api/resource/Booking Events';
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Authorization": "token eb6cdc62a0caeef:b4f7342a55e5049"
  };

  // POST: Create Booking
  Future<BookingResponsePOST?> createBooking(BookingRequest bookingRequest) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(bookingRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return BookingResponsePOST.fromJson(responseData);
      } else {
        print('Failed to create booking: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error while posting booking: $e');
      return null;
    }
  }

  // GET: All Booking IDs
  Future<List<String>?> fetchBookingIds() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map<String>((item) => item['name'] as String).toList();
      } else {
        throw Exception('Failed to load booking IDs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching booking IDs: $e');
      return null;
    }
  }

  // GET: Booking Details by ID
  Future<BookingResponseGET?> fetchBookingDetails(String bookingId) async {
    try {
      final url = Uri.parse('$_baseUrl/$bookingId');
      final response = await http.get(
        url,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return BookingResponseGET.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch booking details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching booking details: $e');
      return null;
    }
  }

  // GET: All Bookings
  Future<List<BookingResponseGET>> fetchAllBookings() async {
    try {
      List<String>? bookingIds = await fetchBookingIds();
      if (bookingIds == null) return [];

      List<BookingResponseGET> bookings = [];
      for (String id in bookingIds) {
        BookingResponseGET? booking = await fetchBookingDetails(id);
        if (booking != null) {
          bookings.add(booking);
        }
      }
      return bookings;
    } catch (e) {
      print('Error while fetching all bookings: $e');
      return [];
    }
  }
}
