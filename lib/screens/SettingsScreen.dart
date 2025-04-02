// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/GeneralSettingScreen.dart';
import 'package:glam1/screens/PaymentSettingsScreen.dart';
import 'package:glam1/widgets/BottomNavBar.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

int _selectedIndex = 4;

class _SettingsScreenState extends State<SettingsScreen> {
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
        // Navigator.pushReplacementNamed(context, '/calendar');
        // Navigator.pushReplacementNamed(context, '/ShowInvoice');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/SettingsScreen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFB),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  // backgroundImage: AssetImage('assets/user_avatar.png'),
                  backgroundColor: Colors.cyan,
                  radius: 32,
                ),
                title: Text(
                  'John Anderson',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'john@company.com',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color:Color(0xff6B7280)),
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppColors.primary),
                onTap: () {},
              ),
            ),
            SizedBox(height: 20),
            _buildSettingsTile(
                Icons.settings, 'General Settings', Colors.blue, () =>Get.to(()=> GeneralSettingsScreen())),
            _buildSettingsTile(
                Icons.payment, 'Payment Settings', AppColors.primary,  () =>Get.to(()=> PaymentSettingsScreen())),
            _buildSettingsTile(
                Icons.group, 'Team Management', Colors.green, () {},
                subtitle: '5 members'),
            _buildSettingsTile(
                Icons.person, 'Profile Settings', Colors.orange, () {}),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSettingsTile(
      IconData icon, String title, Color color, VoidCallback onTap,
      {String? subtitle}) {
    return Container(
      height: 72,
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color , ),
          radius: 20,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]))
            : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
