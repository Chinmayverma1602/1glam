import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/constants/api_constants.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/services/api_service.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomToast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    controller.fetchServices();
  }

  @override
  void didUpdateWidget(covariant ServicesInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh data when returning to this screen
    controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.isLoading
          ? const Center(
              child: CustomLoadingAnimation(
                size: 50,
                type: LoadingAnimationType.staggeredDotsWave,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    //
                    CustomHeader(),
                    const SizedBox(height: 24),
                    // Title
                    const Text(
                      "Add your services",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E0057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Group services into Bundles or you can add it later",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Services List
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
                            return const Center(
                                child: CustomLoadingAnimation(
                              size: 40,
                              type: LoadingAnimationType.staggeredDotsWave,
                              showText: false,
                            ));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            // Demo services when no data is available
                            return ListView(
                              children: [
                                _buildServiceCard("Natural Makeup", "45 min",
                                    "30.00", "demo1"),
                                const SizedBox(height: 16),
                                _buildServiceCard("Evening Makeup", "1 hour",
                                    "45.00", "demo2"),
                              ],
                            );
                          }

                          final List<ServiceItem> allServices =
                              snapshot.data!.docs.map((doc) {
                            return ServiceItem.fromFirestore(
                                doc, 0); // Adjust ID handling if needed
                          }).toList();

                          return ListView.builder(
                            itemCount: allServices.length,
                            itemBuilder: (context, index) {
                              final serviceItem = allServices[index];
                              final docId = snapshot.data!.docs[index].id;

                              // Format duration in hours
                              String durationText = "";
                              try {
                                double hours = double.parse(
                                    serviceItem.durationController.text);
                                if (hours == 1) {
                                  durationText = "1 hour";
                                } else if (hours == hours.toInt()) {
                                  // If it's a whole number, don't show the decimal point
                                  durationText = "${hours.toInt()} hours";
                                } else {
                                  durationText = "$hours hours";
                                }
                              } catch (e) {
                                // If we can't parse the value, just show it as is
                                String duration =
                                    serviceItem.durationController.text;
                                durationText = duration == "1"
                                    ? "1 hour"
                                    : "$duration hours";
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: _buildServiceCard(
                                  serviceItem.titleController.text,
                                  durationText,
                                  serviceItem.priceController.text,
                                  docId,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Add Service Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => AddServicesPage());
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Continue Button
                    ElevatedButton(
                      onPressed: () {
                        _submitServicesToBackend();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildServiceCard(
      String title, String duration, String price, String docId) {
    return GestureDetector(
      onTap: () {
        _navigateToEditService(docId);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E0057),
                    ),
                  ),
                  //   SizedBox(height: 8),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "\$${price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  //    const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      _showDeleteConfirmation(title, docId);
                    },
                  ),
                  SizedBox(width: 1),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      _navigateToEditService(docId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String serviceName, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Service"),
          content: Text("Are you sure you want to delete '$serviceName'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Call delete method
                _deleteService(docId, serviceName);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(String docId, String serviceName) {
    // Skip deletion for demo items
    if (docId.startsWith('demo')) {
      CustomToast.showWarning(
        context,
        message: "This is a demo service and cannot be deleted.",
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('services')
        .doc(docId)
        .delete()
        .then((_) {
      CustomToast.showSuccess(
        context,
        message: "Service '$serviceName' deleted successfully",
      );
    }).catchError((error) {
      CustomToast.showError(
        context,
        message: "Error deleting service: $error",
      );
    });
  }

  void _navigateToEditService(String docId) {
    // For demo services, show a message
    if (docId.startsWith('demo')) {
      CustomToast.showWarning(
        context,
        message: "Demo services cannot be edited.",
      );
      return;
    }

    // Show loading indicator while loading service for editing
    showLoadingDialog(
      context,
      text: "Loading service details...",
      type: LoadingAnimationType.staggeredDotsWave,
    );

    // For real services, navigate to edit page
    controller.editService(docId).then((success) {
      // Dismiss loading dialog
      dismissLoadingDialog(context);

      if (success) {
        Get.to(() => AddServicesPage());
      } else {
        CustomToast.showError(
          context,
          message: "Failed to load service details for editing",
        );
      }
    });
  }

  void _submitServicesToBackend() async {
    try {
      // Show loading indicator with modern circular indicator
      showLoadingDialog(
        context,
        text: "Submitting services...",
        type: LoadingAnimationType.staggeredDotsWave,
      );

      // Get token from TokenManager
      String? token = await TokenManager.getToken();
      String? userId = await TokenManager.getUserId();

      if (token == null || userId == null) {
        // If no token or userId, get from constants
        token = ApiConstants.authToken.replaceAll("Bearer ", "");
        userId = "68133e4f86d05522e98737eb"; // Default user ID from example
      }

      // API endpoint
      const String apiUrl =
          "https://1glambackend-production.up.railway.app/api/resource/userServices";

      // Get services from Firebase
      final snapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('user_email', isEqualTo: 'user_email1@gmail.com')
          .get();

      if (snapshot.docs.isEmpty) {
        dismissLoadingDialog(context); // Close loading dialog
        CustomToast.showWarning(
          context,
          message: "No services found. Please add services first.",
        );
        return;
      }

      // Determine if we're dealing with a bundle or single service
      final isBundle =
          snapshot.docs.any((doc) => (doc.data()['isBundle'] == true));

      // Prepare data structure
      Map<String, dynamic> requestBody = {
        "user": userId,
        "bundle": isBundle,
      };

      if (isBundle) {
        // For bundles, create a bundle service with included services
        String bundleName = "Service Bundle";
        double totalDuration = 0;
        List<Map<String, dynamic>> servicesIncluded = [];

        // Process each service document
        for (var doc in snapshot.docs) {
          final data = doc.data();

          // If it's the first document, use its name as the bundle name
          if (servicesIncluded.isEmpty) {
            bundleName = data['title'] ?? "Service Bundle";
          }

          // Parse duration and price
          double duration = double.tryParse(data['duration'] ?? "0") ?? 0;
          double price = double.tryParse(
                  data['price']?.toString().replaceAll(',', '') ?? "0") ??
              0;

          totalDuration += duration;

          // Add to included services
          servicesIncluded.add({
            "service_name": data['title'] ?? "Service",
            "price": price,
            "duration": duration * 60 // Convert to minutes
          });
        }

        requestBody["service_name"] = bundleName;
        requestBody["services_included"] = servicesIncluded;
        requestBody["duration"] = totalDuration * 60; // Convert to minutes
      } else {
        // For single service
        final doc = snapshot.docs.first;
        final data = doc.data();

        double duration = double.tryParse(data['duration'] ?? "0") ?? 0;
        double price = double.tryParse(
                data['price']?.toString().replaceAll(',', '') ?? "0") ??
            0;
        String serviceName = data['title'] ?? "Service";

        requestBody["service_name"] = serviceName;
        // For single service, add the service details to services_included
        requestBody["services_included"] = [
          {
            "service_name": serviceName,
            "price": price,
            "duration": duration * 60 // Convert to minutes
          }
        ];
        requestBody["duration"] = duration * 60; // Convert to minutes
      }

      // Make API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      // Close loading dialog
      dismissLoadingDialog(context);

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Show success message using CustomToast
        CustomToast.showSuccess(
          context,
          message: responseData['message'] ?? "Service submitted successfully",
        );

        // Add a small delay to ensure toast is visible before navigation
        Future.delayed(Duration(milliseconds: 300), () {
          // Navigate to the next screen or handle success
          Get.to(() => HomePage(lead: responseData['userService']));
        });
      } else {
        // Show error message using CustomToast
        CustomToast.showError(
          context,
          message: "Failed to submit services: ${response.body}",
        );
      }
    } catch (e) {
      // Close loading dialog if open
      dismissLoadingDialog(context);

      // Show error message using CustomToast
      CustomToast.showError(
        context,
        message: "Error: $e",
      );
    }
  }
}
