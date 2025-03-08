import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/SIngleServiceScreen.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';

import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

class BundleServicePage extends StatefulWidget {
  const BundleServicePage({Key? key}) : super(key: key);

  @override
  State<BundleServicePage> createState() => _BundleServicePageState();
}

class _BundleServicePageState extends State<BundleServicePage> {
  List<CustomServiceSelectionContainer> serviceWidgets = [];

  void _addService() {
    setState(() {
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
          serviceType: 'Bundle Service',
          serviceIcon: 'assets/images/f.svg',
          leadingIconColor: AppColors.primary,
          trailingIconColor: AppColors.primary,
          artistImage: 'assets/images/img.svg',
          onDelete: () => _removeService(newIndex),
        ),
      );
    });
  }

  void _removeService(int index) {
    if (index >= 0 && index < serviceWidgets.length) {
      setState(() {
        serviceWidgets.removeAt(index);
      });
    }
  }

  int _calculateTotalTime() => serviceWidgets.length * 2;
  int _calculateTotalPrice() => serviceWidgets.length * 40000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text("Add Service"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton2(
                              text: "Bundle",
                              borderColor: Colors.transparent,
                              fillColor: AppColors.primary,
                              textColor: AppColors.title,
                              textSize: 14,
                              isBold: true,
                            ),
                            CustomButton2(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleServicePage()));
                              },
                              text: "Single",
                              textColor: AppColors.hintText,
                              fillColor: Colors.grey.withOpacity(0.2),
                              isBold: true,
                              borderColor: Colors.transparent,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Total time:",
                                style: TextStyle(color: AppColors.hintText)),
                            const SizedBox(width: 15),
                            Text("${_calculateTotalTime()} hours"),
                            const Spacer(),
                            const Text("Total price:",
                                style: TextStyle(color: AppColors.hintText)),
                            const SizedBox(width: 15),
                            Text("${_calculateTotalPrice()}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: List.generate(serviceWidgets.length, (index) {
                  final widget = serviceWidgets[index];
                  return CustomServiceSelectionContainer(
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
                    serviceType: 'Bundle Service',
                    serviceIcon: widget.serviceIcon,
                    leadingIconColor: widget.leadingIconColor,
                    trailingIconColor: widget.trailingIconColor,
                    artistImage: widget.artistImage,
                    onDelete: () => _removeService(index),
                  );
                }),
              ),
              const SizedBox(height: 16),
              CustomButton(
                icon: Icons.add,
                text: "Add Another Service",
                color: Colors.transparent,
                onPressed: _addService,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                border: true,
                borderThickness: 0.4,
              ),
              if (serviceWidgets.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: "Save Service",
                  color: AppColors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServicesInfoPage()),
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
