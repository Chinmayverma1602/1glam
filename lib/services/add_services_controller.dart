// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ServiceItemModel {
//   final String serviceName;
//   final double price;
//   final double duration;

//   ServiceItemModel({
//     required this.serviceName,
//     required this.price,
//     required this.duration,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'service_name': serviceName,
//       'price': price,
//       'duration': duration,
//     };
//   }
// }

// class AddServicesController extends GetxController {
//   // Mode toggle
//   RxBool isBundle = true.obs;
//   int _serviceIdCounter = 0;

//   // Separate lists for bundle and single modes
//   RxList<CustomServiceSelectionContainer> bundleServiceWidgets =
//       <CustomServiceSelectionContainer>[].obs;
//   RxList<CustomServiceSelectionContainer> singleServiceWidget =
//       <CustomServiceSelectionContainer>[].obs;

//   TextEditingController titleController =
//       TextEditingController(text: 'New Service');

//   // Computed property to get current widgets based on mode
//   List<CustomServiceSelectionContainer> get serviceWidgets =>
//       isBundle.value ? bundleServiceWidgets : singleServiceWidget;

//   // API loading state
//   final RxBool _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;

//   @override
//   void onInit() {
//     super.onInit();
//     // Don't add any default service as requested
//   }

//   // Toggle between Bundle and Single mode
//   void toggleMode() {
//     isBundle.value = !isBundle.value;
//     // No need to clear services as we're now using separate lists
//   }

// // Add a new service to the current mode
// void addService() {
//   if (!isBundle.value && singleServiceWidget.isNotEmpty) {
//     Get.snackbar('Limit Reached', 'Single mode allows only one service');
//     return;
//   }

//   // Assign a unique ID for this service
//   final serviceId = _serviceIdCounter++;

//   // Create the new index before adding the widget
//   final newIndex = isBundle.value ? bundleServiceWidgets.length : 0;

//   final newService = CustomServiceSelectionContainer(
//     title: titleController.text.trim(),
//     serviceCategory: 'Luxury',
//     buttonBorderColor: AppColors.hintText.withOpacity(0.4),
//     borderColor: AppColors.hintText,
//     hintText: 'Service description',
//     borderRadius: 16,
//     durationLabel: '2',
//     priceLabel: '40,000',
//     artistName: 'New Artist',
//     artistSpecialization: 'Specialist',
//     serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
//     serviceIcon: 'assets/images/f.svg',
//     leadingIconColor: AppColors.primary,
//     trailingIconColor: AppColors.primary,
//     artistImage: 'assets/images/img.svg',
//     id: serviceId,
//     onDelete: () => removeService(serviceId),
//   );

//   if (isBundle.value) {
//     bundleServiceWidgets.add(newService);
//     print("$serviceId haahhahaahhha");
//   } else {
//     singleServiceWidget.add(newService);
//   }
// }

// // Remove service by ID only
// // void removeService(int id) {
// //   print("Attempting to remove service with ID: $id");

// //   if (isBundle.value) {
// //     // Find and remove by ID
// //     final index = bundleServiceWidgets.indexWhere((service) => service.id == id);
// //     if (index >= 0) {
// //       print("Found service at index $index with ID $id in bundle list. Removing...");
// //       bundleServiceWidgets.removeAt(index);
// //       // Update callbacks for remaining services
// //       updateOnDeleteCallbacks();
// //     } else {
// //       print("Service with ID $id not found in bundle list");
// //     }
// //   } else {
// //     // Same for single service
// //     final index = singleServiceWidget.indexWhere((service) => service.id == id);
// //     if (index >= 0) {
// //       print("Found service at index $index with ID $id in single list. Removing...");
// //       singleServiceWidget.removeAt(index);
// //       // Update callbacks for remaining services
// //       updateOnDeleteCallbacks();
// //     } else {
// //       print("Service with ID $id not found in single list");
// //     }
// //   }
// // }

// void removeService(int id) {
//   print("Attempting to remove service with ID: $id");

