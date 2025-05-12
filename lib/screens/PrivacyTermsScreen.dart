import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glam1/constants/AppColors.dart';

class PrivacyTermsScreen extends StatefulWidget {
  const PrivacyTermsScreen({super.key});

  @override
  State<PrivacyTermsScreen> createState() => _PrivacyTermsScreenState();
}

class _PrivacyTermsScreenState extends State<PrivacyTermsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Privacy & Terms',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.secondaryText,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Terms of Service',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrivacyPolicy(),
          _buildTermsOfService(),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Information We Collect',
            [
              'Personal information (name, email, phone number)',
              'Payment information',
              'Location data',
              'Device information',
              'Usage data and preferences',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'How We Use Your Information',
            [
              'To provide and maintain our services',
              'To process your transactions',
              'To send you updates and notifications',
              'To improve our services',
              'To communicate with you about your account',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Information Sharing',
            [
              'We do not sell your personal information',
              'We share information with service providers',
              'We may share information for legal requirements',
              'We share information with your consent',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Your Rights',
            [
              'Access your personal information',
              'Correct inaccurate data',
              'Request deletion of your data',
              'Opt-out of marketing communications',
              'Data portability',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Data Security',
            [
              'We implement security measures to protect your data',
              'Regular security assessments',
              'Encryption of sensitive information',
              'Secure data storage and transmission',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Contact Us',
            [
              'For privacy-related inquiries, contact us at:',
              'Email: privacy@1glam.com',
              'Phone: +1 (800) 123-4567',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Acceptance of Terms',
            [
              'By accessing or using 1Glam, you agree to these terms',
              'You must be at least 18 years old to use our services',
              'You must provide accurate and complete information',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'User Accounts',
            [
              'You are responsible for maintaining account security',
              'You must notify us of any unauthorized access',
              'We reserve the right to suspend or terminate accounts',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Service Usage',
            [
              'Use our services in compliance with laws',
              'Do not engage in fraudulent activities',
              'Respect other users and professionals',
              'Maintain appropriate conduct',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Payment Terms',
            [
              'All fees are non-refundable unless specified',
              'We may change our fees with notice',
              'You are responsible for all charges',
              'Payment disputes must be reported within 30 days',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Cancellation Policy',
            [
              '24-hour cancellation notice required',
              'Late cancellations may be charged',
              'No-shows may result in account restrictions',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Intellectual Property',
            [
              'All content is owned by 1Glam',
              'You may not copy or distribute our content',
              'User content remains your property',
              'You grant us license to use your content',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Limitation of Liability',
            [
              'We are not liable for indirect damages',
              'Our liability is limited to fees paid',
              'Some jurisdictions do not allow limitations',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Changes to Terms',
            [
              'We may modify these terms at any time',
              'Changes will be effective upon posting',
              'Continued use means acceptance of changes',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.title,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
