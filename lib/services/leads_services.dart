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
  // Placeholder for future API implementation

  // Create a new lead (POST)
  Future<LeadsResponse?> createLead(LeadsRequest request) async {
    // Placeholder - API implementation to be added
    // Return sample response for now
    return sampleLeads.first;
  }

  // Get all leads (GET)
  Future<List<LeadsResponse>> getLeads() async {
    // Placeholder - API implementation to be added
    // Return sample leads for now
    return sampleLeads;
  }

  // Get a specific lead by ID (GET)
  Future<LeadsResponse?> getLeadById(String leadId) async {
    // Placeholder - API implementation to be added
    // Return a sample lead for now
    return sampleLeads.firstWhere(
      (lead) => lead.data.name == leadId,
      orElse: () => sampleLeads.first,
    );
  }

  // Update a lead (PUT)
  Future<LeadsResponse?> updateLead(String leadId, LeadsRequest request) async {
    // Placeholder - API implementation to be added
    // Return a sample lead for now
    return sampleLeads.first;
  }

  // Delete a lead (DELETE)
  Future<bool> deleteLead(String leadId) async {
    // Placeholder - API implementation to be added
    return true;
  }
}
