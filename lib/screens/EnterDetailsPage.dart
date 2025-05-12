import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/AboutMePage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';
import 'package:glam1/widgets/CustomToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterDetailsPage extends StatefulWidget {
  const EnterDetailsPage({super.key});

  @override
  State<EnterDetailsPage> createState() => _EnterDetailsPageState();
}

class _EnterDetailsPageState extends State<EnterDetailsPage> {
  final List<Map<String, dynamic>> users = [
    {"business": "Nail Salon", "icon": Icons.spa, "isSelected": true},
    {"business": "Hairstylist", "icon": Icons.content_cut, "isSelected": true},
    {"business": "Makeup Artist", "icon": Icons.face, "isSelected": true},
    {
      "business": "Other",
      "icon": Icons.add_circle_outline,
      "isSelected": false
    },
  ];

  bool isLoading = false;
  String? selectedEmail = '';
  TextEditingController serviceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    serviceController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Add Your Own Service",
            style: TextStyle(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: serviceController,
              decoration: InputDecoration(
                hintText: "Enter service name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a service name";
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    users.insert(users.length - 1, {
                      "business": serviceController.text.trim(),
                      "icon": Icons.star,
                      "isSelected": true
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: List.generate(users.length, (index) {
                    bool isSelected = users[index]["isSelected"] as bool;
                    return GestureDetector(
                      onTap: () {
                        if (users[index]["business"] == "Other") {
                          _showAddServiceDialog();
                        } else {
                          setState(() {
                            users[index]["isSelected"] = !isSelected;
                          });
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 120,
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
                              radius: 60,
                              backgroundColor: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              child: Icon(
                                users[index]["icon"] as IconData,
                                size: 40,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            users[index]["business"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.title,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: isLoading
                    ? const CustomLoadingAnimation(
                        size: 40,
                        type: LoadingAnimationType.staggeredDotsWave,
                        showText: false,
                      )
                    : CustomButton(
                        text: "Proceed to enter my details",
                        color: AppColors.subtitle,
                        icon: null,
                        onPressed: () {
                          List<String> selectedServices = users
                              .where((user) => user["isSelected"] as bool)
                              .map((user) => user["business"] as String)
                              .toList();

                          if (selectedServices.isEmpty) {
                            CustomToast.showWarning(
                              context,
                              message:
                                  "Please select at least one business type",
                            );
                            return;
                          }
                          Get.toNamed('/about', arguments: {
                            'bussinessType': selectedServices.join(", "),
                            'selectedEmail': selectedEmail ?? "",
                          });
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
