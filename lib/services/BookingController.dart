import 'package:get/get.dart';
import 'package:glam1/model/booking_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingController extends GetxController {
  var isLoading = false.obs;
  var bookings = <Booking>[].obs;

  List<dynamic> jsonData = [
  {
    "id": "booking_123",
    "customer_name": "John Doe",
    "phone_no": "9876543210",
    "date": "2025-03-22T10:00:00Z",
    "service_name": "Haircut",
    "price": 500,
    "duration": 30,
    "start_time": "2025-03-21T10:00:00Z"
  },
  {
    "id": "booking_124",
    "customer_name": "Jane Doe",
    "phone_no": "9876543211",
    "date": "2025-03-22T14:00:00Z",
    "service_name": "Facial",
    "price": 800,
    "duration": 120,
    "start_time": "2025-03-22T14:00:00Z"
  }
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
