class Booking {
  final String customerName;
  final String email;
  final String phoneNo;
  final String date;
  final String time;
  final String user;
  final List<Service> services;

  Booking({
    required this.customerName,
    required this.email,
    required this.phoneNo,
    required this.date,
    required this.time,
    required this.user,
    required this.services,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      customerName: json['customer_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
      date: json['date'],
      time: json['time'],
      user: json['user'],
      services: (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer_name": customerName,
      "email": email,
      "phone_no": phoneNo,
      "date": date,
      "time": time,
      "user": user,
      "services": services.map((service) => service.toJson()).toList(),
    };
  }
}

class Service {
  final String serviceName;
  final int price;

  Service({required this.serviceName, required this.price});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceName: json['service_name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "service_name": serviceName,
      "price": price,
    };
  }
}
