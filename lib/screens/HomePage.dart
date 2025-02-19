import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHomeServicesButton.dart';
import 'package:glam1/widgets/CustomScheduleButton.dart';
import 'package:glam1/widgets/CustomStatsButton.dart';

import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // It’s better to make _selectedIndex mutable so that you can update it when tapping
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
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: "Welcome Parinaaz!"),
              const SizedBox(height: 8),
              CustomSubTitle(
                subtitle: "Tuesday, 15 Feb 2025",
                color: AppColors.title,
              ),
              const SizedBox(height: 16),
              CustomButton2(
                text: "Instagram",
                borderColor: Colors.transparent,
                fillColor: AppColors.instagram,
              ),
              const SizedBox(height: 8),
              CustomButton2(
                text: "Whatsapp",
                borderColor: Colors.transparent,
                fillColor: AppColors.whatsapp,
              ),
              const SizedBox(height: 8),
              CustomButton2(
                text: "Complete Your Profile",
                borderColor: Colors.transparent,
                fillColor: AppColors.profile,
              ),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Today's Schedule",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                   SizedBox(height: 16),
                    
                    CustomScheduleButton(time: "10:00", timeBlock: "AM",userName: "Priya Shah",makeupType: "Bridal Makeup",),
                    SizedBox(height: 16),
                    CustomScheduleButton(time: "02:30", timeBlock: "PM",userName: "Meera Kapoor",makeupType: "Party Makeup",),
                  ],
                ),
              ),
              Row(
                children: [
                  CustomHomeServicesButton(icon: Icons.calendar_month,label: "Add New Booking",),
                  CustomHomeServicesButton(icon: Icons.calendar_month,label: "Add New Booking",),
                  CustomHomeServicesButton(icon: Icons.calendar_month,label: "Add New Booking",),
                ],
              ),
             Text(
                  "Lead Stages",
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomStatsButton(label: "Inquiry Received", stats: "12"),
                    CustomStatsButton(label: "Inquiry Received", stats: "12"),
                    CustomStatsButton(label: "Inquiry Received", stats: "12"),
                  ],
                ),
              )
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

 
}
