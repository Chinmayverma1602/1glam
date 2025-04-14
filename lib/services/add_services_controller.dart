import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ServiceItem {
  final int id;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final SingleValueDropDownController serviceCategoryController;
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
  String? documentId;
  String? userEmail;

  ServiceItem(
      {required this.id,
      required this.titleController,
      required this.descriptionController,
      required this.serviceCategoryController,
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
      this.documentId,
      this.userEmail})
      : buttonBorderColor = buttonBorderColor.obs,
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
      'title': titleController.text,
      'description': descriptionController.text,
      'serviceCategory': serviceCategoryController.dropDownValue?.value ?? '',
      'hintText': hintText.value,
      'duration': durationController.text,
      'price': priceController.text,
      'artistName': artistNameController.text,
      'artistSpecialization': artistSpecializationController.text,
      'serviceType': serviceType.value,
      'serviceIcon': serviceIcon.value,
      'artistImage': artistImage.value,
      'isBundle': serviceType.value.contains('Bundle') ? true : false,
      'createdAt': FieldValue.serverTimestamp(),
      'user_email': userEmail
    };
  }

  factory ServiceItem.fromFirestore(DocumentSnapshot doc, int idCounter) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ServiceItem(
        id: idCounter,
        documentId: doc.id,
        titleController:
            TextEditingController(text: data['title'] ?? 'New Service'),
        descriptionController: TextEditingController(
            text: data['description'] ?? 'Service description'),
        serviceCategoryController: SingleValueDropDownController(
            data: DropDownValueModel(
                name: data['serviceCategory'] ?? 'Luxury',
                value: data['serviceCategory'] ?? 'Luxury')),
        buttonBorderColor: AppColors.hintText.withOpacity(0.4),
        borderColor: AppColors.hintText,
        hintText: data['hintText'] ?? 'Service description',
        borderRadius: 16,
        durationController:
            TextEditingController(text: data['duration'] ?? '2'),
        priceController: TextEditingController(text: data['price'] ?? '40,000'),
        artistNameController:
            TextEditingController(text: data['artistName'] ?? 'New Artist'),
        artistSpecializationController: TextEditingController(
            text: data['artistSpecialization'] ?? 'Specialist'),
        serviceType: data['serviceType'] ??
            (data['isBundle'] == true ? 'Bundle Service' : 'Mobile Service'),
        serviceIcon: data['serviceIcon'] ?? 'assets/images/f.svg',
        leadingIconColor: AppColors.primary,
        trailingIconColor: AppColors.primary,
        artistImage: data['artistImage'] ?? 'assets/images/img.svg',
        userEmail: 'user_email1@gmail.com');
  }
}

class AddServicesController extends GetxController {
  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String? email;

  // Mode toggle
  RxBool isBundle = true.obs;
  int _serviceIdCounter = 0;

  // Separate lists for bundle and single modes, now holding ServiceItem
  RxList<ServiceItem> bundleServiceWidgets = <ServiceItem>[].obs;
  RxList<ServiceItem> singleServiceWidget = <ServiceItem>[].obs;
  RxList<ServiceItem> tempbundleServiceWidgets = <ServiceItem>[].obs;
  RxList<ServiceItem> tempsingleServiceWidget = <ServiceItem>[].obs;

