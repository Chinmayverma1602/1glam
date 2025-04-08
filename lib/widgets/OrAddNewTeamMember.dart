import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class OrAddNewTeamMember extends StatelessWidget {
  const OrAddNewTeamMember({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Or Add New Team Member",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.021),

          // full name field
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Full Name', style: TextStyle(color: AppColors.secondaryText),),
                ),
                TextField(
                    decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.borderTextField, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.borderTextField, width: 1.5),
                  ),
                )),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020),

          // profession field
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Profession', style: TextStyle(color: AppColors.secondaryText),),
                ),
                DropdownButtonFormField<String>(
                  dropdownColor: AppColors.light,
                  decoration: InputDecoration(
                    labelText: "Select Profession",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.borderTextField, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.borderTextField, width: 1.5),
                    ),
                  ),
                  items: ["Makeup Artist", "Hair Stylist"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {},
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020),

          // phone number field
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01),
            child: Column(
              children: [
                 Align(
                  alignment: Alignment.topLeft,
                  child: Text('Phone Number', style: TextStyle(color: AppColors.secondaryText),),
                ),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.borderTextField, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.borderTextField, width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                 SizedBox(height: MediaQuery.of(context).size.height * 0.012),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
