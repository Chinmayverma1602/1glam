import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/constants/AppColors.dart';

class AddServicesController extends GetxController {
  // Mode toggle
  RxBool isBundle = true.obs;
  
  // Separate lists for bundle and single modes
  RxList<CustomServiceSelectionContainer> bundleServiceWidgets = <CustomServiceSelectionContainer>[].obs;
  RxList<CustomServiceSelectionContainer> singleServiceWidget = <CustomServiceSelectionContainer>[].obs;
  
  // Computed property to get current widgets based on mode
  List<CustomServiceSelectionContainer> get serviceWidgets => 
      isBundle.value ? bundleServiceWidgets : singleServiceWidget;

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
}