  // Computed property to get current service items based on mode
  RxList<ServiceItem> get serviceWidgets =>
      isBundle.value ? tempbundleServiceWidgets : tempsingleServiceWidget;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    // Load services from Firebase on initialization
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    fetchServices();
  }

  // Fetch services from Firebase
  Future<void> fetchServices() async {
  try {
    // Clear existing services
    bundleServiceWidgets.clear();
    singleServiceWidget.clear();
    _serviceIdCounter = 0;

    // First, get all documents to see what's there
    QuerySnapshot allSnapshot = await _firestore.collection('services').get();
    print('Total documents found: ${allSnapshot.docs.length}');
    
    // Debug: print each document's content
    for (var doc in allSnapshot.docs) {
      print('Document ID: ${doc.id}');
      print('Document data: ${doc.data()}');
    }
    
    // Now try the filtered query
    QuerySnapshot snapshot = await _firestore
        .collection('services')
        .where('user_email', isEqualTo: 'user_email1@gmail.com')
        .get();
    
    print('Filtered documents found: ${snapshot.docs.length}');

    // Process the filtered documents
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final isServiceBundle = data['isBundle'] == true;
      
      final serviceItem = ServiceItem.fromFirestore(doc, _serviceIdCounter++);
      
      if (isServiceBundle) {
        bundleServiceWidgets.add(serviceItem);
      } else {
        singleServiceWidget.add(serviceItem);
      }
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to load services: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    print('Error fetching services: $e');
  } finally {
    _isLoading.value = false;
  }
}

  // Toggle between Bundle and Single mode
  void toggleMode() {
    isBundle.value = !isBundle.value;
  }

  // Add a new service to the current mode
  void addService() {
    if (!isBundle.value && tempsingleServiceWidget.isNotEmpty) {
      return;
    }

    final serviceId = _serviceIdCounter++;

    final newServiceItem = ServiceItem(
        id: serviceId,
        titleController: TextEditingController(text: 'New Service'),
        descriptionController:
            TextEditingController(text: 'Service description'),
        serviceCategoryController: SingleValueDropDownController(
            data: DropDownValueModel(name: "Luxury", value: "Luxury")),
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
        userEmail: 'user_email1@gmail.com');

    if (isBundle.value) {
      tempbundleServiceWidgets.add(newServiceItem);
    } else {
      tempsingleServiceWidget.add(newServiceItem);
    }

    update(); // Trigger UI update
  }

  void removeServiceFromFirebase(int id) async {
    if (isBundle.value) {
      final index =
          tempbundleServiceWidgets.indexWhere((item) => item.id == id);
      if (index != -1) {
        // If service exists in Firestore, delete it
        final serviceItem = bundleServiceWidgets[index];
        if (serviceItem.documentId != null) {
          try {
            await _firestore
                .collection('services')
                .doc(serviceItem.documentId)
                .delete();
            Get.snackbar(
              'Success',
              'Service deleted from database',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to delete service: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            print('Error deleting service: $e');
            return; // Don't remove from local list if deletion failed
          }
        }

        // Dispose of controllers
        bundleServiceWidgets[index].titleController.dispose();
        bundleServiceWidgets[index].descriptionController.dispose();
        bundleServiceWidgets[index].durationController.dispose();
        bundleServiceWidgets[index].priceController.dispose();
        bundleServiceWidgets[index].artistNameController.dispose();
        bundleServiceWidgets[index].artistSpecializationController.dispose();

        // Remove from list
        bundleServiceWidgets.removeAt(index);
      }
    } else {
      final index = singleServiceWidget.indexWhere((item) => item.id == id);
      if (index != -1) {
        // If service exists in Firestore, delete it
        final serviceItem = singleServiceWidget[index];
        if (serviceItem.documentId != null) {
          try {
            await _firestore
                .collection('services')
                .doc(serviceItem.documentId)
                .delete();
            Get.snackbar(
              'Success',
              'Service deleted from database',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to delete service: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            print('Error deleting service: $e');
            return; // Don't remove from local list if deletion failed
          }
        }

        // Dispose of controllers
        singleServiceWidget[index].titleController.dispose();
        singleServiceWidget[index].descriptionController.dispose();
        singleServiceWidget[index].durationController.dispose();
        singleServiceWidget[index].priceController.dispose();
        singleServiceWidget[index].artistNameController.dispose();
        singleServiceWidget[index].artistSpecializationController.dispose();

        // Remove from list
        singleServiceWidget.removeAt(index);
      }
    }
  }

  // Remove service by ID
  void removeService(int id) async {
    if (isBundle.value) {
      final index =
          tempbundleServiceWidgets.indexWhere((item) => item.id == id);
      if (index != -1) {
        // Dispose of controllers
        bundleServiceWidgets[index].titleController.dispose();
        bundleServiceWidgets[index].descriptionController.dispose();
        bundleServiceWidgets[index].durationController.dispose();
        bundleServiceWidgets[index].priceController.dispose();
        bundleServiceWidgets[index].artistNameController.dispose();
        bundleServiceWidgets[index].artistSpecializationController.dispose();

        // Remove from list
        bundleServiceWidgets.removeAt(index);
      }
    } else {
      final index = singleServiceWidget.indexWhere((item) => item.id == id);
      if (index != -1) {
        // If service exists in Firestore, delete it
        final serviceItem = singleServiceWidget[index];
        if (serviceItem.documentId != null) {
          try {
            await _firestore
                .collection('services')
                .doc(serviceItem.documentId)
                .delete();
            Get.snackbar(
              'Success',
              'Service deleted from database',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to delete service: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            print('Error deleting service: $e');
            return; // Don't remove from local list if deletion failed
          }
        }

        // Dispose of controllers
        singleServiceWidget[index].titleController.dispose();
        singleServiceWidget[index].descriptionController.dispose();
        singleServiceWidget[index].durationController.dispose();
        singleServiceWidget[index].priceController.dispose();
        singleServiceWidget[index].artistNameController.dispose();
        singleServiceWidget[index].artistSpecializationController.dispose();

        // Remove from list
        singleServiceWidget.removeAt(index);
      }
    }
  }

  // Calculate total time based on the current mode
  int calculateTotalTime() {
    int totalTime = 0;
    for (var service in serviceWidgets) {
      totalTime += int.tryParse(service.durationController.text) ?? 0;
    }
    return totalTime > 0 ? totalTime : serviceWidgets.length * 2;
  }

  // Calculate total price based on the current mode
  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var service in serviceWidgets) {
      // Remove non-numeric characters
      String numericPrice =
          service.priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      totalPrice += int.tryParse(numericPrice) ?? 0;
    }
    return totalPrice > 0 ? totalPrice : serviceWidgets.length * 40000;
  }

  // Save services to Firebase
  Future<bool> saveServices() async {
    _isLoading.value = true;
    try {
      final batch = _firestore.batch();

      bundleServiceWidgets = tempbundleServiceWidgets;
      singleServiceWidget = tempsingleServiceWidget;

      final currentServices =
          isBundle.value ? bundleServiceWidgets : singleServiceWidget;

      for (var service in currentServices) {
        // Convert service to JSON format
        final serviceData = service.toJson();

        if (service.documentId != null) {
          // Update existing document
          batch.update(
              _firestore.collection('services').doc(service.documentId),
              serviceData);
        } else {
          // Create new document
          DocumentReference docRef = _firestore.collection('services').doc();
          batch.set(docRef, serviceData);
          service.documentId =
              docRef.id; // Store document ID for future reference
        }
      }

      // Commit batch
      await batch.commit();

      Get.snackbar(
        'Success',
        'Services saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save services: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving services: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
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
}

















  // // Save services to the backend API
  // Future<bool> saveServices() async {
  //   _isLoading.value = true;

  //   try {
  //     final String apiUrl =
  //         'http://1glam.local:8000//api/resource/userServices';
  //     final Map<String, String> headers = {
  //       'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
  //       'Content-Type': 'application/json',
  //     };

  //     // Get all services to be saved (both bundle and single)
  //     List<ServiceItem> allServices = [];

  //     // If bundle mode is active, save the bundle services
  //     if (isBundle.value && bundleServiceWidgets.isNotEmpty) {
  //       allServices.addAll(bundleServiceWidgets);
  //     }
  //     // If single mode is active, save the single service
  //     else if (!isBundle.value && singleServiceWidget.isNotEmpty) {
  //       allServices.addAll(singleServiceWidget);
  //     }

  //     // If no services to save, return error
  //     if (allServices.isEmpty) {
  //       _isLoading.value = false;
  //       return false;
  //     }

  //     // Save each service
  //     for (var serviceWidget in allServices) {
  //       // Extract info from service widget
  //       String serviceName = serviceWidget.titleController.text;
  //       double duration = double.parse(serviceWidget.durationController.text) *
  //           60; // Convert hours to minutes
  //       double price = double.parse(serviceWidget.priceController.text
  //           .replaceAll(',', '')); // Remove commas

  //       Map<String, dynamic> requestBody;
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       String selectedEmail = prefs.getString('user_email') ?? "";

  //       if (isBundle.value) {
  //         // For bundle services, we need to include the individual services
  //         List<ServiceItem> includedServices = [];

  //         // In this example, we're creating dummy included services for each bundle service
  //         // In a real app, you'd collect this data from the user

  //         includedServices.add(ServiceItem(
  //           id: 0,
  //           titleController: TextEditingController(text: 'New Service '),
  //           descriptionController:
  //               TextEditingController(text: 'Service description'),
  //           serviceCategory: 'Luxury',
  //           buttonBorderColor: AppColors.hintText.withOpacity(0.4),
  //           borderColor: AppColors.hintText,
  //           hintText: 'Service description',
  //           borderRadius: 16,
  //           durationController: TextEditingController(text: '2'),
  //           priceController: TextEditingController(text: '40,000'),
  //           artistNameController: TextEditingController(text: 'New Artist'),
  //           artistSpecializationController:
  //               TextEditingController(text: 'Specialist'),
  //           serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
  //           serviceIcon: 'assets/images/f.svg',
  //           leadingIconColor: AppColors.primary,
  //           trailingIconColor: AppColors.primary,
  //           artistImage: 'assets/images/img.svg',
  //         ));

  //         includedServices.add(ServiceItem(
  //           id: 0,
  //           titleController: TextEditingController(text: 'New Service '),
  //           descriptionController:
  //               TextEditingController(text: 'Service description'),
  //           serviceCategory: 'Luxury',
  //           buttonBorderColor: AppColors.hintText.withOpacity(0.4),
  //           borderColor: AppColors.hintText,
  //           hintText: 'Service description',
  //           borderRadius: 16,
  //           durationController: TextEditingController(text: '2'),
  //           priceController: TextEditingController(text: '40,000'),
  //           artistNameController: TextEditingController(text: 'New Artist'),
  //           artistSpecializationController:
  //               TextEditingController(text: 'Specialist'),
  //           serviceType: isBundle.value ? 'Bundle Service' : 'Mobile Service',
  //           serviceIcon: 'assets/images/f.svg',
  //           leadingIconColor: AppColors.primary,
  //           trailingIconColor: AppColors.primary,
  //           artistImage: 'assets/images/img.svg',
  //         ));

  //         // Create bundle service request body
  //         requestBody = {
  //           "user": selectedEmail,
  //           "service_name": serviceName,
  //           "bundle": true,
  //           "services_included":
  //               includedServices.map((item) => item.toJson()).toList(),
  //           "duration": duration,
  //           "price": price
  //         };
  //       } else {
  //         // Create single service request body
  //         requestBody = {
  //           "user": selectedEmail,
  //           "service_name": serviceName,
  //           "bundle": false,
  //           "price": price,
  //           "duration": duration
  //         };
  //       }

  //       // Send the request to the API
  //       final response = await http.post(
  //         Uri.parse(apiUrl),
  //         headers: headers,
  //         body: jsonEncode(requestBody),
  //       );

  //       // Check for success
  //       if (response.statusCode != 200) {
  //         print('API Error: ${response.body}');
  //         _isLoading.value = false;
  //         return false;
  //       }
  //     }

  //     _isLoading.value = false;
  //     return true;
  //   } catch (e) {
  //     print('Error saving services: $e');
  //     _isLoading.value = false;
  //     return false;
  //   }
  // }

