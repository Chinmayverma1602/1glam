import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AboutMePage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterDetailsPage extends StatefulWidget {
  const EnterDetailsPage({super.key});

  @override
  State<EnterDetailsPage> createState() => _EnterDetailsPageState();
}

class _EnterDetailsPageState extends State<EnterDetailsPage> {
  final List<Map<String, dynamic>> users = [
    {"business": "Nail Salon", "imageLocation": "assets/images/nailSalon.svg"},
    {
      "business": "Hairstylist",
      "imageLocation": "assets/images/hairStylist.svg"
    },
    {"business": "Makeup Artist", "imageLocation": "assets/images/makeup.svg"},
    {"business": "Other", "imageLocation": "assets/images/other.svg"},
  ];

  int? selectedIndex;
  String selectedBusiness = '';
  bool isLoading = false;
  String? selectedEmail = '';
  TextEditingController serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedEmail = prefs.getString('user_email') ?? "";
    });
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Your Own Service"),
          content: TextField(
            controller: serviceController,
            decoration: const InputDecoration(hintText: "Enter service name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (serviceController.text.trim().isNotEmpty) {
                  setState(() {
                    users.insert(users.length - 1, {
                      "business": serviceController.text.trim(),
                      "imageLocation": "assets/images/custom.svg",
                    });
                    selectedIndex = users.length - 2;
                    selectedBusiness = serviceController.text.trim();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Prevents overflow by respecting system UI areas
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Consistent horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(),
              const SizedBox(height: 20),
              const Text(
                "What's your business?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.title,
                ),
              ),
              const SizedBox(height: 20), // Added spacing after title
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16, // Increased spacing for better layout
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Padding inside GridView
                  children: List.generate(users.length, (index) {
                    bool isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        if (users[index]["business"] == "Other") {
                          _showAddServiceDialog();
                        } else {
                          setState(() {
                            selectedIndex = index;
                            selectedBusiness = users[index]["business"];
                          });
                        }
                      },
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Prevents unnecessary expansion
                        children: [
                          Container(
                            width: 120, // Reduced size to fit better
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.primary.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60, // Adjusted to fit container
                              backgroundColor: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              child: SvgPicture.asset(
                                users[index]["imageLocation"],
                                width: 80, // Controlled size of SVG
                                height: 80,
                                fit: BoxFit.none, // Ensures SVG fits properly
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            users[index]["business"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14), // Controlled text size
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20), // Spacing before button
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: "Proceed to enter my details",
                        color: AppColors.subtitle,
                        icon: null,
                        onPressed: () {
                          if (selectedIndex == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a business type"),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutMePage(
                                bussinessType: selectedBusiness,
                                selectedEmail: selectedEmail ?? "",
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16), // Bottom padding to avoid overlap
            ],
          ),
        ),
      ),
    );
  }
}
