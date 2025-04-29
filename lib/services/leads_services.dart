import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/leadsReq_model.dart';
import '../model/leadsRes_model.dart';

//SAMPLE response for get all leads request to be shown on the main leads page
List<LeadsResponse> sampleLeads = [
  LeadsResponse(
    data: LeadsData(
      name: "lead1",
      owner: "Administrator",
      creation: "2025-03-28 10:50:10.765407",
      modified: "2025-03-28 10:50:10.765407",
      modifiedBy: "Administrator",
      docstatus: 0,
      idx: 0,
      clientName: "John Doe",
      phoneNumber: "9876543210",
      leadStatus: "Inbound",
      bookingDate: "2025-04-01",
      fromTime: "10:50:10.763896",
      toTime: "10:50:10.763944",
      user: "john.doe@gmail.com",
      doctype: "Leads",
      servicesOpted: [
        ServiceOptedres(
          name: "service1",
          owner: "Administrator",
          creation: "2025-03-28 10:50:10.765407",
          modified: "2025-03-28 10:50:10.765407",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Bridal Makeup",
          price: 5000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead1",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
        ServiceOptedres(
          name: "service2",
          owner: "Administrator",
          creation: "2025-03-29 12:30:15.123456",
          modified: "2025-03-29 12:30:15.123456",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Hair Styling",
          price: 3000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead2",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
      ],
    ),
  ),
  LeadsResponse(
    data: LeadsData(
      name: "lead2",
      owner: "Administrator",
      creation: "2025-03-29 12:30:15.123456",
      modified: "2025-03-29 12:30:15.123456",
      modifiedBy: "Administrator",
      docstatus: 0,
      idx: 1,
      clientName: "Jane Smith",
      phoneNumber: "9876512345",
      leadStatus: "Qualifying",
      bookingDate: "2025-04-02",
      fromTime: "11:00:00",
      toTime: "13:00:00",
      user: "jane.smith@gmail.com",
      doctype: "Leads",
      servicesOpted: [
        ServiceOptedres(
          name: "service2",
          owner: "Administrator",
          creation: "2025-03-29 12:30:15.123456",
          modified: "2025-03-29 12:30:15.123456",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Hair Styling",
          price: 3000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead2",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
      ],
    ),
  ),
  LeadsResponse(
    data: LeadsData(
      name: "lead3",
      owner: "Administrator",
      creation: "2025-03-30 14:45:22.678901",
      modified: "2025-03-30 14:45:22.678901",
      modifiedBy: "Administrator",
      docstatus: 0,
      idx: 2,
      clientName: "Alice Brown",
      phoneNumber: "9876598765",
      leadStatus: "Proposal Sent",
      bookingDate: "2025-04-03",
      fromTime: "14:00:00",
      toTime: "15:30:00",
      user: "alice.brown@gmail.com",
      doctype: "Leads",
      servicesOpted: [
        ServiceOptedres(
          name: "service3",
          owner: "Administrator",
          creation: "2025-03-30 14:45:22.678901",
          modified: "2025-03-30 14:45:22.678901",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Nail Art",
          price: 2000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead3",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
      ],
    ),
  ),
  LeadsResponse(
    data: LeadsData(
      name: "lead4",
      owner: "Administrator",
      creation: "2025-03-31 09:10:33.876543",
      modified: "2025-03-31 09:10:33.876543",
      modifiedBy: "Administrator",
      docstatus: 0,
      idx: 3,
      clientName: "Robert White",
      phoneNumber: "9876587654",
      leadStatus: "Confirmed",
      bookingDate: "2025-04-04",
      fromTime: "16:00:00",
      toTime: "18:00:00",
      user: "robert.white@gmail.com",
      doctype: "Leads",
      servicesOpted: [
        ServiceOptedres(
          name: "service4",
          owner: "Administrator",
          creation: "2025-03-31 09:10:33.876543",
          modified: "2025-03-31 09:10:33.876543",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Facial",
          price: 4000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead4",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
      ],
    ),
  ),
  LeadsResponse(
    data: LeadsData(
      name: "lead5",
      owner: "Administrator",
      creation: "2025-04-01 08:30:40.123789",
      modified: "2025-04-01 08:30:40.123789",
      modifiedBy: "Administrator",
      docstatus: 0,
      idx: 4,
      clientName: "Sophia Green",
      phoneNumber: "9876576543",
      leadStatus: "Deposit Requested",
      bookingDate: "2025-04-05",
      fromTime: "10:30:00",
      toTime: "12:00:00",
      user: "sophia.green@gmail.com",
      doctype: "Leads",
      servicesOpted: [
        ServiceOptedres(
          name: "service5",
          owner: "Administrator",
          creation: "2025-04-01 08:30:40.123789",
          modified: "2025-04-01 08:30:40.123789",
          modifiedBy: "Administrator",
          docstatus: 0,
          idx: 1,
          serviceName: "Full Body Massage",
          price: 7000.0,
          duration: 0,
          serviceType: "Beauty",
          parent: "lead5",
          parentfield: "services_opted",
          parenttype: "Leads",
          doctype: "Service",
          unsaved: 1,
        ),
      ],
    ),
  ),
];

class LeadsApiService {
  final String baseUrl = "http://1glam.local:8000/api/resource/Leads";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "token 4a7f1b702703792:87ee3c3ae508175"
  };

  //Create a new lead (POST)
  Future<LeadsResponse?> createLead(LeadsRequest request) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeadsResponse.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // Fetch all lead IDs (GET)
  Future<List<String>?> fetchLeadIds() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body)['data'];
        return body.map((data) => data['name'].toString()).toList();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  //fetch details of a single lead by nameID (GET)
  Future<LeadsResponse?> fetchLeadDetails(String nameID) async {
    final url = Uri.parse("$baseUrl/$nameID");

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body)['data'];
        return LeadsResponse.fromJson(body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // 🟢 Fetch all lead details dynamically
  Future<List<LeadsResponse>> fetchAllLeads() async {
    List<String>? leadIds = await fetchLeadIds();
    if (leadIds == null) return [];

    List<LeadsResponse> leads = [];
    for (String id in leadIds) {
      LeadsResponse? lead = await fetchLeadDetails(id);
      if (lead != null) {
        leads.add(lead);
      }
    }
    return leads;
  }
}
