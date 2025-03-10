import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomServiceButton.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class ServicesInfoPage extends StatelessWidget {
  const ServicesInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AddServicesController instance
    final controller = Get.find<AddServicesController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(),
            const SizedBox(height: 35),
            const CustomTitle(title: "Add your services"),
            const SizedBox(height: 15),
            const CustomSubTitle(
              subtitle: "Group services into Bundles or you can add it later",
              color: Colors.grey,
            ),
            const SizedBox(height: 35),
            // Dynamically display added services
            Obx(
              () => Column(
                children: controller.serviceWidgets.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomServiceButton(
                      title: service.title,
                      subtitle: "${service.durationLabel} hours",
                      value: service.priceLabel,
                      leadingIconColor: AppColors.subtitle,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 35),
            CustomButton(
              text: "Add Service",
              color: Colors.transparent,
              onPressed: () {
                Get.to(() => const AddServicesPage());
              },
              textColor: AppColors.primary,
              icon: Icons.add,
              iconColor: AppColors.primary,
              borderThickness: 0.4,
              borderColor: AppColors.primary,
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: "Continue",
              color: AppColors.subtitle,
              onPressed: () {
                // Add your next navigation logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}