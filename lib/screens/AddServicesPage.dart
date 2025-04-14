// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:glam1/screens/ServicesInfoPage.dart';
// import 'package:glam1/services/add_services_controller.dart';
// import 'package:glam1/widgets/CustomButton.dart';
// import 'package:glam1/widgets/CustomButton2.dart';
// import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AddServicesPage extends StatelessWidget {
//   const AddServicesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Get the controller

//     final controller = Get.find<AddServicesController>();

//     print("controller..isBundle.value in Obx: ${controller.isBundle.value}");
//       void _saveServices() {
//   List<Map<String, dynamic>> servicesToSave = [];

//   if (controller.isBundle.value) {
//     for (final item in controller.bundleServiceWidgets) { // Use controller.bundleServices
//       servicesToSave.add({
//         'title': item.titleController.text,
//         'description': item.descriptionController.text,
//         'price': item.priceController.text,
//         'duration': item.durationController.text,
//         // ... other data from the ServiceItem ...
//       });
//     }
//   } else if (controller.singleServiceWidget.isNotEmpty) { // Use controller.singleService
//     final item = controller.singleServiceWidget.first;
//     servicesToSave.add({
//       'title': item.titleController.text,
//       'description': item.descriptionController.text,
//       'price': item.priceController.text,
//       'duration': item.durationController.text,
//       // ... other data from the ServiceItem ...
//     });
//   }

//   // Implement your save logic
//   print('Saving services: $servicesToSave');
//   // ...

//   // Dispose controllers after saving
//   controller.disposeControllers();
// }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         shadowColor: Colors.white,
//         title: Text(
//           "Add Service",
//           textAlign: TextAlign.start,
//           style: GoogleFonts.inter(
//               fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Mode toggle buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if (!controller.isBundle.value) {
//                         controller.toggleMode();
//                       }
//                       print(
//                           "controller.isBundle.value in Obx: ${controller.isBundle.value}");
//                     },
//                     child: Obx(
//                       () => CustomButton2(
//                           isBold: true,
//                           fillColor: controller.isBundle.value
//                               ? AppColors.primary
//                               : Colors.white,
//                           text: "Bundle",
//                           textColor: controller.isBundle.value
//                               ? AppColors.light
//                               : AppColors.dark,
//                           borderColor: controller.isBundle.value
//                               ? AppColors.primary
//                               : Colors.black),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (controller.isBundle.value) {
//                         controller.toggleMode();
//                       }
//                       print(
//                           "controller.isBundle.value in Obx: ${controller.isBundle.value}");
//                     },
//                     child: Obx(
//                       () => CustomButton2(
//                         isBold: true,
//                         fillColor: !controller.isBundle.value
//                             ? AppColors.primary
//                             : Colors.white,
//                         text: "Single",
//                         textColor: !controller.isBundle.value
//                             ? AppColors.light
//                             : AppColors.dark,
//                         borderColor: !controller.isBundle.value
//                             ? AppColors.primary
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Obx(
//                 () => Row(
//                   children: [
//                     const Text("Total time:",
//                         style: TextStyle(color: AppColors.hintText)),
//                     const SizedBox(width: 15),
//                     Text("${controller.calculateTotalTime()} hours"),
//                     const Spacer(),
//                     const Text("Total price:",
//                         style: TextStyle(color: AppColors.hintText)),
//                     const SizedBox(width: 15),
//                     Text("${controller.calculateTotalPrice()}"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               // Services list - shows either bundle or single services
//               Obx(
//                 () => Column(
//                   children:
//                       List.generate(controller.serviceWidgets.length, (index) {
//                     final serviceItem =
//                         controller.serviceWidgets[index]; // Get the ServiceItem
//                     return Container(
//                       key:
//                           ValueKey(serviceItem.id), // 🔥 THIS LINE IS IMPORTANT
//                       margin: const EdgeInsets.only(bottom: 8),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.transparent,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: CustomServiceSelectionContainer(
//                         // Now pass the data and controllers from the ServiceItem
//                         title: serviceItem.titleController.text,
//                         serviceCategory: serviceItem.serviceCategory.value,
//                         buttonBorderColor: serviceItem.buttonBorderColor.value,
//                         borderColor: serviceItem.borderColor.value,
//                         hintText: serviceItem.hintText.value,
//                         borderRadius: serviceItem.borderRadius.value,
//                         durationLabel: serviceItem.durationController.text,
//                         priceLabel: serviceItem.priceController.text,
//                         artistName: serviceItem.artistNameController.text,
//                         artistSpecialization:
//                             serviceItem.artistSpecializationController.text,
//                         serviceType: serviceItem.serviceType.value,
//                         serviceIcon: serviceItem.serviceIcon.value,
//                         leadingIconColor: serviceItem.leadingIconColor.value,
//                         trailingIconColor: serviceItem.trailingIconColor.value,
//                         artistImage: serviceItem.artistImage.value,
//                         id: serviceItem.id,
//                         onDelete: () =>
//                             controller.removeService(serviceItem.id),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Obx(() {
//                 final isSingle = !controller.isBundle.value;
//                 final servicesCount = controller.serviceWidgets.length;

//                 // If single mode and already one service added — don't show button
//                 if (isSingle && servicesCount >= 1)
//                   return const SizedBox.shrink();

//                 return CustomButton(
//                   icon: Icons.add,
//                   text: "Add Another Service",
//                   color: Colors.transparent,
//                   onPressed: controller.addService,
//                   textColor: AppColors.primary,
//                   borderColor: AppColors.primary,
//                   border: true,
//                   borderThickness: 0.4,
//                 );
//               }),
//               const SizedBox(height: 16),
//               CustomButton(
//                 text: "Save Service",
//                 color: AppColors.primary,
//                 onPressed: () {
//                   // Check if there are services to save
//                   if (controller.serviceWidgets.isEmpty) {
//                     Get.snackbar(
//                       'Error',
//                       'Please add at least one service before saving',
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: const Color.fromARGB(126, 236, 140, 247),
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }
//                   else {
//                     _saveServices();
//                   }

