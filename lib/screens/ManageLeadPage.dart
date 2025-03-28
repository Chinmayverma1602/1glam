import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomerHeaderManageLeadsPage.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';
import 'package:glam1/widgets/ManageLeadNameButton.dart';
import 'package:glam1/widgets/ManageLeadsBookingDetailsButton.dart';
import 'package:glam1/widgets/ManageLeadsBottomNavBar.dart';
import 'package:glam1/widgets/ManageLeadsNotesButton.dart';
import 'package:glam1/widgets/ManageLeadsPaymentButton.dart';
import 'package:glam1/widgets/ManageLeadsServicesButton.dart';

class ManageLeadPage extends StatefulWidget {
  const ManageLeadPage({super.key});

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
            ManageLeadNameButton(),
            ManageLeadsBookingDetailsButton(),
            ManageLeadsServicesButton(),
            ManageLeadsNotes(),
            ManageLeadsPaymentButton(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          ],
        ),
      ),
      bottomNavigationBar: ManageLeadsBottomNavBar(onBack: (){Navigator.pop(context);}, onSendEstimate: (){}),
    );
  }
}
