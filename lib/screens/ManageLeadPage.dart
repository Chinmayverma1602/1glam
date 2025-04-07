import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:glam1/widgets/CustomerHeaderManageLeadsPage.dart';
import 'package:glam1/widgets/LeadDetailsButton.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';
import 'package:glam1/widgets/ManageLeadNameButton.dart';
import 'package:glam1/widgets/ManageLeadsBookingDetailsButton.dart';
import 'package:glam1/widgets/ManageLeadsBottomNavBar.dart';
import 'package:glam1/widgets/ManageLeadsNotesButton.dart';
import 'package:glam1/widgets/ManageLeadsPaymentButton.dart';
import 'package:glam1/widgets/ManageLeadsServicesButton.dart';
import 'package:get/get.dart';


class ManageLeadPage extends StatefulWidget {
  final LeadsData lead;
  const ManageLeadPage({super.key, required this.lead});

  @override
  State<ManageLeadPage> createState() => _ManageLeadPageState();
}

class _ManageLeadPageState extends State<ManageLeadPage> {
  final List<String> manageLeadsPageFilters = [
    "Overview",
    "Services",
    "Notes",
    "Payments"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CustomHeaderManageLeadsPage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.only(left: 9.0),
              child: LeadsPageFilterBar(
                onFilterSelected: (String newFilter) {},
                filters: manageLeadsPageFilters,
                selectedFilter: 'Overview',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ManageLeadNameButton(clientName: widget.lead.clientName,currentStatus: widget.lead.leadStatus,clientMobileNo: widget.lead.phoneNumber,),
            ManageLeadsBookingDetailsButton(bookingDate: formatDate(widget.lead.bookingDate) ,startTime: formatTime(widget.lead.fromTime) ,endTime: formatTime(widget.lead.toTime) ,),
            ManageLeadsServicesButton( services:  widget.lead.servicesOpted),
            ManageLeadsNotes(),
            ManageLeadsPaymentButton(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          ],
        ),
      ),
      bottomNavigationBar: ManageLeadsBottomNavBar(onBack: (){Get.back();}, onSendEstimate: (){}),
    );
  }
}
