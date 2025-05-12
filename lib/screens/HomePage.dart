import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/services/leads_services.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomButton3.dart';
import 'package:glam1/widgets/CustomHomeServicesButton.dart';
import 'package:glam1/widgets/CustomScheduleButton.dart';
import 'package:glam1/widgets/CustomStatsButton.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:glam1/screens/NewBookingPage.dart';

class HomePage extends StatefulWidget {
  final dynamic lead;

  const HomePage({Key? key, required this.lead}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = "User"; // Default user name

  // Lead statistics counts
  int _totalInbound = 0;
  int _totalQualifying = 0;
  int _totalProposalSent = 0;
  int _totalProposalAccepted = 0;
  int _totalDepositRequested = 0;
  int _totalDepositReceived = 0;
  int _totalConfirmed = 0;
  int _totalClosedLost = 0;
  int _totalWaitlisted = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _countLeadsByStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload username every time the page is displayed
    _loadUserName();
    _countLeadsByStatus();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget is updated
    _loadUserName();
    _countLeadsByStatus();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get user name from various sources
    String? name = prefs.getString('user_name');

    if (name == null || name.isEmpty) {
      // Try to get first name if full name not available
      name = prefs.getString('first_name');
    }

    if (name == null || name.isEmpty) {
      // Try to extract name from email as last resort
      String? email = prefs.getString('user_email');
      if (email != null && email.contains('@')) {
        name = email.split('@')[0];
        // Capitalize first letter
        if (name.isNotEmpty) {
          name = name[0].toUpperCase() + name.substring(1);
        }
      }
    }

    if (name != null && name.isNotEmpty) {
      setState(() {
        _userName = name!;
      });
    }
  }

  void _countLeadsByStatus() {
    // Reset all counters
    _totalInbound = 0;
    _totalQualifying = 0;
    _totalProposalSent = 0;
    _totalProposalAccepted = 0;
    _totalDepositRequested = 0;
    _totalDepositReceived = 0;
    _totalConfirmed = 0;
    _totalClosedLost = 0;
    _totalWaitlisted = 0;

    // Count leads by status
    for (var lead in sampleLeads) {
      final status = lead.data.leadStatus;

      switch (status) {
        case 'Inbound':
          _totalInbound++;
          break;
        case 'Qualifying':
          _totalQualifying++;
          break;
        case 'Proposal Sent':
          _totalProposalSent++;
          break;
        case 'Proposal Accepted':
          _totalProposalAccepted++;
          break;
        case 'Deposit Requested':
          _totalDepositRequested++;
          break;
        case 'Deposit Received':
          _totalDepositReceived++;
          break;
        case 'Confirmed':
          _totalConfirmed++;
          break;
        case 'Closed / Lost':
          _totalClosedLost++;
          break;
        case 'Waitlisted':
          _totalWaitlisted++;
          break;
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
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }

  // This method will always get a fresh copy of the user name from SharedPreferences
  Future<String> _getUserNameFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get user name from various possible keys
    String? name = prefs.getString('user_name') ??
        prefs.getString('userName') ??
        prefs.getString('name') ??
        prefs.getString('displayName') ??
        prefs.getString('first_name');

    if (name == null || name.isEmpty) {
      // Try to extract name from email as last resort
      String? email = prefs.getString('user_email');
      if (email != null && email.contains('@')) {
        name = email.split('@')[0];
        // Capitalize first letter
        if (name.isNotEmpty) {
          name = name[0].toUpperCase() + name.substring(1);
        }
      }
    }

    // If we found a name, update the state
    if (name != null && name.isNotEmpty && name != _userName) {
      setState(() {
        _userName = name!;
      });
    }

    return name ?? "User";
  }

  @override
  Widget build(BuildContext context) {
    _loadUserName(); // Attempt to reload the username on each build

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _getUserNameFromSharedPrefs(),
                          builder: (context, snapshot) {
                            // Use the snapshot data if available, otherwise fallback to current state
                            final displayName = snapshot.data ?? _userName;
                            return CustomTitle(
                              title: "Welcome $displayName!",
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        CustomSubTitle(
                          subtitle: DateFormat('EEEE, MMMM d, yyyy')
                              .format(DateTime.now()),
                          color: Color.fromRGBO(107, 114, 128, 1),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Section: Social Channels - Updated with buttons like in the image
                Column(
                  children: [
                    CustomButton3(
                      text: "Automate Instagram DMs",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.instagram,
                      trailingIcon: Icons.arrow_forward_ios,
                      iconSize: 20,
                      gradientColors: [
                        Color.fromRGBO(236, 72, 153, 1),
                        Color.fromRGBO(217, 70, 239, 1)
                      ],
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                      onTap: () async {
                        launchUrl(Uri.https("instagram.com"));
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton3(
                      text: "Automate WhatsApp DMs",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.whatsapp,
                      trailingIcon: Icons.arrow_forward_ios,
                      iconSize: 20,
                      gradientColors: [
                        Color.fromRGBO(16, 185, 129, 1),
                        Color.fromRGBO(16, 185, 129, 1)
                      ],
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                      onTap: () async {
                        // Try to open WhatsApp app
                        final whatsappUri =
                            Uri.parse("whatsapp://send?text=Hello");
                        if (await canLaunchUrl(whatsappUri)) {
                          await launchUrl(whatsappUri);
                        } else {
                          // If WhatsApp app is not installed, open WhatsApp Web
                          final webWhatsappUri =
                              Uri.parse("https://web.whatsapp.com/");
                          await launchUrl(
                            webWhatsappUri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton3(
                      text: "Complete Your Profile",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.userPen,
                      trailingIcon: Icons.arrow_forward_ios,
                      iconSize: 20,
                      gradientColors: [
                        Color.fromRGBO(139, 92, 246, 1),
                        Color.fromRGBO(139, 92, 246, 1)
                      ],
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section: Today's Schedule
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Schedule",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to full schedule page
                          },
                          child: Text(
                            "View all",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CustomScheduleButton(
                            time: "10:00",
                            timeBlock: "AM",
                            userName: "Priya Shah",
                            makeupType: "Bridal Makeup",
                          ),
                          Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade200),
                          CustomScheduleButton(
                            time: "2:30",
                            timeBlock: "PM",
                            userName: "Meera Kapoor",
                            makeupType: "Party Makeup",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section: Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomHomeServicesButton(
                        label: "Add New\nBooking",
                        icon: Icons.calendar_month_outlined,
                        iconColor: AppColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewBookingScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomHomeServicesButton(
                        label: "Send Follow\nUp",
                        icon: Icons.send_outlined,
                        iconColor: AppColors.primary,
                        onTap: () {
                          // TODO: Implement Send Follow Up functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Send Follow Up feature coming soon')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomHomeServicesButton(
                        label: "Send Invoice",
                        icon: Icons.receipt_long_outlined,
                        iconColor: AppColors.primary,
                        onTap: () {
                          // Navigate to invoice creation page
                          Navigator.pushNamed(context, '/newInvoicePgae');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Section: Lead Stages
                Text(
                  "Lead Stages",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),

                // Updated Lead Stages section to match the lead screen
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalInbound",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Inbound",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalQualifying",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Qualifying",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalConfirmed",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.inquiryTextColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Confirmed",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Second row of lead stages
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalProposalSent",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Proposal Sent",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalDepositRequested",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deposit\nRequested",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_totalDepositReceived",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E22CE),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deposit\nReceived",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
