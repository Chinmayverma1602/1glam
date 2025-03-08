import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({Key? key}) : super(key: key);

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  bool isBundle = false;
  List<CustomServiceSelectionContainer> serviceWidgets = [];
  
  void _toggleMode() {
  setState(() {
    isBundle = !isBundle;

    // If switching to single mode and multiple services exist, keep only the first one
    if (!isBundle && serviceWidgets.length > 1) {
      final firstService = serviceWidgets.first;
      serviceWidgets.clear();
      serviceWidgets.add(firstService);

      // Show message to user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Switched to Single mode: extra services removed')),
        );
      });
    } 

    // If switching to bundle mode and there's no service, add a default one
    if (isBundle && serviceWidgets.isEmpty) {
      _addService();
    }

    // Update service types
    _updateServiceTypes();
  });
}

  void _updateServiceTypes() {
    setState(() {
      // Rebuild the service widgets with updated service types
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
          serviceType: isBundle ? 'Bundle Service' : 'Mobile Service',
          serviceIcon: widget.serviceIcon,
          leadingIconColor: widget.leadingIconColor,
          trailingIconColor: widget.trailingIconColor,
          artistImage: widget.artistImage,
          onDelete: () => _removeService(i),
        );
      }
    });
  }

  void _addService() {
    if (!isBundle && serviceWidgets.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Single mode allows only one service')),
      );
      return;
    }

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
          serviceType: isBundle ? 'Bundle Service' : 'Mobile Service',
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

  int _calculateTotalTime() {
    return serviceWidgets.length * 2;
  }

  int _calculateTotalPrice() {
    return serviceWidgets.length * 40000;
  }

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
              // Mode toggle buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isBundle) {
                        setState(() {
                          isBundle = true;
                          // Clear existing services and add a default one
                          serviceWidgets.clear();
                          _addService();
                        });
                      }
                    },
                    child: CustomButton2(
                      fillColor: isBundle ? AppColors.primary.withOpacity(0.2) : Colors.white,
                      text: "Bundle",
                      borderColor: isBundle ? AppColors.primary : Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isBundle) {
                        setState(() {
                          isBundle = false;
                          // If multiple services exist, keep only the first one
                          if (serviceWidgets.length > 1) {
                            final firstService = serviceWidgets.first;
                            serviceWidgets.clear();
                            serviceWidgets.add(firstService);
                            
                            // Show a message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Switched to Single mode: extra services removed')),
                            );
                          } else if (serviceWidgets.isEmpty) {
                            _addService();
                          }
                          // Update service types
                          _updateServiceTypes();
                        });
                      }
                    },
                    child: CustomButton2(
                      fillColor: !isBundle ? AppColors.primary.withOpacity(0.2) : Colors.white,
                      text: "Single",
                      borderColor: !isBundle ? AppColors.primary : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text("Total time:", style: TextStyle(color: AppColors.hintText)),
                  const SizedBox(width: 15),
                  Text("${_calculateTotalTime()} hours"),
                  const Spacer(),
                  const Text("Total price:", style: TextStyle(color: AppColors.hintText)),
                  const SizedBox(width: 15),
                  Text("${_calculateTotalPrice()}"),
                ],
              ),
              const SizedBox(height: 16.0),
              // Services list with tap-to-toggle functionality
              Column(
                children: List.generate(serviceWidgets.length, (index) {
                  final widget = serviceWidgets[index];
                  return GestureDetector(
                    onTap: _toggleMode, // Toggle mode on tap
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: CustomServiceSelectionContainer(
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
                        serviceType: isBundle ? 'Bundle Service' : 'Mobile Service',
                        serviceIcon: widget.serviceIcon,
                        leadingIconColor: widget.leadingIconColor,
                        trailingIconColor: widget.trailingIconColor,
                        artistImage: widget.artistImage,
                        onDelete: () => _removeService(index),
                      ),
                    ),
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
              const SizedBox(height: 16),
              CustomButton(
                text: "Save Service",
                color: AppColors.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}