//                   // Navigate to the services info page
//                   Get.to(() => ServicesInfoPage());
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:google_fonts/google_fonts.dart';

class AddServicesPage extends StatelessWidget {
  const AddServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final controller = Get.find<AddServicesController>();

    void _saveServices() async {
      // Show loading indicator
      Get.dialog(
        const Center(
          // child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Save services to Firebase
      bool success = await controller.saveServices();

      // Close loading dialog
      Get.back();

      if (success) {
        // Navigate to the services info page
        Get.to(ServicesInfoPage());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: Text(
          "Add Service",
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: Obx(() =>  SingleChildScrollView(
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
                              controller.toggleMode();
                            }
                          },
                          child: Obx(
                            () => CustomButton2(
                                isBold: true,
                                fillColor: controller.isBundle.value
                                    ? AppColors.primary
                                    : Colors.white,
                                text: "Bundle",
                                textColor: controller.isBundle.value
                                    ? AppColors.light
                                    : AppColors.dark,
                                borderColor: controller.isBundle.value
                                    ? AppColors.primary
                                    : Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.isBundle.value) {
                              controller.toggleMode();
                            }
                          },
                          child: Obx(
                            () => CustomButton2(
                              isBold: true,
                              fillColor: !controller.isBundle.value
                                  ? AppColors.primary
                                  : Colors.white,
                              text: "Single",
                              textColor: !controller.isBundle.value
                                  ? AppColors.light
                                  : AppColors.dark,
                              borderColor: !controller.isBundle.value
                                  ? AppColors.primary
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Text("Total time:",
                            style: TextStyle(color: AppColors.hintText)),
                        const SizedBox(width: 15),
                        Text("${controller.calculateTotalTime()} hours"),
                        const Spacer(),
                        const Text("Total price:",
                            style: TextStyle(color: AppColors.hintText)),
                        const SizedBox(width: 15),
                        Text("₹ ${controller.calculateTotalPrice()}"),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Services list - shows either bundle or single services
                    Column(
                      children: List.generate(controller.serviceWidgets.length,
                          (index) {
                        final serviceItem = controller
                            .serviceWidgets[index]; // Get the ServiceItem
                        return Container(
                          key: ValueKey(
                              serviceItem.id), // 🔥 THIS LINE IS IMPORTANT
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: CustomServiceSelectionContainer(
                            id: serviceItem.id,
                            titleController: serviceItem.titleController,
                            descriptionController:
                                serviceItem.descriptionController,
                            serviceCategoryController:
                                serviceItem.serviceCategoryController,
                            buttonBorderColor:
                                serviceItem.buttonBorderColor.value,
                            hintText: serviceItem.hintText.value,
                            borderColor: serviceItem.borderColor.value,
                            borderRadius: serviceItem.borderRadius.value,
                            durationController: serviceItem.durationController,
                            priceController: serviceItem.priceController,
                            artistNameController:
                                serviceItem.artistNameController,
                            artistSpecializationController:
                                serviceItem.artistSpecializationController,
                            serviceType: serviceItem.serviceType.value,
                            serviceIcon: serviceItem.serviceIcon.value,
                            leadingIconColor:
                                serviceItem.leadingIconColor.value,
                            trailingIconColor:
                                serviceItem.trailingIconColor.value,
                            backgroundColor: Colors.white,
                            artistImage: serviceItem.artistImage.value,
                            onDelete: () =>
                                controller.removeService(serviceItem.id),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final isSingle = !controller.isBundle.value;
                      final servicesCount = controller.serviceWidgets.length;

                      // If single mode and already one service added — don't show button
                      if (isSingle && servicesCount >= 1)
                        return const SizedBox.shrink();

                      return CustomButton(
                        icon: Icons.add,
                        text: "Add Another Service",
                        color: Colors.transparent,
                        onPressed: controller.addService,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        border: true,
                        borderThickness: 0.4,
                      );
                    }),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: "Save Service",
                      color: AppColors.primary,
                      onPressed: () {
                        // Check if there are services to save
                        if (controller.serviceWidgets.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please add at least one service before saving',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                const Color.fromARGB(126, 236, 140, 247),
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _saveServices();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )),
    );
  }
}
