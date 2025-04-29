import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';

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
      height: 40,
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
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.light,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color:
                        isSelected ? AppColors.light : AppColors.secondaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
