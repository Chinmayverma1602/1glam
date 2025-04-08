import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class SelectExistingTeamMember extends StatelessWidget {
  const SelectExistingTeamMember({
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.003),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Existing Team Member",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.021),
          _teamMemberTile(
              "Sarah Johnson", "Makeup Artist", "https://randomuser.me/api/portraits/women/44.jpg"),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.021),
          _teamMemberTile(
              "Michael Lee", "Hair Stylist", "https://randomuser.me/api/portraits/men/32.jpg"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),

        ],
      ),
    );
  }
}

Widget _teamMemberTile(String name, String role, String imageUrl) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: AppColors.borderTextField,
        width: 1,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
        Radio(
          value: name,
          groupValue: "", // your selected logic here
          onChanged: (val) {},
        )
      ],
    ),
  );
}