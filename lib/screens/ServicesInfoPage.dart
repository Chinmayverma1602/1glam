import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomHeader.dart';

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
          ? const Center(child: CircularProgressIndicator())
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
                                child: CircularProgressIndicator());
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
                        // Handle continue button
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
                  const SizedBox(height: 4),
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
                  const SizedBox(width: 8),
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
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("This is a demo service and cannot be deleted.")),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('services')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Service '$serviceName' deleted successfully")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting service: $error")),
      );
    });
  }

  void _navigateToEditService(String docId) {
    // For demo services, show a message
    if (docId.startsWith('demo')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Demo services cannot be edited.")),
      );
      return;
    }

    // For real services, navigate to edit page
    controller.editService(docId).then((success) {
      if (success) {
        Get.to(() => AddServicesPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to load service details for editing")),
        );
      }
    });
  }
}