//   if (isBundle.value) {
//     // Find and remove by ID
//     final index = bundleServiceWidgets.indexWhere((service) => service.id == id);
//     if (index >= 0) {
//       print("Found service at index $index with ID $id in bundle list. Removing...");
//       bundleServiceWidgets.removeAt(index);
//     } else {
//       print("Service with ID $id not found in bundle list");
//     }
//   } else {
//     // Same for single service
//     final index = singleServiceWidget.indexWhere((service) => service.id == id);
//     if (index >= 0) {
//       print("Found service at index $index with ID $id in single list. Removing...");
//       singleServiceWidget.removeAt(index);
//     } else {
//       print("Service with ID $id not found in single list");
//     }
//   }

//   // No need to call updateOnDeleteCallbacks here; it's redundant.
// }

// // Update onDelete callbacks after removing a service
// void updateOnDeleteCallbacks() {
//   List<CustomServiceSelectionContainer> currentList =
//       isBundle.value ? bundleServiceWidgets : singleServiceWidget;

//   for (int i = 0; i < currentList.length; i++) {
//     final serviceToUpdate = currentList[i];
//     final serviceId = serviceToUpdate.id;

//     // Update the callback without recreating unnecessary properties
//     currentList[i] = CustomServiceSelectionContainer(
//       title: serviceToUpdate.title,
//       serviceCategory: serviceToUpdate.serviceCategory,
//       buttonBorderColor: serviceToUpdate.buttonBorderColor,
//       borderColor: serviceToUpdate.borderColor,
//       hintText: serviceToUpdate.hintText,
//       borderRadius: serviceToUpdate.borderRadius,
//       durationLabel: serviceToUpdate.durationLabel,
//       priceLabel: serviceToUpdate.priceLabel,
//       artistName: serviceToUpdate.artistName,
//       artistSpecialization: serviceToUpdate.artistSpecialization,
//       serviceType: serviceToUpdate.serviceType,
//       serviceIcon: serviceToUpdate.serviceIcon,
//       leadingIconColor: serviceToUpdate.leadingIconColor,
//       trailingIconColor: serviceToUpdate.trailingIconColor,
//       artistImage: serviceToUpdate.artistImage,
//       id: serviceId, // Keep the original ID
//       onDelete: () => removeService(serviceId), // Pass only the ID
//     );
//   }
// }

//   // Calculate total time based on the current mode
//   int calculateTotalTime() {
//     return serviceWidgets.length * 2;
//   }

//   // Calculate total price based on the current mode
//   int calculateTotalPrice() {
//     return serviceWidgets.length * 40000;
//   }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceItem {
  final int id;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final RxString serviceCategory;
  final Rx<Color> buttonBorderColor;
  final Rx<Color> borderColor;
  final RxString hintText;
  final RxDouble borderRadius;
  final TextEditingController durationController;
  final TextEditingController priceController;
  final TextEditingController artistNameController;
  final TextEditingController artistSpecializationController;
  final RxString serviceType;
  final RxString serviceIcon;
  final Rx<Color> leadingIconColor;
  final Rx<Color> trailingIconColor;
  final RxString artistImage;

  ServiceItem({
    required this.id,
    required this.titleController,
    required this.descriptionController,
    required String serviceCategory,
    required Color buttonBorderColor,
    required Color borderColor,
    required String hintText,
    required double borderRadius,
    required this.durationController,
    required this.priceController,
    required this.artistNameController,
    required this.artistSpecializationController,
    required String serviceType,
    required String serviceIcon,
    required Color leadingIconColor,
    required Color trailingIconColor,
    required String artistImage,
  })  : serviceCategory = serviceCategory.obs,
        buttonBorderColor = buttonBorderColor.obs,
        borderColor = borderColor.obs,
        hintText = hintText.obs,
        borderRadius = borderRadius.obs,
        serviceType = serviceType.obs,
        serviceIcon = serviceIcon.obs,
        leadingIconColor = leadingIconColor.obs,
        trailingIconColor = trailingIconColor.obs,
        artistImage = artistImage.obs;

  Map<String, dynamic> toJson() {
    return {
      'service_name': titleController,
      'price': priceController,
      'duration': durationController,
    };
  }
}

class AddServicesController extends GetxController {
  // Mode toggle
  RxBool isBundle = true.obs;
  int _serviceIdCounter = 0;

