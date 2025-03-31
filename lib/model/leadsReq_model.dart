class LeadsRequest {
  final String clientName;
  final String phoneNumber;
  final String bookingDate;
  final String user;
  final List<ServiceOpted> servicesOpted;

  LeadsRequest({
    required this.clientName,
    required this.phoneNumber,
    required this.bookingDate,
    required this.user,
    required this.servicesOpted,
  });


  factory LeadsRequest.fromJson(Map<String, dynamic> json) {
    return LeadsRequest(
      clientName: json['client_name'] as String,
      phoneNumber: json['phone_number'] as String,
      bookingDate: json['booking_date'] as String,
      user: json['user'] as String,
      servicesOpted: (json['services_opted'] as List)
          .map((e) => ServiceOpted.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'client_name': clientName,
      'phone_number': phoneNumber,
      'booking_date': bookingDate,
      'user': user,
      'services_opted': servicesOpted.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceOpted {
  final String serviceName;
  final int price;

  ServiceOpted({
    required this.serviceName,
    required this.price,
  });

  // Convert JSON to Model
  factory ServiceOpted.fromJson(Map<String, dynamic> json) {
    return ServiceOpted(
      serviceName: json['service_name'] as String,
      price: json['price'] as int,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'price': price,
    };
  }
}
