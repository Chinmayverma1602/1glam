import 'package:get/get.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/constants/AppColors.dart';

class AddServicesController extends GetxController {
  RxBool isBundle = false.obs;
  RxList<CustomServiceSelectionContainer> serviceWidgets = <CustomServiceSelectionContainer>[].obs;

  void toggleMode() {
    isBundle.value = !isBundle.value;

    // If switching to single mode and multiple services exist, keep only the first one
    if (!isBundle.value && serviceWidgets.length > 1) {
      final firstService = serviceWidgets.first;
      serviceWidgets.clear();
      serviceWidgets.add(firstService);
      Get.snackbar('Mode Changed', 'Switched to Single mode: extra services removed');
    }

    // If switching to bundle mode and there are no services, add a default one
    if (isBundle.value && serviceWidgets.isEmpty) {
      addService();
    }

    // Update service types
    updateServiceTypes();
  }

  void updateServiceTypes() {
    for (int i = 0; i < serviceWidgets.length; i++) {
      final widget = serviceWidgets[i];
      serviceWidgets[i] = CustomServiceSelectionContainer(
        title: widget.title,
        serviceCategory: widget.serviceCategory,
        buttonBorderColor: widget.buttonBorderColor,
        borderColor: widget.borderColor,
        hintText: widget.hintText,
        borderRadius: widget.borderRadius,
        durationLabel: widget.durationLabel,
        priceLabel: widget.priceLabel,
        artistName: widget.artistName,
        artistSpecialization: widget.artistSpecialization,
        serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
        serviceIcon: widget.serviceIcon,
        leadingIconColor: widget.leadingIconColor,
        trailingIconColor: widget.trailingIconColor,
        artistImage: widget.artistImage,
        onDelete: () => removeService(i),
      );
    }
    update(); // Trigger UI update
  }

  void addService() {
    if (!isBundle.value && serviceWidgets.isNotEmpty) {
      Get.snackbar('Limit Reached', 'Single mode allows only one service');
      return;
    }

    final newIndex = serviceWidgets.length;
    serviceWidgets.add(
      CustomServiceSelectionContainer(
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
      ),
    );
  }

  void removeService(int index) {
    if (index >= 0 && index < serviceWidgets.length) {
      serviceWidgets.removeAt(index);
    }
  }

  int calculateTotalTime() {
    return serviceWidgets.length * 2;
  }

  int calculateTotalPrice() {
    return serviceWidgets.length * 40000;
  }
}