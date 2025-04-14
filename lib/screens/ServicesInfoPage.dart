// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:glam1/screens/AddServicesPage.dart';
// import 'package:glam1/services/add_services_controller.dart';
// import 'package:glam1/widgets/CustomHeader.dart';
// import 'package:glam1/widgets/CustomServiceButton.dart';

// class ServicesInfoPage extends StatefulWidget {
//   const ServicesInfoPage({super.key});

//   @override
//   State<ServicesInfoPage> createState() => _ServicesInfoPageState();
// }

// class _ServicesInfoPageState extends State<ServicesInfoPage> {
//   final AddServicesController controller = Get.find<AddServicesController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: const Color(0xFFF3E9FF),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 249, 244, 255),
//               Color.fromARGB(255, 255, 255, 255)
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             CustomHeader(),
//             const SizedBox(height: 16),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.01),
//               child: const Text(
//                 "Your Added Services",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.01),
//               child: const Text(
//                 "Here are the services you've added.",
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Obx(() {
//               final RxList<ServiceItem> allServices = [
//                 ...controller
//                     .bundleServiceWidgets, // Ensure this is the correct list name
//                 ...controller
//                     .singleServiceWidget, // Ensure this is the correct list name
//               ].obs;

//               if (allServices.isEmpty) {
//                 return const Center(
//                   child: Text('No services have been added yet.'),
//                 );
//               }

//               return Column(
//                 children: allServices.map((serviceItem) {
//                   return CustomServiceButton(
//                     title: serviceItem.titleController.text,
//                     subtitle:
//                         '${double.tryParse(serviceItem.durationController.text)?.toStringAsFixed(0) ?? '0'} Hours',
//                     price: '₹ ${serviceItem.priceController.text}',
//                   );
//                 }).toList(),
//               );
//             }),
//             const SizedBox(height: 16),
//             const Spacer(),
//             OutlinedButton(
//               onPressed: () {
//                 Get.to(AddServicesPage());
//               },
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: AppColors.primary),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.add, color: AppColors.primary),
//                   SizedBox(width: 8),
//                   Text(
//                     "Add Service",
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Center(
//                 child: Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 26),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
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
  void initState() {
    super.initState();
    // Refresh services from Firebase when the page loads
    controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3E9FF),
      body: Obx(() => controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('services')
                          .where('user_email',
                              isEqualTo: 'user_email1@gmail.com')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Something went wrong: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No services have been added yet.'),
                          );
                        }

                        final List<ServiceItem> allServices =
                            snapshot.data!.docs.map((doc) {
                          return ServiceItem.fromFirestore(
                              doc, 0); // Adjust ID handling if needed
                        }).toList();

                        print(
                            'Length of filtered Services (from Stream): ${allServices.length}');

                        return ListView.builder(
                          itemCount: allServices.length,
                          itemBuilder: (context, index) {
                            final serviceItem = allServices[index];
                            return CustomServiceButton(
                              title: serviceItem.titleController.text,
                              subtitle:
                                  '${double.tryParse(serviceItem.durationController.text)?.toStringAsFixed(0) ?? '0'} Hours',
                              price: '₹ ${serviceItem.priceController.text}',
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Get.to(() => AddServicesPage());
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
                    onPressed: () {
                      // Handle continue button
                      // You might want to add navigation or processing here
                    },
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
            )),
    );
  }
}
