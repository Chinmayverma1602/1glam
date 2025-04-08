import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/OrAddNewTeamMember.dart';
import 'package:glam1/widgets/SelectExistingTeamMember.dart';

class AddTeamMembersPage extends StatelessWidget {
  const AddTeamMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),

        // appbar
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Add Team Members',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              // Select Existing Team Member
              SelectExistingTeamMember(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              // Add New Team Member
              OrAddNewTeamMember(),

              SizedBox(height: 24),

              // Add Team Member Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      // Do your action
                    },
                    child: Text(
                      "Add Team Member",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

