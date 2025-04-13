import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../services/add_services_controller.dart';

class CustomServiceSelectionContainer extends StatefulWidget {
  final int id;
  final String title;
  final String serviceCategory;
  final dynamic serviceCategoryDropDown;
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
    required this.id, // id to track it
    this.serviceCategoryDropDown = "Hair Styling",
  }) : super(key: key);

  @override
  _CustomServiceSelectionContainerState createState() =>
      _CustomServiceSelectionContainerState();
}

class _CustomServiceSelectionContainerState
    extends State<CustomServiceSelectionContainer> {
  late SingleValueDropDownController serviceController;
  TextEditingController titleController = TextEditingController();
  final AddServicesController addServicesController = Get.find<AddServicesController>();
  bool isEditing = false; // Track editing state
  final FocusNode _titleFocusNode = FocusNode(); // Focus node for title field
  
  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    serviceController = SingleValueDropDownController(
        data: DropDownValueModel(name: "Hairstyling", value: "Hairstyling"));
  }

  @override
  void dispose() {
    serviceController.dispose();
    titleController.dispose();
    _titleFocusNode.dispose(); // Dispose focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // for debug
        print("Tapped card with ID: ${widget.id}");
      },
      child: Padding(
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
                        readOnly:
                            !isEditing, // Make it read-only unless in edit mode
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
                      icon: Icon(isEditing ? Icons.check : Icons.edit,
                          size: 18,
                          color: isEditing
                              ? AppColors.primary
                              : const Color.fromARGB(255, 204, 103, 218)),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing; // Toggle editing state
      
                          if (isEditing) {
                            // When starting edit (edit icon pressed)
                            // Request focus on the text field
      
                            _titleFocusNode.requestFocus();
                            // Position cursor at the end of text
                            titleController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: titleController.text.length));
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
                  controller: serviceController,
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
                    DropDownValueModel(
                        name: "Hair Coloring", value: "Hair Coloring"),
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
                    Text("  Duration",
                        style: TextStyle(color: AppColors.secondaryText)),
                    const SizedBox(width: 85),
                    Text("Price",
                        style: TextStyle(color: AppColors.secondaryText)),
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
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
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
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.4)),
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
                    Text(widget.artistLabel,
                        style: TextStyle(color: widget.textColor)),
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
                          style:
                              TextStyle(color: widget.textColor.withOpacity(0.7)),
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
                        Text(widget.serviceType,
                            style: TextStyle(color: widget.textColor)),
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
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:glam1/constants/AppColors.dart';
// import 'package:glam1/services/add_services_controller.dart';

// class CustomServiceSelectionContainer extends StatefulWidget {
//   final String title;
//   final String serviceCategory;
//   final Color buttonBorderColor;
//   final Color borderColor;
//   final String hintText;
//   final double borderRadius;
//   final String durationLabel;
//   final String priceLabel;
//   final String artistName;
//   final String artistSpecialization;
//   final String serviceType;
//   final String serviceIcon;
//   final Color leadingIconColor;
//   final Color trailingIconColor;
//   final String artistImage;
//   final VoidCallback onDelete;

//   const CustomServiceSelectionContainer({
//     super.key,
//     required this.title,
//     required this.serviceCategory,
//     required this.buttonBorderColor,
//     required this.borderColor,
//     required this.hintText,
//     required this.borderRadius,
//     required this.durationLabel,
//     required this.priceLabel,
//     required this.artistName,
//     required this.artistSpecialization,
//     required this.serviceType,
//     required this.serviceIcon,
//     required this.leadingIconColor,
//     required this.trailingIconColor,
//     required this.artistImage,
//     required this.onDelete,
//   });

//   @override
//   State<CustomServiceSelectionContainer> createState() =>
//       _CustomServiceSelectionContainerState();
// }

// class _CustomServiceSelectionContainerState
//     extends State<CustomServiceSelectionContainer> {
//   bool isSwitched = true;
//   bool isEditing = false;
//   final TextEditingController titleController =
//       TextEditingController();
//   GetxController addServicesController = Get.put(AddServicesController());

//   final FocusNode _titleFocusNode = FocusNode();

//   final TextEditingController durationController =
//       TextEditingController(text: '2');
//   final TextEditingController priceController =
//       TextEditingController(text: '40000');
//   String? selectedService;

//   @override
//   void dispose() {
//     durationController.dispose();
//     priceController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     titleController.text = widget.title;

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color.fromARGB(95, 234, 204, 238),
//       elevation: 0,
//       shadowColor: AppColors.travelFeeTextFields,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // HEADER
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: titleController,
//                     focusNode: _titleFocusNode,
//                     readOnly: !isEditing,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           isEditing = !isEditing;
//                           if (isEditing) {
//                             _titleFocusNode.requestFocus();
//                             titleController.selection =
//                                 TextSelection.fromPosition(
//                               TextPosition(offset: titleController.text.length),
//                             );
//                           } else {
//                             _titleFocusNode.unfocus();
//                           }
//                         });
//                       },
//                       icon: Icon(
//                         isEditing ? Icons.check : Icons.edit,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                     )
//                   ],
//                 )
//               ],
//             ),

//             const SizedBox(height: 10),

//             // SERVICE DROPDOWN
//             DropdownButtonFormField<String>(
//               value: selectedService,
//               decoration: const InputDecoration(labelText: 'Select Service'),
//               items: const [
//                 DropdownMenuItem(
//                     value: 'Hairstyling', child: Text('Hairstyling')),
//                 DropdownMenuItem(value: 'Makeup', child: Text('Makeup')),
//                 DropdownMenuItem(value: 'Facial', child: Text('Facial')),
//                 DropdownMenuItem(
//                     value: 'Hair Coloring', child: Text('Hair Coloring')),
//                 DropdownMenuItem(value: 'Nail Art', child: Text('Nail Art')),
//               ],
//               onChanged: (val) {
//                 setState(() {
//                   selectedService = val;
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             // DURATION AND PRICE FIELDS
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: durationController,
//                     decoration: const InputDecoration(
//                       hintText: 'Duration (hours)',
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.01),
//                 Text("hours", style: TextStyle(color: AppColors.text)),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.04),
//                 Expanded(
//                   child: TextFormField(
//                     controller: priceController,
//                     decoration: const InputDecoration(
//                       hintText: 'Price',
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // ARTIST
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("New Artist",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text("Specialist", style: TextStyle(color: Colors.grey))
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text("Change",
//                       style: TextStyle(color: AppColors.primary)),
//                 )
//               ],
//             ),

//             const Divider(),

//             // SWITCH
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Bundle Service"),
//                 Switch(
//                   value: isSwitched,
//                   onChanged: (val) {
//                     setState(() {
//                       isSwitched = val;
//                     });
//                   },
//                   activeColor: AppColors.primary,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
