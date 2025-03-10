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

            // Display services based on active mode (bundle or single)
            Expanded(
              child: Obx(() {
                // Get the appropriate service list
                final serviceList = controller.isBundle.value
                    ? controller.bundleServiceWidgets
                    : controller.singleServiceWidget;

                // If no services, show message
                if (serviceList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No services added yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Display services
                return ListView.builder(
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    final service = serviceList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CustomServiceButton(
                        title: service.title,
                        subtitle: "${service.durationLabel} hours",
                        value: service.priceLabel,
                        leadingIconColor: AppColors.subtitle,
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 20),
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

            // Continue button with API integration
            Obx(() => CustomButton(
                  text: controller.isLoading ? "Saving..." : "Continue",
                  color: AppColors.subtitle,
                  onPressed: controller.isLoading
                      ? null // Disable button while loading
                      : () async {
                          // Get active service list
                          final serviceList = controller.isBundle.value
                              ? controller.bundleServiceWidgets
                              : controller.singleServiceWidget;

                          // Check if there are services to save
                          if (serviceList.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please add at least one service before continuing',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          // Call API to save services
                          final success = await controller.saveServices();

                          if (success) {
                            Get.snackbar(
                              'Success',
                              'Services saved successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            // Navigate to next screen (add your navigation logic here)
                            // Get.to(() => NextScreen());
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to save services',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
