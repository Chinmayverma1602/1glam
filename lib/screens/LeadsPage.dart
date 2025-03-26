import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomHeaderLeadsPage.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/LeadDetailsButton.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  int _selectedIndex = 1; 
  final List<String> leadsPageFilters = [
    "All Leads", "New", "In Progress", "Confirmed",
    "Inquiry Recieved", "Qualified Lead", "Accepted Leads"
  ]; 

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/leads');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            CustomHeaderLeadsPage(),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: CustomSubTitle(
                  subtitle: "Tuesday, 15 Feb 2025", color: AppColors.hintText),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: LeadsPageFilterBar(onFilterSelected: (String newFilter){}, filters: leadsPageFilters, selectedFilter: 'All Leads',),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            LeadDetailsButton(),
            LeadDetailsButton(),
            LeadDetailsButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
