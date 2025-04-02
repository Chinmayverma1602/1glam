import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}
int _selectedIndex = 4;
class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {

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
      appBar: AppBar(
        title: Text(
          'General Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.red)
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  _buildSettingTile(
                      icon: Icons.camera_alt, // Instagram icon placeholder
                      color: Colors.pink,
                      title: 'Instagram Account',
                      subtitle: 'Connect your business account',
                      action: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Color(0xFFBE27E4), // Exact purple color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Connect',
                          style: TextStyle(
                            color: Colors.white, // White text
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                  _buildSettingTile(
                      icon: Icons
                          .chat, //TODO: later change it with the actual icon of whatsapp
                      color: Colors.green,
                      title: 'WhatsApp Business',
                      subtitle: 'Connect your business number',
                      action: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Removes extra padding
                            minimumSize: Size(0, 36), // Controls height
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // Prevents extra touch padding
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6), // Manual padding control
                            child: Text(
                              'Disconnect',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 244, 245, 245), // Light gray background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone,
                                color: Color(0xff6B7280)), // Dark gray icon
                            SizedBox(width: 10),
                            Text(
                              '+1 (555) 123-4567',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF595959)),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Change',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            _buildToggleTile(
                icon: Icons.message,
                color: Colors.blue,
                title: 'Auto Messaging',
                subtitle: 'Enable automated responses',
                value: true,
                onChanged: (newValue) {}),
            _buildSettingTile(
              icon: Icons.notifications,
              color: Colors.orange,
              title: 'Notifications',
              subtitle: 'Manage push notifications',
              action:
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ],
        ),
      ),



      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontSize: 14,
              color: Color(0xff6B7280),
              fontWeight: FontWeight.w400),
        ),
        trailing: action,
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            tileColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: Switch(
              value: value,
              onChanged: (bool newValue) {
                setState(() => value = newValue);
                onChanged(newValue);
              },
              activeColor: AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
