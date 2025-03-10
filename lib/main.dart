import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/screens/AboutMePage.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/screens/BundleServicePage.dart';
import 'package:glam1/screens/EnterDetailsPage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/LeadsPage.dart';
import 'package:glam1/screens/LoginPage.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/screens/TravellingInfo.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/services/add_services_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controllers
    Get.put(AddServicesController()); // Register the controller

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const LoginPage()),
        GetPage(name: '/leads', page: () => const LeadsPage()),
        GetPage(name: '/calendar', page: () => const HomePage()),
        GetPage(name: '/settings', page: () => const HomePage()),
        // Add other pages as needed
        GetPage(name: '/about', page: () => const AboutMePage()),
        GetPage(name: '/address', page: () => const AddressDetailsPage()),
        GetPage(name: '/bundle', page: () => const BundleServicePage()),
        GetPage(name: '/details', page: () => const EnterDetailsPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/services', page: () => const ServicesInfoPage()),

        GetPage(name: '/verify', page: () => const VerifyEmailPage()),
      ],
    );
  }
}
