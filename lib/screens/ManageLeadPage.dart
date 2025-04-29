import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/leadsRes_model.dart';
import 'package:glam1/widgets/CustomerHeader2.dart';
import 'package:glam1/widgets/LeadsPageFilterBar.dart';
import 'package:glam1/widgets/ManageLeadNameButton.dart';
import 'package:glam1/widgets/ManageLeadsBookingDetailsButton.dart';
import 'package:glam1/widgets/ManageLeadsBottomNavBar.dart';
import 'package:glam1/widgets/ManageLeadsNotesButton.dart';
import 'package:glam1/widgets/ManageLeadsPaymentButton.dart';
import 'package:glam1/widgets/ManageLeadsServicesButton.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageLeadPage extends StatefulWidget {
  final LeadsData lead;
  const ManageLeadPage({super.key, required this.lead});

  @override
  State<ManageLeadPage> createState() => _ManageLeadPageState();
}

class _ManageLeadPageState extends State<ManageLeadPage>
    with SingleTickerProviderStateMixin {
  final List<String> manageLeadsPageFilters = [
    "Overview",
    "Services",
    "Notes",
    "Payments"
  ];

  String _selectedFilter = 'Overview';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Simulate data loading
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFilterSelected(String filter) {
    if (filter != _selectedFilter) {
      setState(() {
        _isLoading = true;
        _animationController.reset();
        _selectedFilter = filter;

        // Simulate loading for filter change
        Future.delayed(Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _animationController.forward();
          }
        });
      });
    }
  }

  // Get status colors based on lead status (matches the LeadDetailsButton)
  Map<String, Color> getStatusColors(String status) {
    switch (status) {
      case "Inbound":
        return {
          'bg': Color(0xFFE0F2FE), // Light blue bg
          'text': Color(0xFF0284C7), // Blue text
        };
      case "Qualifying":
        return {
          'bg': Color(0xFFFDE68A), // Amber bg
          'text': Color(0xFFB45309), // Amber text
        };
      case "Proposal Sent":
        return {
          'bg': Color(0xFFDCFCE7), // Light green bg
          'text': Color(0xFF15803D), // Green text
        };
      case "Proposal Accepted":
        return {
          'bg': AppColors.proposalButtonColor, // Green bg
          'text': AppColors.proposalAcceptedTextColor, // Green text
        };
      case "Deposit Requested":
        return {
          'bg': Color(0xFFFBEDD8), // Orange bg
          'text': Color(0xFFEA580C), // Orange text
        };
      case "Deposit Received":
        return {
          'bg': Color(0xFFD8B4FE), // Purple bg
          'text': Color(0xFF7E22CE), // Purple text
        };
      case "Confirmed":
        return {
          'bg': AppColors.inquiryButtonColor, // Yellow bg
          'text': AppColors.inquiryTextColor, // Yellow text
        };
      case "Closed / Lost":
        return {
          'bg': Color(0xFFFECACA), // Red bg
          'text': Color(0xFFDC2626), // Red text
        };
      case "Waitlisted":
        return {
          'bg': Color(0xFFE5E7EB), // Gray bg
          'text': Color(0xFF4B5563), // Gray text
        };
      default:
        return {
          'bg': AppColors.hintText.withOpacity(0.2), // Gray bg
          'text': AppColors.hintText, // Gray text
        };
    }
  }

  // Format date to a readable format
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("d MMM yyyy")
          .format(date)
          .toUpperCase(); // "1 APR 2025"
    } catch (e) {
      return dateString; // Return as-is if parsing fails
    }
  }

  // Format time to 12-hour format
  String formatTime(String timeString) {
    try {
      DateTime dateTime =
          DateTime.parse("1970-01-01 $timeString"); // Add a dummy date
      return DateFormat.jm()
          .format(dateTime); // Converts to 12-hour AM/PM format
    } catch (e) {
      return timeString; // Fallback in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            CustomHeader2(
              textValue: "Manage Leads",
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.only(left: 9.0),
              child: LeadsPageFilterBar(
                onFilterSelected: _onFilterSelected,
                filters: manageLeadsPageFilters,
                selectedFilter: _selectedFilter,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Client name and status are always visible
            ManageLeadNameButton(
              clientName: widget.lead.clientName,
              currentStatus: widget.lead.leadStatus,
              clientMobileNo: widget.lead.phoneNumber,
            ),

            // Show loading indicator or content
            _isLoading
                ? _buildLoadingIndicator()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildFilterContent(),
                  ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),
      bottomNavigationBar: ManageLeadsBottomNavBar(
        onBack: () {
          Get.back();
        },
        onSendEstimate: () {},
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    switch (_selectedFilter) {
      case 'Overview':
        return Column(
          children: [
            ManageLeadsBookingDetailsButton(
              bookingDate: formatDate(widget.lead.bookingDate),
              startTime: formatTime(widget.lead.fromTime),
              endTime: formatTime(widget.lead.toTime),
            ),
            ManageLeadsServicesButton(services: widget.lead.servicesOpted),
            ManageLeadsNotes(),
            ManageLeadsPaymentButton(),
          ],
        );

      case 'Services':
        return ManageLeadsServicesButton(services: widget.lead.servicesOpted);

      case 'Notes':
        return ManageLeadsNotes();

      case 'Payments':
        return ManageLeadsPaymentButton();

      default:
        return SizedBox(); // Empty widget as fallback
    }
  }
}
