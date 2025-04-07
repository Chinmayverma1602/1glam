class LeadsResponse {
  final LeadsData data;

  LeadsResponse({required this.data});

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    return LeadsResponse(
      data: LeadsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class LeadsData {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final String clientName;
  final String phoneNumber;
  final String leadStatus;
  final String bookingDate;
  final String fromTime;
  final String toTime;
  final String user;
  final String doctype;
  final List<ServiceOptedres> servicesOpted;

  LeadsData({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.clientName,
    required this.phoneNumber,
    required this.leadStatus,
    required this.bookingDate,
    required this.fromTime,
    required this.toTime,
    required this.user,
    required this.doctype,
    required this.servicesOpted,
  });

  factory LeadsData.fromJson(Map<String, dynamic> json) {
    return LeadsData(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      clientName: json['client_name'],
      phoneNumber: json['phone_number'],
      leadStatus: json['lead_status'],
      bookingDate: json['booking_date'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      user: json['user'],
      doctype: json['doctype'],
      servicesOpted: (json['services_opted'] as List)
          .map((e) => ServiceOptedres.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
      'idx': idx,
      'client_name': clientName,
      'phone_number': phoneNumber,
      'lead_status': leadStatus,
      'booking_date': bookingDate,
      'from_time': fromTime,
      'to_time': toTime,
      'user': user,
      'doctype': doctype,
      'services_opted': servicesOpted.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceOptedres {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final String serviceName;
  final double price;
  final int duration;
  final String serviceType;
  final String parent;
  final String parentfield;
  final String parenttype;
  final String doctype;
  final int unsaved;

  ServiceOptedres({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.serviceName,
    required this.price,
    required this.duration,
    required this.serviceType,
    required this.parent,
    required this.parentfield,
    required this.parenttype,
    required this.doctype,
    required this.unsaved,
  });

  factory ServiceOptedres.fromJson(Map<String, dynamic> json) {
    return ServiceOptedres(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      serviceName: json['service_name'],
      price: (json['price'] as num).toDouble(),
      duration: json['duration'],
      serviceType: json['service_type'],
      parent: json['parent'],
      parentfield: json['parentfield'],
      parenttype: json['parenttype'],
      doctype: json['doctype'],
      unsaved: json['__unsaved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
      'idx': idx,
      'service_name': serviceName,
      'price': price,
      'duration': duration,
      'service_type': serviceType,
      'parent': parent,
      'parentfield': parentfield,
      'parenttype': parenttype,
      'doctype': doctype,
      '__unsaved': unsaved,
    };
  }
}
