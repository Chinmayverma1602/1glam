class BookingResponseGET {
  final BookingData data;

  BookingResponseGET({required this.data});

  factory BookingResponseGET.fromJson(Map<String, dynamic> json) {
    return BookingResponseGET(
      data: BookingData.fromJson(json['data']),
    );
  }
}

class BookingData {
  final String name;
  final String user;
  final String customerName;
  final String email;
  final String phoneNo;
  final String date;
  final String time;
  final String? location;
  final String? notes;
  final String? address;
  final List<Service> services;

  BookingData({
    required this.name,
    required this.user,
    required this.customerName,
    required this.email,
    required this.phoneNo,
    required this.date,
    required this.time,
    this.location,
    this.notes,
    this.address,
    required this.services,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      name: json['name'],
      user: json['user'],
      customerName: json['customer_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      notes: json['notes'],
      address: json['address'],
      services: (json['services'] as List<dynamic>)
          .map((item) => Service.fromJson(item))
          .toList(),
    );
  }
}

class Service {
  final String name;
  final String serviceName;
  final double price;
  final int idx;
  final String? parent;
  final String? parentType;
  final String? parentField;
  final String? doctype;
  final int? unsaved;

  Service({
    required this.name,
    required this.serviceName,
    required this.price,
    required this.idx,
    this.parent,
    this.parentType,
    this.parentField,
    this.doctype,
    this.unsaved,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      serviceName: json['service_name'],
      price: (json['price'] ?? 0).toDouble(),
      idx: json['idx'],
      parent: json['parent'],
      parentType: json['parenttype'],
      parentField: json['parentfield'],
      doctype: json['doctype'],
      unsaved: json['__unsaved'],
    );
  }
}
