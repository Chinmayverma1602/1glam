import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/BundleServicePage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

class SingleServicePage extends StatefulWidget {
  const SingleServicePage({Key? key}) : super(key: key);

  @override
  State<SingleServicePage> createState() => _SingleServicePageState();
}

class _SingleServicePageState extends State<SingleServicePage> {
  CustomServiceSelectionContainer? serviceWidget;

  void _addService() {
    setState(() {
      serviceWidget = CustomServiceSelectionContainer(
        title: 'New Service',
        serviceCategory: 'Luxury',
        buttonBorderColor: AppColors.hintText.withOpacity(0.4),
        borderColor: AppColors.hintText,
        hintText: 'Service description',
        borderRadius: 16,
        durationLabel: '2',
        priceLabel: '40,000',
        artistName: 'New Artist',
        artistSpecialization: 'Specialist',
        serviceType: 'Mobile Service',
        serviceIcon: 'assets/images/f.svg',
        leadingIconColor: AppColors.primary,
        trailingIconColor: AppColors.primary,
        artistImage: 'assets/images/img.svg',
        onDelete: _removeService,
      );
    });
  }

  void _removeService() {
    setState(() {
      serviceWidget = null;
    });
  }

  void _saveService() {
    if (serviceWidget != null) {
      final serviceData = {
        "title": serviceWidget!.title,
        "category": serviceWidget!.serviceCategory,
        "duration": serviceWidget!.durationLabel,
        "price": serviceWidget!.priceLabel,
        "artist": serviceWidget!.artistName,
        "specialization": serviceWidget!.artistSpecialization,
        "type": serviceWidget!.serviceType,
      };
      // Send this data to the backend
      print("Service Data: $serviceData");
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServicesInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text("Add Service"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              if (serviceWidget == null)
                CustomButton(
                  icon: Icons.add,
                  text: "Add Service",
                  color: Colors.transparent,
                  onPressed: _addService,
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  border: true,
                  borderThickness: 0.4,
                ),
              if (serviceWidget != null)
                Column(
                  children: [
                    serviceWidget!,
                    CustomButton(
                      text: "Save Service",
                      color: AppColors.primary,
                      onPressed: _saveService,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
