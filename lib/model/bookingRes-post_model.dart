class BookingResponsePOST {
  final BookingDataPOST data;

  BookingResponsePOST({required this.data});

  factory BookingResponsePOST.fromJson(Map<String, dynamic> json) {
    return BookingResponsePOST(
      data: BookingDataPOST.fromJson(json['data']),
    );
  }
}

class BookingDataPOST {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final String user;
  final String customerName;
  final String email;
  final String phoneNo;
  final String date;
  final String time;
  final int totalDuration;
  final String location;
  final String notes;
  final String address;
  final String doctype;
  final List<ServiceItemPost> services;

  BookingDataPOST({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.user,
    required this.customerName,
    required this.email,
    required this.phoneNo,
    required this.date,
    required this.time,
    required this.totalDuration,
    required this.location,
    required this.notes,
    required this.address,
    required this.doctype,
    required this.services,
  });

  factory BookingDataPOST.fromJson(Map<String, dynamic> json) {
    return BookingDataPOST(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      user: json['user'],
      customerName: json['customer_name'],
      email: json['email'],
      phoneNo: json['phone_no'],
      date: json['date'],
      time: json['time'],
      totalDuration: json['total_duration'],
      location: json['location'],
      notes: json['notes'],
      address: json['address'],
      doctype: json['doctype'],
      services: (json['services'] as List)
          .map((e) => ServiceItemPost.fromJson(e))
          .toList(),
    );
  }
}

class ServiceItemPost {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final String serviceName;
  final double price;
  final String parent;
  final String parentField;
  final String parentType;
  final String doctype;
  final int? unsaved;

  ServiceItemPost({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.serviceName,
    required this.price,
    required this.parent,
    required this.parentField,
    required this.parentType,
    required this.doctype,
    this.unsaved,
  });

  factory ServiceItemPost.fromJson(Map<String, dynamic> json) {
    return ServiceItemPost(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      serviceName: json['service_name'],
      price: (json['price'] as num).toDouble(),
      parent: json['parent'],
      parentField: json['parentfield'],
      parentType: json['parenttype'],
      doctype: json['doctype'],
      unsaved: json['__unsaved'],
    );
  }
}
