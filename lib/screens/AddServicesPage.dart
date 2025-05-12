import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/widgets/CustomToast.dart';
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
        const Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CustomLoadingAnimation(
              size: 50,
              text: "Saving service...",
              type: LoadingAnimationType.staggeredDotsWave,
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Save services to Firebase
      bool success = await controller.saveServices();

      // Close loading dialog
      Get.back();

      if (success) {
        // Show success message using our custom toast
        CustomToast.showSuccess(
          Get.context!,
          message: 'Your service has been saved',
        );

        // Navigate to the services info page after a slight delay
        Future.delayed(Duration(milliseconds: 300), () {
          Get.to(() => ServicesInfoPage());
        });
      } else {
        // Show error message using our custom toast
        CustomToast.showError(
          Get.context!,
          message: 'Failed to save service',
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Header
                    CustomHeader(),

                    const SizedBox(height: 24),

                    // Mode toggle buttons
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!controller.isBundle.value) {
                                  controller.toggleMode();
                                }
                              },
                              child: Obx(
                                () => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: controller.isBundle.value
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      "Bundle",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: controller.isBundle.value
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.isBundle.value) {
                                  controller.toggleMode();
                                }
                              },
                              child: Obx(
                                () => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: !controller.isBundle.value
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      "Single",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: !controller.isBundle.value
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Summary card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Obx(() => Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total time",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (controller.isRefreshing.value)
                                          SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${controller.totalTime.value} hours",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Total price",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          if (controller.isRefreshing.value)
                                            SizedBox(
                                              height: 12,
                                              width: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹ ${controller.totalPrice.value}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),

                    const SizedBox(height: 24),

                    // Section title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.isBundle.value
                              ? "Bundle Services"
                              : "Service Information",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${controller.serviceWidgets.length} ${controller.isBundle.value ? 'services' : 'service'}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Services list - shows either bundle or single services
                    Column(
                      children: List.generate(controller.serviceWidgets.length,
                          (index) {
                        final serviceItem = controller
                            .serviceWidgets[index]; // Get the ServiceItem
                        return Container(
                          key: ValueKey(
                              serviceItem.id), // 🔥 THIS LINE IS IMPORTANT
                          margin: const EdgeInsets.only(bottom: 16),
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
                            isUpdating: serviceItem.isUpdating,
                            onDelete: () =>
                                controller.removeService(serviceItem.id),
                            onServiceTypeChange: (newType) {
                              serviceItem.serviceType.value = newType;
                              controller.update();
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Add Another Service button (only for bundles or empty single)
                    Obx(() {
                      final isSingle = !controller.isBundle.value;
                      final servicesCount = controller.serviceWidgets.length;

                      // If single mode and already one service added — don't show button
                      if (isSingle && servicesCount >= 1)
                        return const SizedBox.shrink();

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton.icon(
                          onPressed: controller.addService,
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          label: Text(
                            "Add Another Service",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Save button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          // Check if there are services to save
                          if (controller.serviceWidgets.isEmpty) {
                            CustomToast.showWarning(
                              Get.context!,
                              message:
                                  'Please add at least one service before saving',
                            );
                            return;
                          }
                          _saveServices();
                        },
                        child: Text(
                          "Save Service",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
