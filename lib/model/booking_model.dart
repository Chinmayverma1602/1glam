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

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      customerName: json['customer_name'],
      phoneNo: json['phone_no'],
      date: DateTime.parse(json['date']),
      serviceName: json['service_name'],
      price: json['price'],
      duration: Duration(minutes: json['duration']),
      startTime: DateTime.parse(json['start_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'phone_no': phoneNo,
      'date': date.toIso8601String(),
      'service_name': serviceName,
      'price': price,
      'duration': duration.inMinutes,
      'start_time': startTime.toIso8601String(),
    };
  }

  DateTime get endTime => startTime.add(duration);
}