  // Separate lists for bundle and single modes, now holding ServiceItem
  RxList<ServiceItem> bundleServiceWidgets = <ServiceItem>[].obs;
  RxList<ServiceItem> singleServiceWidget = <ServiceItem>[].obs;

  // Computed property to get current service items based on mode
  RxList<ServiceItem> get serviceWidgets =>
      isBundle.value ? bundleServiceWidgets : singleServiceWidget;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Don't add any default service as requested
  }

  // Toggle between Bundle and Single mode
  void toggleMode() {
    isBundle.value = !isBundle.value;
    // No need to clear services as we're now using separate lists
  }

// Add a new service to the current mode
  void addService() {
    if (!isBundle.value && singleServiceWidget.isNotEmpty) {
      Get.snackbar('Limit Reached', 'Single mode allows only one service');
      return;
    }

    // Assign a unique ID for this service
    final serviceId = _serviceIdCounter++;

    final newServiceItem = ServiceItem(
      id: serviceId,
      titleController: TextEditingController(text: 'New Service '),
      descriptionController: TextEditingController(text: 'Service description'),
      serviceCategory: 'Luxury',
      buttonBorderColor: AppColors.hintText.withOpacity(0.4),
      borderColor: AppColors.hintText,
      hintText: 'Service description',
      borderRadius: 16,
      durationController: TextEditingController(text: '2'),
      priceController: TextEditingController(text: '40,000'),
      artistNameController: TextEditingController(text: 'New Artist'),
      artistSpecializationController: TextEditingController(text: 'Specialist'),
      serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
      serviceIcon: 'assets/images/f.svg',
      leadingIconColor: AppColors.primary,
      trailingIconColor: AppColors.primary,
      artistImage: 'assets/images/img.svg',
    );

    if (isBundle.value) {
      bundleServiceWidgets.add(newServiceItem);
    } else {
      singleServiceWidget.add(newServiceItem);
    }
  }

