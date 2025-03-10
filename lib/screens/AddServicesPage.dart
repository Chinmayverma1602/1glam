import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

class AddServicesPage extends StatelessWidget {
  const AddServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(AddServicesController());

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
              // Mode toggle buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!controller.isBundle.value) {
                        controller.toggleMode(); // Use toggleMode instead
                      }
                    },
                    child: Obx(
                      () => CustomButton2(
                        fillColor: controller.isBundle.value
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.white,
                        text: "Bundle",
                        borderColor: controller.isBundle.value
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.isBundle.value) {
                        controller.toggleMode(); // Use toggleMode instead
                      }
                    },
                    child: Obx(
                      () => CustomButton2(
                        fillColor: !controller.isBundle.value
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.white,
                        text: "Single",
                        borderColor: !controller.isBundle.value
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Obx(
                () => Row(
                  children: [
                    const Text("Total time:",
                        style: TextStyle(color: AppColors.hintText)),
                    const SizedBox(width: 15),
                    Text("${controller.calculateTotalTime()} hours"),
                    const Spacer(),
                    const Text("Total price:",
                        style: TextStyle(color: AppColors.hintText)),
                    const SizedBox(width: 15),
                    Text("${controller.calculateTotalPrice()}"),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Services list
              Obx(
                () => Column(
                  children: List.generate(controller.serviceWidgets.length, (index) {
                    final widget = controller.serviceWidgets[index];
                    return GestureDetector(
                      onTap: controller.toggleMode,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: widget,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                icon: Icons.add,
                text: "Add Another Service",
                color: Colors.transparent,
                onPressed: controller.addService,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                border: true,
                borderThickness: 0.4,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Save Service",
                color: AppColors.primary,
                onPressed: () {
                  Get.to(() => const ServicesInfoPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}