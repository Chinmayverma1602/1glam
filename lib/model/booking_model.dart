import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String customerName;
  final String phoneNo;
  final DateTime date;
  final String serviceName;
  final int price;
  final Duration duration;
  final DateTime startTime;

  Booking({
    required this.id,
    required this.customerName,
    required this.phoneNo,
    required this.date,
    required this.serviceName,
    required this.price,
    required this.duration,
    required this.startTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json, String documentId) {
    // Handle date and startTime from Firestore Timestamp
    DateTime date;
    DateTime startTime;
    
    try {
      date = (json['date'] as Timestamp).toDate();
      startTime = (json['start_time'] as Timestamp).toDate();
    } catch (e) {
      print('Error parsing date/time from Firestore: $e');
      // Fallback in case of parsing errors
      date = DateTime.now();
      startTime = DateTime.now();
    }
    
    return Booking(
      id: documentId,
      customerName: json['customer_name'] as String,
      phoneNo: json['phone_no'] as String,
      date: date,
      serviceName: json['service_name'] as String,
      price: json['price'] as int,
      duration: Duration(minutes: json['duration'] as int),
      startTime: startTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'phone_no': phoneNo,
      'date': Timestamp.fromDate(date),
      'service_name': serviceName,
      'price': price,
      'duration': duration.inMinutes,
      'start_time': Timestamp.fromDate(startTime),
    };
  }

  DateTime get endTime => startTime.add(duration);
}