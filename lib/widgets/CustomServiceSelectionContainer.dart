import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomServiceSelectionContainer extends StatefulWidget {
  final int id;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final SingleValueDropDownController serviceCategoryController;
  final Color buttonBorderColor;
  final String hintText;
  final Color borderColor;
  final double borderRadius;
  final TextEditingController durationController;
  final TextEditingController priceController;
  final TextEditingController artistNameController;
  final TextEditingController artistSpecializationController;
  final String serviceType;
  final String serviceIcon;
  final Color textColor;
  final Color leadingIconColor;
  final Color trailingIconColor;
  final Color backgroundColor;
  final String artistImage;
  final VoidCallback onDelete;

  const CustomServiceSelectionContainer({
    Key? key,
    required this.id,
    required this.titleController,
    required this.descriptionController,
    required this.serviceCategoryController,
    required this.buttonBorderColor,
    required this.hintText,
    required this.borderColor,
    required this.borderRadius,
    required this.durationController,
    required this.priceController,
    required this.artistNameController,
    required this.artistSpecializationController,
    required this.serviceType,
    required this.serviceIcon,
    this.textColor = Colors.black,
    required this.leadingIconColor,
    required this.trailingIconColor,
    this.backgroundColor = Colors.white,
    required this.artistImage,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CustomServiceSelectionContainerState createState() =>
      _CustomServiceSelectionContainerState();
}

class _CustomServiceSelectionContainerState
    extends State<CustomServiceSelectionContainer> {
  bool isEditing = false;
  final FocusNode _titleFocusNode = FocusNode();

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.titleController,
                    focusNode: _titleFocusNode,
                    readOnly: !isEditing,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                          if (isEditing) {
                            _titleFocusNode.requestFocus();
                            widget.titleController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        widget.titleController.text.length));
                          } else {
                            _titleFocusNode.unfocus();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Service category dropdown
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              child: DropDownTextField(
                controller: widget.serviceCategoryController,
                clearOption: false,
                textFieldDecoration: InputDecoration(
                  hintText: "Select Service Category",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a service";
                  }
                  return null;
                },
                dropDownList: const [
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
            ),

            const SizedBox(height: 24),

            // Duration and price row
            Row(
              children: [
                Text(
                  "Duration",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 85),
                Text(
                  "Price",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextField(
                    controller: widget.durationController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      hintText: "Duration",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "hours",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: widget.priceController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      prefixText: "₹ ",
                      prefixStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                      hintText: "Price",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Artist section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Artist (Optional)",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  "Change",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SvgPicture.asset(
                      widget.artistImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.artistNameController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.artistSpecializationController.text,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Service type toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          widget.serviceIcon,
                          width: 20,
                          height: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.serviceType,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SwitcherButton(
                  value: true,
                  size: 30,
                  onChange: (value) {
                    // Add your switch toggle functionality here.
                  },
                  onColor: AppColors.primary,
                  offColor: Colors.grey.shade400,
                ),
              ],
            ),
          ],
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
