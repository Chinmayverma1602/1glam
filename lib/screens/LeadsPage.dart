import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/services/leads_services.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomHeaderLeadsPage.dart';
import 'package:glam1/widgets/LeadDetailsButton.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  String _selectedFilter = 'All Leads';
  final ScrollController _scrollController = ScrollController();
  final List<String> leadsPageFilters = [
    "All Leads",
    "Inbound",
    "Qualifying",
    "Proposal Sent",
    "Proposal Accepted",
    "Deposit Requested",
    "Deposit Received",
    "Confirmed",
    "Closed / Lost",
    "Waitlisted"
  ];

  // Map to store leads grouped by their status
  Map<String, List<LeadsResponse>> _groupedLeads = {};

  @override
  void initState() {
    super.initState();
    _fetchLeads();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeads() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // _leads = await _leadsApiService.fetchAllLeads();//TODO : once the api is live we have to use this
      _leads = sampleLeads; // fornow using sample data
      _groupLeadsByStatus(); // Group leads by status
      _isLoading = false;
    });
  }

  // Group leads by their status
  void _groupLeadsByStatus() {
    _groupedLeads.clear();

    // Initialize all status categories
    for (String status in leadsPageFilters.skip(1)) {
      // Skip "All Leads"
      _groupedLeads[status] = [];
    }

    // Group leads by status
    for (var lead in _leads) {
      String status = lead.data.leadStatus;
      if (_groupedLeads.containsKey(status)) {
        _groupedLeads[status]!.add(lead);
      }
    }
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
        Navigator.pushReplacementNamed(context, '/calender');
        break;
      case 3:
        // Payments tab - add appropriate navigation when available
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    // No need for additional filtering logic as grouping is now handled automatically
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, d MMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          CustomHeaderLeadsPage(),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              _getCurrentDate(),
              style: GoogleFonts.poppins(
                color: AppColors.hintText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: LeadsPageFilterBar(
              onFilterSelected: _onFilterSelected,
              filters: leadsPageFilters,
              selectedFilter: _selectedFilter,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CustomLoadingAnimation(
                      text: "Loading leads...",
                    ),
                  )
                : _leads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.content_paste_search_outlined,
                              size: 60,
                              color: AppColors.hintText,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No leads found",
                              style: GoogleFonts.poppins(
                                color: AppColors.hintText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildLeadsList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildLeadsList() {
    // If "All Leads" is selected, show all leads grouped by status
    if (_selectedFilter == "All Leads") {
      // Flatten all leads while preserving grouping
      List<Widget> allLeadWidgets = [];

      for (int index = 0; index < leadsPageFilters.length - 1; index++) {
        String status = leadsPageFilters[index + 1]; // Skip "All Leads"
        List<LeadsResponse> statusLeads = _groupedLeads[status] ?? [];

        // Skip empty status groups
        if (statusLeads.isEmpty) {
          continue;
        }

        // Add all lead widgets directly without the status header
        allLeadWidgets.addAll(
            statusLeads.map((lead) => LeadDetailsButton(lead: lead)).toList());
      }

      return ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8),
        children: allLeadWidgets,
      );
    } else {
      // If a specific filter is selected, show only leads of that status
      List<LeadsResponse> filteredLeads = _groupedLeads[_selectedFilter] ?? [];

      if (filteredLeads.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.content_paste_search_outlined,
                size: 60,
                color: AppColors.hintText,
              ),
              SizedBox(height: 16),
              Text(
                "No leads found for $_selectedFilter",
                style: GoogleFonts.poppins(
                  color: AppColors.hintText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: filteredLeads.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return LeadDetailsButton(lead: filteredLeads[index]);
        },
      );
    }
  }
}
