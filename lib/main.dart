import 'package:flutter/material.dart';
import 'package:glam1/screens/AboutMePage.dart';
import 'package:glam1/screens/AddServicesPage.dart';
import 'package:glam1/screens/AddressDetailsPage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/screens/LeadsPage.dart';
import 'package:glam1/screens/LoginPage.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/screens/VerifyEmailPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const AboutMePage(
              userEmail: '',
            ),
        '/leads': (context) => const LeadsPage(),
        '/calendar': (context) => const HomePage(),
        '/settings': (context) => const HomePage(),
      },
    );
  }
}
