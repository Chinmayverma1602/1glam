import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomServiceSelectionContainer extends StatefulWidget {
  final String title;
  final String serviceCategory;
  final Color buttonBorderColor;
  final String hintText;
  final Color borderColor;
  final double borderRadius;
  final String durationLabel;
  final String priceLabel;
  final String artistLabel;
  final String changeLabel;
  final String artistName;
  final String artistSpecialization;
  final String serviceType;
  final String serviceIcon;
  final Color textColor;
  final Color leadingIconColor;
  final Color trailingIconColor;
  final Color backgroundColor;
  final String artistImage;
  final VoidCallback onDelete; // Callback function to remove widget

  const CustomServiceSelectionContainer({
    Key? key,
    required this.title,
    required this.serviceCategory,
    required this.buttonBorderColor,
    required this.hintText,
    required this.borderColor,
    required this.borderRadius,
    required this.durationLabel,
    required this.priceLabel,
    this.artistLabel = "Select Artist (Optional)",
    this.changeLabel = "Change",
    required this.artistName,
    required this.artistSpecialization,
    required this.serviceType,
    required this.serviceIcon,
    this.textColor = Colors.black,
    this.leadingIconColor = Colors.black,
    this.trailingIconColor = Colors.black,
    this.backgroundColor = Colors.white,
    required this.artistImage,
    required this.onDelete, // Deleting function
  }) : super(key: key);

  @override
  _CustomServiceSelectionContainerState createState() =>
      _CustomServiceSelectionContainerState();
}

class _CustomServiceSelectionContainerState extends State<CustomServiceSelectionContainer> {
  late SingleValueDropDownController _serviceController;
  TextEditingController titleController = TextEditingController();
  bool isEditing = false; // Track editing state
  final FocusNode _titleFocusNode = FocusNode(); // Focus node for title field

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    _serviceController = SingleValueDropDownController(data: DropDownValueModel(name: "Hairstyling", value: "Hairstyling"));
  }

  @override
  void dispose() {
    _serviceController.dispose();
    titleController.dispose();
    _titleFocusNode.dispose(); // Dispose focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Adds bottom padding
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with title, edit icon, and delete icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      focusNode: _titleFocusNode, // Assign focus node
                      readOnly: !isEditing, // Make it read-only unless in edit mode
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.check : Icons.edit, 
                      size: 18, 
                      color: isEditing ? AppColors.primary : Colors.grey
                    ),
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing; // Toggle editing state
                        
                        if (isEditing) {
                          // When starting edit (edit icon pressed)
                          // Request focus on the text field
                          _titleFocusNode.requestFocus();
                          // Position cursor at the end of text
                          titleController.selection = TextSelection.fromPosition(
                              TextPosition(offset: titleController.text.length));
                        } else {
                          // When finishing edit (check icon pressed)
                          _titleFocusNode.unfocus();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete, // Calls function to delete
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Dropdown TextField for service selection
              DropDownTextField(
                controller: _serviceController,
                clearOption: false,
                textFieldDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  hintText: "Select Service",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a service";
                  }
                  return null;
                },
                dropDownList: [
                  DropDownValueModel(name: "Hairstyling", value: "Hairstyling"),
                  DropDownValueModel(name: "Makeup", value: "Makeup"),
                  DropDownValueModel(name: "Facial", value: "Facial"),
                  DropDownValueModel(name: "Massage", value: "Massage"),
                  DropDownValueModel(name: "Hair Coloring", value: "Hair Coloring"),
                  DropDownValueModel(name: "Nail Art", value: "Nail Art"),
                ],
                onChanged: (val) {
                  // Handle on change
                },
              ),
              const SizedBox(height: 16.0),
              const Divider(),

              // Duration and Price fields
              Row(
                children: [
                  Text("  Duration", style: TextStyle(color: AppColors.secondaryText)),
                  const SizedBox(width: 85),
                  Text("Price", style: TextStyle(color: AppColors.secondaryText)),
                ],
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.durationLabel,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text("hours", style: TextStyle(color: widget.textColor)),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.priceLabel,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Artist selection row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.artistLabel, style: TextStyle(color: widget.textColor)),
                  Text(
                    widget.changeLabel,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  SvgPicture.asset(widget.artistImage, width: 50, height: 50),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artistName,
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.artistSpecialization,
                        style: TextStyle(color: widget.textColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              // Service Type row with switcher button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        widget.serviceIcon,
                        width: 24,
                        height: 24,
                        color: widget.leadingIconColor,
                      ),
                      const SizedBox(width: 8.0),
                      Text(widget.serviceType, style: TextStyle(color: widget.textColor)),
                    ],
                  ),
                  SwitcherButton(
                    value: true,
                    onChange: (value) {
                      // Add your switch toggle functionality here.
                    },
                    onColor: AppColors.primary,
                    offColor: AppColors.hintText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}