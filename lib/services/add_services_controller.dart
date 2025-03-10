import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/constants/AppColors.dart';

class ServiceItemModel {
  final String serviceName;
  final double price;
  final double duration;

  ServiceItemModel({
    required this.serviceName,
    required this.price,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'price': price,
      'duration': duration,
    };
  }
}

class AddServicesController extends GetxController {
  // Mode toggle
  RxBool isBundle = true.obs;

  // Separate lists for bundle and single modes
  RxList<CustomServiceSelectionContainer> bundleServiceWidgets =
      <CustomServiceSelectionContainer>[].obs;
  RxList<CustomServiceSelectionContainer> singleServiceWidget =
      <CustomServiceSelectionContainer>[].obs;

  // Computed property to get current widgets based on mode
  List<CustomServiceSelectionContainer> get serviceWidgets =>
      isBundle.value ? bundleServiceWidgets : singleServiceWidget;

  // API loading state
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

    // Create the new index before adding the widget
    final newIndex = isBundle.value ? bundleServiceWidgets.length : 0;

    final newService = CustomServiceSelectionContainer(
      title: 'New Service',
      serviceCategory: 'Luxury',
      buttonBorderColor: AppColors.hintText.withOpacity(0.4),
      borderColor: AppColors.hintText,
      hintText: 'Service description',
      borderRadius: 16,
      durationLabel: '2',
      priceLabel: '40,000',
      artistName: 'New Artist',
      artistSpecialization: 'Specialist',
      serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
      serviceIcon: 'assets/images/f.svg',
      leadingIconColor: AppColors.primary,
      trailingIconColor: AppColors.primary,
      artistImage: 'assets/images/img.svg',
      onDelete: () => removeService(newIndex),
    );

    if (isBundle.value) {
      bundleServiceWidgets.add(newService);
    } else {
      singleServiceWidget.add(newService);
    }
  }

  // Remove service from the appropriate list
  void removeService(int index) {
    if (isBundle.value) {
      if (index >= 0 && index < bundleServiceWidgets.length) {
        bundleServiceWidgets.removeAt(index);
        // Update onDelete callbacks for remaining items
        updateOnDeleteCallbacks();
      }
    } else {
      if (index >= 0 && index < singleServiceWidget.length) {
        singleServiceWidget.removeAt(index);
        // Update onDelete callbacks for remaining items
        updateOnDeleteCallbacks();
      }
    }
  }

  // Update onDelete callbacks after removing a service
  void updateOnDeleteCallbacks() {
    List<CustomServiceSelectionContainer> currentList =
        isBundle.value ? bundleServiceWidgets : singleServiceWidget;

    for (int i = 0; i < currentList.length; i++) {
      final currentService = currentList[i];

      // Create updated service with correct index
      final updatedService = CustomServiceSelectionContainer(
        title: currentService.title,
        serviceCategory: currentService.serviceCategory,
        buttonBorderColor: currentService.buttonBorderColor,
        borderColor: currentService.borderColor,
        hintText: currentService.hintText,
        borderRadius: currentService.borderRadius,
        durationLabel: currentService.durationLabel,
        priceLabel: currentService.priceLabel,
        artistName: currentService.artistName,
        artistSpecialization: currentService.artistSpecialization,
        serviceType: currentService.serviceType,
        serviceIcon: currentService.serviceIcon,
        leadingIconColor: currentService.leadingIconColor,
        trailingIconColor: currentService.trailingIconColor,
        artistImage: currentService.artistImage,
        onDelete: () => removeService(i),
      );

      // Replace with updated service
      if (isBundle.value) {
        bundleServiceWidgets[i] = updatedService;
      } else {
        singleServiceWidget[i] = updatedService;
      }
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
      List<CustomServiceSelectionContainer> allServices = [];

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
        String serviceName = serviceWidget.title;
        double duration = double.parse(serviceWidget.durationLabel) *
            60; // Convert hours to minutes
        double price = double.parse(
            serviceWidget.priceLabel.replaceAll(',', '')); // Remove commas

        Map<String, dynamic> requestBody;

        if (isBundle.value) {
          // For bundle services, we need to include the individual services
          List<ServiceItemModel> includedServices = [];

          // In this example, we're creating dummy included services for each bundle service
          // In a real app, you'd collect this data from the user
          includedServices.add(ServiceItemModel(
            serviceName: "Makeup",
            price: price * 0.6, // 60% of total price
            duration: duration * 0.4, // 40% of total duration
          ));

          includedServices.add(ServiceItemModel(
            serviceName: "Hair Styling",
            price: price * 0.4, // 40% of total price
            duration: duration * 0.6, // 60% of total duration
          ));

          // Create bundle service request body
          requestBody = {
            "user": "test@example.com",
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
            "user": "test@example.com",
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
