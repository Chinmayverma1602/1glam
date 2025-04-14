import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/firebase_options.dart';
import 'package:glam1/screens/ConfirmBooking.dart';
import 'package:glam1/screens/EditBookingScreen.dart';
import 'package:glam1/screens/GeneralSettingScreen.dart';
import 'package:glam1/screens/LoginScreen.dart';
import 'package:glam1/screens/NewEstimatePage.dart';
import 'package:glam1/screens/NewInvoice.dart';
import 'package:glam1/screens/PaymentSettingsScreen.dart';
import 'package:glam1/screens/SettingsScreen.dart';
import 'package:glam1/screens/ShowInvoicePage.dart';
import 'package:glam1/screens/TeamManagement.dart';
import 'package:glam1/screens/TravellingInfo.dart';
import 'package:glam1/screens/PreviewPage.dart';
import 'package:glam1/services/BookingController.dart';
import 'package:glam1/services/leads_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glam1/screens/AboutMePage.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/screens/BundleServicePage.dart';
import 'package:glam1/screens/EnterDetailsPage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/LeadsPage.dart';
import 'package:glam1/screens/LoginPage.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';
import 'package:glam1/services/add_services_controller.dart';
import 'package:glam1/screens/CalenderScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(BookingController());
  String initialRoute = await getInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));

}

Future<String> getInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email') != null ? '/home' : '/services';
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controllers
    Get.put(AddServicesController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/home', page: () => HomePage(lead: sampleLeads,)),
        GetPage(name: '/leads', page: () => const LeadsPage()),
        // GetPage(name: '/settings', page: () => const HomePage()),
        GetPage(name: '/about', page: () => const AboutMePage()),
        GetPage(name: '/address', page: () => const AddressDetailsPage()),
        // GetPage(name: '/bundle', page: () => const BundleServicePage()),
        GetPage(name: '/details', page: () => const EnterDetailsPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/loginScreen', page: () => const LoginScreen()),
        GetPage(name: '/services', page: () => const ServicesInfoPage()),
        GetPage(name: '/verify', page: () => const VerifyEmailPage()),
        GetPage(name: '/travelInfo', page: () => const TravellingInfoPage(fullAddress: "",)),
        GetPage(name: '/calender', page: () => const CalenderPage()),
        GetPage(
            name: '/PreviewPage', page: () => const EstimatePreviewScreen()),
        GetPage(name: '/EstimatePage', page: () => const EstimateScreen()),
        GetPage(name: '/newInvoicePgae', page: () => const NewInvoicePage()),
        GetPage(name: '/ShowInvoice', page: () => const InvoiceScreen()),
        GetPage(
            name: '/BookingConfirmed',
            page: () => const BookingConfirmationScreen()),
        GetPage(name: '/SettingsScreen', page: () => const SettingsScreen()),
        GetPage(
            name: '/GeneralSettings',
            page: () => const GeneralSettingsScreen()),
        GetPage(
            name: '/PaymentSettings',
            page: () => const PaymentSettingsScreen()),
        GetPage(
            name: '/TeamMembersScreen', page: () => const TeamMembersScreen()),
      ],
    );
  }
}
