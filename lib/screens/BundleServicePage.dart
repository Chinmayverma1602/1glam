import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/SIngleServiceScreen.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';

import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

import '../services/add_services_controller.dart';

class BundleServicePage extends StatefulWidget {
  const BundleServicePage({Key? key}) : super(key: key);

  @override
  State<BundleServicePage> createState() => _BundleServicePageState();
}

class _BundleServicePageState extends State<BundleServicePage> {
  List<CustomServiceSelectionContainer> serviceWidgets = [];
  AddServicesController controller = Get.put(AddServicesController());

  void _addService() {
    setState(() {
      serviceWidgets.add(
        CustomServiceSelectionContainer(
          title: controller.titleController.text,
          serviceCategory: 'Luxury',
          buttonBorderColor: AppColors.hintText.withOpacity(0.4),
          borderColor: AppColors.hintText,
          hintText: 'Service description',
          borderRadius: 16,
          durationLabel: '2',
          priceLabel: '40,000',
          artistName: 'New Artist',
          artistSpecialization: 'Specialist',
          serviceType: 'Bundle Service',
          serviceIcon: 'assets/images/f.svg',
          leadingIconColor: AppColors.primary,
          trailingIconColor: AppColors.primary,
          artistImage: 'assets/images/img.svg',
          onDelete: () => _removeService(serviceWidgets.length - 1),
        ),
      );
    });
  }

  void _removeService(int index) {
    setState(() {
      if (index >= 0 && index < serviceWidgets.length) {
        serviceWidgets.removeAt(index);
      }
    });
  }

  void _saveServices() {
    final List<Map<String, dynamic>> servicesData = serviceWidgets
        .map((service) => {
              "title": service.title,
              "category": service.serviceCategory,
              "duration": service.durationLabel,
              "price": service.priceLabel,
              "artist": service.artistName,
              "specialization": service.artistSpecialization,
              "type": service.serviceType,
            })
        .toList();
    // Send this data to the backend
    print("Services Data: $servicesData");

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
              CustomButton(
                icon: Icons.add,
                text: "Add Another Service",
                color: Colors.transparent,
                onPressed: _addService,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                border: true,
                borderThickness: 0.4,
              ),
              if (serviceWidgets.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: "Save Services",
                  color: AppColors.primary,
                  onPressed: _saveServices,
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
