import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/services/leads_services.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomHeaderLeadsPage.dart';
import 'package:glam1/widgets/LeadDetailsButton.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  int _selectedIndex = 1;
  final LeadsApiService _leadsApiService = LeadsApiService();
  List<LeadsResponse> _leads = [];
  bool _isLoading = true;
  // int _selectedIndex = 1; 
  final List<String> leadsPageFilters = [
    "All Leads", "New", "In Progress", "Confirmed",
    "Inquiry Recieved", "Qualified Lead", "Accepted Leads"
  ]; 

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  Future<void> _fetchLeads() async {
    await Future.delayed(Duration(seconds: 1)); 
    setState(()  {
      // _leads = await _leadsApiService.fetchAllLeads();//TODO : once the api is live we have to use this 
      _leads = sampleLeads; // fornow using sample data
      _isLoading = false;
    });
  }

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
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          CustomHeaderLeadsPage(),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Tuesday, 15 Feb 2025",
              style: TextStyle(color: AppColors.hintText, fontSize: 16),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: LeadsPageFilterBar(onFilterSelected: (String newFilter){}, filters: leadsPageFilters, selectedFilter: 'All Leads',),
            ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Flexible(
            
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Loader while fetching leads
                : ListView.builder(
                  padding: EdgeInsets.only(top: 2),
                    itemCount: _leads.length,
                    itemBuilder: (context, index) {
                      return LeadDetailsButton( lead: _leads[index],);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
