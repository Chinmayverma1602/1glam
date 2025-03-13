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
  bool isLoading = false; // To show loading indicator
  String? selectedEmail = '';

  final String apiUrl = "http://1glam.local:8000/api/resource/loginUser";
  final Map<String, String> headers = {
    'Authorization': 'token eb6cdc62a0caeef:b4f7342a55e5049',
    'Content-Type': 'application/json',
  };

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('user_email');

    setState(() {
      selectedEmail = email;
    });
  }

  Future<void> _submitBusinessType() async {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a business type")),
      );
      return;
    }

    String selectedBusiness = users[selectedIndex!]["business"];
    Map<String, dynamic> requestBody = {
      "doctype": "loginUser",
      "user": selectedEmail, // Replace with actual user email if available
      "business_type": selectedBusiness,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("API Response: ${response.body}");

        // Navigate to the AboutMePage with response data
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutMePage()),
        );
      } else {
        print("Error: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit business type")),
        );
      }
    } catch (error) {
      print("Exception: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong!")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddServiceDialog() {
    TextEditingController serviceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Your Own Service"),
          content: TextField(
            controller: serviceController,
            decoration: InputDecoration(hintText: "Enter service name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
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
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Add"),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeader(),
            SizedBox(height: 20),
            Text(
              "What's your business?",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.title),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(users.length, (index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (users[index]["business"] == "Other") {
                        _showAddServiceDialog();
                      } else {
                        setState(() {
                          selectedIndex = index;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
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
                            radius: 72,
                            backgroundColor: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            child: SvgPicture.asset(
                              users[index]["imageLocation"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(users[index]["business"]),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: isLoading
                    ? CircularProgressIndicator() // Show loader when submitting
                    : CustomButton(
                        text: "Proceed to enter my details",
                        color: AppColors.subtitle,
                        icon: null,
                        onPressed: _submitBusinessType,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