// Remove service by ID
  void removeService(int id) {
    if (isBundle.value) {
      final index = bundleServiceWidgets.indexWhere((item) => item.id == id);
      // Dispose of the controllers before removing the item
      bundleServiceWidgets[index].titleController.dispose();
      bundleServiceWidgets[index].descriptionController.dispose();
      bundleServiceWidgets[index].durationController.dispose();
      bundleServiceWidgets[index].priceController.dispose();
      bundleServiceWidgets[index].artistNameController.dispose();
      bundleServiceWidgets[index].artistSpecializationController.dispose();
      bundleServiceWidgets.removeAt(index);
    } else {
      final index = singleServiceWidget.indexWhere((item) => item.id == id);
      // Dispose of the controllers before removing the item
      singleServiceWidget[index].titleController.dispose();
      singleServiceWidget[index].descriptionController.dispose();
      singleServiceWidget[index].durationController.dispose();
      singleServiceWidget[index].priceController.dispose();
      singleServiceWidget[index].artistNameController.dispose();
      singleServiceWidget[index].artistSpecializationController.dispose();
      singleServiceWidget.removeAt(index);
    }
  }

  // Calculate total time based on the current mode
  int calculateTotalTime() {
    return serviceWidgets.length * 2;
  }

  // Calculate total price based on the current mode
  int calculateTotalPrice() {
    return serviceWidgets.length * 40000;
  }
  
  

  void disposeControllers() {
    // Dispose of controllers in bundle services
    for (final serviceItem in bundleServiceWidgets) {
      serviceItem.titleController.dispose();
      serviceItem.descriptionController.dispose();
      serviceItem.durationController.dispose();
      serviceItem.priceController.dispose();
      serviceItem.artistNameController.dispose();
      serviceItem.artistSpecializationController.dispose();
    }
    // Clear the bundle services list
    bundleServiceWidgets.clear();

    // Dispose of controllers in single service (if it exists)
    if (singleServiceWidget.isNotEmpty) {
      singleServiceWidget.first.titleController.dispose();
      singleServiceWidget.first.descriptionController.dispose();
      singleServiceWidget.first.durationController.dispose();
      singleServiceWidget.first.priceController.dispose();
      singleServiceWidget.first.artistNameController.dispose();
      singleServiceWidget.first.artistSpecializationController.dispose();
      // Clear the single service list
      singleServiceWidget.clear();
    }

    // Reset the service ID counter if needed
    _serviceIdCounter = 0;
  }



















  // Save services to the backend API
  Future<bool> saveServices() async {
    _isLoading.value = true;

    try {
      final String apiUrl =
          'http://1glam.local:8000//api/resource/userServices';
      final Map<String, String> headers = {
        'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
        'Content-Type': 'application/json',
      };

      // Get all services to be saved (both bundle and single)
      List<ServiceItem> allServices = [];

      // If bundle mode is active, save the bundle services
      if (isBundle.value && bundleServiceWidgets.isNotEmpty) {
        allServices.addAll(bundleServiceWidgets);
      }
      // If single mode is active, save the single service
      else if (!isBundle.value && singleServiceWidget.isNotEmpty) {
        allServices.addAll(singleServiceWidget);
      }

      // If no services to save, return error
      if (allServices.isEmpty) {
        _isLoading.value = false;
        return false;
      }

      // Save each service
      for (var serviceWidget in allServices) {
        // Extract info from service widget
        String serviceName = serviceWidget.titleController.text;
        double duration = double.parse(serviceWidget.durationController.text) *
            60; // Convert hours to minutes
        double price = double.parse(serviceWidget.priceController.text
            .replaceAll(',', '')); // Remove commas

        Map<String, dynamic> requestBody;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String selectedEmail = prefs.getString('user_email') ?? "";

        if (isBundle.value) {
          // For bundle services, we need to include the individual services
          List<ServiceItem> includedServices = [];

          // In this example, we're creating dummy included services for each bundle service
          // In a real app, you'd collect this data from the user

          includedServices.add(ServiceItem(
            id: 0,
            titleController: TextEditingController(text: 'New Service '),
            descriptionController:
                TextEditingController(text: 'Service description'),
            serviceCategory: 'Luxury',
            buttonBorderColor: AppColors.hintText.withOpacity(0.4),
            borderColor: AppColors.hintText,
            hintText: 'Service description',
            borderRadius: 16,
            durationController: TextEditingController(text: '2'),
            priceController: TextEditingController(text: '40,000'),
            artistNameController: TextEditingController(text: 'New Artist'),
            artistSpecializationController:
                TextEditingController(text: 'Specialist'),
            serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
            serviceIcon: 'assets/images/f.svg',
            leadingIconColor: AppColors.primary,
            trailingIconColor: AppColors.primary,
            artistImage: 'assets/images/img.svg',
          ));

          includedServices.add(ServiceItem(
            id: 0,
            titleController: TextEditingController(text: 'New Service '),
            descriptionController:
                TextEditingController(text: 'Service description'),
            serviceCategory: 'Luxury',
            buttonBorderColor: AppColors.hintText.withOpacity(0.4),
            borderColor: AppColors.hintText,
            hintText: 'Service description',
            borderRadius: 16,
            durationController: TextEditingController(text: '2'),
            priceController: TextEditingController(text: '40,000'),
            artistNameController: TextEditingController(text: 'New Artist'),
            artistSpecializationController:
                TextEditingController(text: 'Specialist'),
            serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
            serviceIcon: 'assets/images/f.svg',
            leadingIconColor: AppColors.primary,
            trailingIconColor: AppColors.primary,
            artistImage: 'assets/images/img.svg',
          ));

          // Create bundle service request body
          requestBody = {
            "user": selectedEmail,
            "service_name": serviceName,
            "bundle": true,
            "services_included":
                includedServices.map((item) => item.toJson()).toList(),
            "duration": duration,
            "price": price
          };
        } else {
          // Create single service request body
          requestBody = {
            "user": selectedEmail,
            "service_name": serviceName,
            "bundle": false,
            "price": price,
            "duration": duration
          };
        }

        // Send the request to the API
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        // Check for success
        if (response.statusCode != 200) {
          print('API Error: ${response.body}');
          _isLoading.value = false;
          return false;
        }
      }

      _isLoading.value = false;
      return true;
    } catch (e) {
      print('Error saving services: $e');
      _isLoading.value = false;
      return false;
    }
  }
}
