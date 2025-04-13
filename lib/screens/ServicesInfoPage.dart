// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:glam1/screens/AddServicesPage.dart';
// import 'package:glam1/services/add_services_controller.dart';
// import 'package:glam1/widgets/CustomButton.dart';
// import 'package:glam1/widgets/CustomHeader.dart';
// import 'package:glam1/widgets/CustomServiceButton.dart';
// import 'package:glam1/widgets/CustomSubtitle.dart';
// import 'package:glam1/widgets/CustomTitle.dart';

// class ServicesInfoPage extends StatelessWidget {
//   const ServicesInfoPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get the AddServicesController instance
//     final controller = Get.find<AddServicesController>();
//     AddServicesController addServicesController =
//         Get.put(AddServicesController());

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 18),
//             const CustomHeader(),
//             const SizedBox(height: 35),
//             CustomTitle(title: "Add your services", fontSize: 30),
//             const SizedBox(height: 15),
//             const CustomSubTitle(
//               subtitle: "Group services into Bundles or you can add it later",
//               color: Color.fromARGB(255, 124, 13, 130),
//             ),

//             // Display services based on active mode (bundle or single)
//             Expanded(
//               child: Obx(() {
//                 // Get the appropriate service list
//                 final serviceList = controller.isBundle.value
//                     ? controller.bundleServiceWidgets
//                     : controller.singleServiceWidget;

//                 // If no services, show message
//                 if (serviceList.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No services added yet",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }

//                 // Display services
//                 return ListView.builder(
//                   itemCount: serviceList.length,
//                   itemBuilder: (context, index) {
//                     final service = serviceList[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 15),
//                       child: CustomServiceButton(
//                         title: addServicesController.titleController.text,
//                         subtitle: "${service.durationLabel} hours",
//                         value: service.priceLabel,
//                         leadingIconColor: AppColors.subtitle,
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),

//             const SizedBox(height: 20),
//             CustomButton(
//               text: "Add Service",
//               color: Colors.transparent,
//               onPressed: () {
//                 Get.to(() => const AddServicesPage());
//               },
//               textColor: AppColors.primary,
//               icon: Icons.add,
//               iconColor: AppColors.primary,
//               borderThickness: 0.4,
//               borderColor: AppColors.primary,
//             ),
//             const SizedBox(height: 15),

//             // Continue button with API integration
//             Obx(() => CustomButton(
//                   text: controller.isLoading ? "Saving..." : "Continue",
//                   color: AppColors.subtitle,
//                   onPressed: controller.isLoading
//                       ? null // Disable button while loading
//                       : () async {
//                           // Get active service list
//                           final serviceList = controller.isBundle.value
//                               ? controller.bundleServiceWidgets
//                               : controller.singleServiceWidget;

//                           // Check if there are services to save
//                           if (serviceList.isEmpty) {
//                             Get.snackbar(
//                               'Error',
//                               'Please add at least one service before continuing',
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                             return;
//                           }

//                           // Call API to save services
//                           final success = await controller.saveServices();

//                           if (success) {
//                             Get.snackbar(
//                               'Success',
//                               'Services saved successfully',
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.green,
//                               colorText: Colors.white,
//                             );
//                             // Navigate to next screen (add your navigation logic here)
//                             // Get.to(() => NextScreen());
//                           } else {
//                             Get.snackbar(
//                               'Error',
//                               'Failed to save services',
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.red,
//                               colorText: Colors.white,
//                             );
//                           }
//                         },
//                 )),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomServiceButton.dart';

class ServicesInfoPage extends StatefulWidget {
  const ServicesInfoPage({super.key});

  @override
  State<ServicesInfoPage> createState() => _ServicesInfoPageState();
}

class _ServicesInfoPageState extends State<ServicesInfoPage> {
  final AddServicesController controller = Get.find<AddServicesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3E9FF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 249, 244, 255),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.01),
              child: const Text(
                "Your Added Services",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.01),
              child: const Text(
                "Here are the services you've added.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final RxList<ServiceItem> allServices = [
                ...controller
                    .bundleServiceWidgets, // Ensure this is the correct list name
                ...controller
                    .singleServiceWidget, // Ensure this is the correct list name
              ].obs;

              if (allServices.isEmpty) {
                return const Center(
                  child: Text('No services have been added yet.'),
                );
              }

              return Column(
                children: allServices.map((serviceItem) {
                  return CustomServiceButton(
                    title: serviceItem.titleController.text,
                    subtitle:
                        '${double.tryParse(serviceItem.durationController.text)?.toStringAsFixed(0) ?? '0'} Hours',
                    price: '₹ ${serviceItem.priceController.text}',
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Get.to(AddServicesPage());
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    "Add Service",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Center(
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
