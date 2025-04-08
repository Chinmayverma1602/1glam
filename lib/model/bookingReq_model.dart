class BookingRequest {
  final String customerName;
  final String email;
  final String phoneNo;
  final String date;
  final String time;
  final String user;
  final String location;
  final String notes;
  final String address;
  final List<ServiceRequest> services;

  BookingRequest({
    required this.customerName,
    required this.email,
    required this.phoneNo,
    required this.date,
    required this.time,
    required this.user,
    required this.location,
    required this.notes,
    required this.address,
    required this.services,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      customerName: json['customer_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
      date: json['date'],
      time: json['time'],
      user: json['user'],
      location: json['location'],
      notes: json['notes'],
      address: json['address'],
      services: (json['services'] as List<dynamic>)
          .map((service) => ServiceRequest.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'email': email,
      'phone_no': phoneNo,
      'date': date,
      'time': time,
      'user': user,
      'location': location,
      'notes': notes,
      'address': address,
      'services': services.map((s) => s.toJson()).toList(),
    };
  }
}

class ServiceRequest {
  final String serviceName;
  final double price;
  final int duration;

  ServiceRequest({
    required this.serviceName,
    required this.price,
    required this.duration,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      serviceName: json['service_name'],
      price: (json['price'] as num).toDouble(),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'price': price,
      'duration': duration,
    };
  }
}
