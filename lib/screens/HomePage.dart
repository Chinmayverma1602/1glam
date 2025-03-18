import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Import your own files
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomButton3.dart';
import 'package:glam1/widgets/CustomHomeServicesButton.dart';
import 'package:glam1/widgets/CustomScheduleButton.dart';
import 'package:glam1/widgets/CustomStatsButton.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
    // You can also adapt your Theme for consistent text styles, etc.
    return Scaffold(
      backgroundColor: Colors.white,
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
                        CustomTitle(
                          title: "Welcome, Parinaaz!",
                        ),
                        const SizedBox(height: 2),
                        CustomSubTitle(
                          subtitle: "Tuesday, 15 Feb 2025",
                          color: Color.fromRGBO(107, 114, 128, 1) //** AppColors.subtitle,
                        ),
                      ],
                    ),

                    // profile icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.deepPurpleAccent,
                    )
                  ],
                ),

                const SizedBox(height: 24),
        
                // Section: Social Channels or Quick Actions
                Text(
                  "Social Channels",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                // If you have many "buttons," you can put them in a row or column.
                // You can also wrap them in a Card for an elevated look if you wish.
                Column(
                  children: [
                    CustomButton3(
                      text: "Automate your Instagram DM's",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.instagram,
                      //trailingImage: 'assets/images/c.svg',
                      gradientColors: [Color.fromRGBO(236, 72, 153, 1), Color.fromRGBO(217, 70, 239, 1)],
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                      onTap: () async{
                        launchUrl(Uri.https("instagram.com"));
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton3(
                      text: "Automate your Whatsapp DM's",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.whatsapp,
                      gradientColors: [Color.fromRGBO(16, 185, 129, 1), Color.fromRGBO(16, 185, 129, 1)],
                      //trailingImage: 'assets/images/c.svg',
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    CustomButton3(
                      text: "Complete Your Profile",
                      borderColor: Colors.transparent,
                      iconColor: Colors.white,
                      leadingIcon: FontAwesomeIcons.userPen,
                      gradientColors: [Color.fromRGBO(139, 92, 246, 1), Color.fromRGBO(139, 92, 246, 1)],
                      //trailingImage: 'assets/images/c.svg',
                      textColor: Colors.white,
                      textSize: 16,
                      isBold: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
        
                // Section: Today's Schedule
                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Schedule",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to full schedule page
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
                        CustomScheduleButton(
                          time: "10:00",
                          timeBlock: "AM",
                          userName: "Priya Shah",
                          makeupType: "Bridal Makeup",
                        ),
                        const SizedBox(height: 16),
                        CustomScheduleButton(
                          time: "02:30",
                          timeBlock: "PM",
                          userName: "Meera Kapoor",
                          makeupType: "Party Makeup",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
        
                // Section: Add New Booking or other Home Services
                Text(
                  "Services",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomHomeServicesButton(
                        label: "Add New Booking",
                        iconPath: 'assets/images/i3.svg',
                      ),
                      const SizedBox(width: 16),
                      CustomHomeServicesButton(
                        label: "Add New Booking",
                        iconPath: 'assets/images/i-2.svg',
                      ),
                      const SizedBox(width: 16),
                      CustomHomeServicesButton(
                        label: "Add New Booking",
                        iconPath: 'assets/images/i-1.svg',
                      ),
                    ],
                  ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomStatsButton(
                        label: "Inquiry Received",
                        stats: "12",
                        textColor: AppColors.primary,
                        labelColor: Colors.grey,
                      ),
                      const SizedBox(width: 16),
                      CustomStatsButton(
                        label: "Proposal Sent",
                        stats: "8",
                        textColor: AppColors.primary,
                        labelColor: Colors.grey,
                      ),
                      const SizedBox(width: 16),
                      CustomStatsButton(
                        label: "Booked",
                        stats: "5",
                        textColor: AppColors.primary,
                        labelColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
