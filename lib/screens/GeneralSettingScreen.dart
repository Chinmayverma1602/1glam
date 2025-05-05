import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/BottomNavBar.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        title: Text(
          'General Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.title,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Social Integration'),
              const SizedBox(height: 12),
              _buildContainer([
                _buildSettingTile(
                  icon: FontAwesomeIcons.instagram,
                  color: AppColors.instagram,
                  title: 'Instagram Account',
                  subtitle: 'Connect your business account',
                  action: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Connect',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: FontAwesomeIcons.whatsapp,
                  color: AppColors.whatsapp,
                  title: 'WhatsApp Business',
                  subtitle: 'Connect your business number',
                  action: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Disconnect',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildPhoneNumberTile(),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('App Settings'),
              const SizedBox(height: 12),
              _buildContainer([
                _buildToggleTile(
                  icon: Icons.message_outlined,
                  color: Colors.blue,
                  title: 'Auto Messaging',
                  subtitle: 'Enable automated responses',
                  value: true,
                  onChanged: (newValue) {},
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  color: Colors.orange,
                  title: 'Notifications',
                  subtitle: 'Manage push notifications',
                  action: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.secondaryText,
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('Security & Privacy'),
              const SizedBox(height: 12),
              _buildContainer([
                _buildToggleTile(
                  icon: Icons.security_outlined,
                  color: Colors.green,
                  title: 'Data Protection',
                  subtitle: 'Enhanced security features',
                  value: false,
                  onChanged: (newValue) {},
                ),
                _buildDivider(),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  color: Colors.indigo,
                  title: 'Privacy Settings',
                  subtitle: 'Manage your data & privacy',
                  action: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.secondaryText,
                  ),
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.title,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: Colors.grey.shade200, height: 1),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) action,
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: (bool newValue) {
                  setState(() => value = newValue);
                  onChanged(newValue);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhoneNumberTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+1 (555) 123-4567',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'WhatsApp business number',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
