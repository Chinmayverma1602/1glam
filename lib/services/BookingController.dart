import 'package:get/get.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingController extends GetxController {
  var isLoading = false.obs;
  var bookings = <Booking>[].obs;

  List<dynamic> jsonData = [
      {
        "customer_name": "John Doe",
        "email": "john.doe@example.com",
        "phone_no": "+1234567890",
        "date": "2025-03-22",
        "time": "10:00 AM",
        "user": "user_123",
        "services": [
          {"service_name": "Haircut", "price": 2500},
          {"service_name": "Beard Trim", "price": 15}
        ]
      },
  ];

  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }

  Future<void> fetchBookings() async {
    bookings.assignAll(jsonData.map((json) => Booking.fromJson(json)).toList());

    // try {
    //   isLoading(false);
    //   final response = await http.get(Uri.parse('https://your-api-url.com/bookings'));

    //   if (response.statusCode == 200) {
    //     List<dynamic> jsonData = json.decode(response.body);
    //     bookings.value = jsonData.map((json) => Booking.fromJson(json)).toList();
    //   } else {
    //     Get.snackbar("Error", "Failed to load bookings");
    //   }
    // } catch (e) {
    //   Get.snackbar("Error", e.toString());
    // } finally {
    //   isLoading(false);
    // }
  }


  Future<void> updateBooking(String id, Booking updatedBooking) async {
    try {
      final response = await http.put(
        Uri.parse('https://your-api-url.com/bookings/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedBooking.toJson()),
      );

      if (response.statusCode == 200) {
        int index = bookings.indexWhere((b) => b.date == updatedBooking.date); // Assuming date is unique
        if (index != -1) {
          bookings[index] = updatedBooking;
        }
        Get.snackbar("Success", "Booking updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update booking");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Add a new booking
  Future<void> addBooking(Booking newBooking) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/bookings'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newBooking.toJson()),
      );

      if (response.statusCode == 201) {
        bookings.add(newBooking);
        Get.snackbar("Success", "Booking added successfully");
      } else {
        Get.snackbar("Error", "Failed to add booking");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Delete a booking
  Future<void> deleteBooking(String id) async {
    try {
      final response = await http.delete(Uri.parse('https://your-api-url.com/bookings/$id'));

      if (response.statusCode == 200) {
        bookings.removeWhere((b) => b.date == id); // Assuming date is the unique identifier
        Get.snackbar("Success", "Booking deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete booking");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
