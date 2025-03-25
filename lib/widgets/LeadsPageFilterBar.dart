import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class LeadsPageFilterBar extends StatefulWidget {

  final VoidCallback onFilterSelected;
  const LeadsPageFilterBar({super.key, required this.onFilterSelected});

  @override
  State<LeadsPageFilterBar> createState() => _LeadsPageFilterBarState();
}

class _LeadsPageFilterBarState extends State<LeadsPageFilterBar> {

  String selectedFilter = "All Leads"; 

  final List<String> filters = [
    "All Leads", "New", "In Progress", "Confirmed",
    "Inquiry Recieved", "Qualified Lead", "Accepted Leads"
  ]; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          String filter = filters[index];
          bool isSelected = filter == selectedFilter;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
                widget.onFilterSelected();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.light,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? AppColors.light : AppColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
