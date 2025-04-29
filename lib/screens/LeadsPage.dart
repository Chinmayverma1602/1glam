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
    "New",
    "In Progress",
    "Confirmed",
    "Inquiry Recieved",
    "Qualified Lead",
    "Accepted Leads"
  ];

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

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    // TODO: Implement actual filtering logic when API is ready
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, d MMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate exact height for leads list to show 3 items
    final double headerHeight =
        MediaQuery.of(context).size.height * 0.04 + // Top padding
            60 + // Header height (approximated)
            20 + // Date text height (approximated)
            MediaQuery.of(context).size.height * 0.025 + // Spacing
            50 + // Filter bar height (approximated)
            MediaQuery.of(context).size.height * 0.02; // Spacing

    final double navBarHeight = 70; // Approximated bottom nav bar height
    final double leadItemHeight = MediaQuery.of(context).size.height * 0.22 +
        16; // Lead item height + vertical margin

    // Calculate available height for leads list
    final double availableHeight =
        MediaQuery.of(context).size.height - headerHeight - navBarHeight;

    // Calculate padding to ensure exactly 3 items are visible
    final double topPadding = (availableHeight - (leadItemHeight * 3)) / 2;
    final double verticalPadding = topPadding > 0 ? topPadding : 0;

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
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                vertical: verticalPadding,
                                horizontal: 0,
                              ),
                              itemCount: _leads.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return LeadDetailsButton(lead: _leads[index]);
                              },
                            ),
                          ),
                        ],
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
