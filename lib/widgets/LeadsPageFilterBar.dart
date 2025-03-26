
import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class LeadsPageFilterBar extends StatefulWidget {
  final void Function(String) onFilterSelected; 
  final List<String> filters;
  final String selectedFilter;

  const LeadsPageFilterBar({
    super.key, 
    required this.onFilterSelected, 
    required this.filters, 
    required this.selectedFilter,
  });

  @override
  State<LeadsPageFilterBar> createState() => _LeadsPageFilterBarState();
}

class _LeadsPageFilterBarState extends State<LeadsPageFilterBar> {
  late String currentFilter; // Store the selected filter in state

  @override
  void initState() {
    super.initState();
    currentFilter = widget.selectedFilter; // Initialize with the passed filter
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          String filter = widget.filters[index];
          bool isSelected = filter == currentFilter; // Compare with local state

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentFilter = filter; // Update local state
                });
                widget.onFilterSelected(filter); // Pass the selected filter
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.light,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 16,
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
