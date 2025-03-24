import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void showNotesBottomSheet(BuildContext context) {
  final TextEditingController notesController = TextEditingController();
  List<File> selectedImages = [];

  void pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImages.add(File(image.path));
      (context as Element).markNeedsBuild(); // Refresh UI
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),

                // Notes Text Field
                TextField(
                  controller: notesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Write your notes here...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // Display Selected Images
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var image in selectedImages)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages.remove(image);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Icon(Icons.close, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Add Image Button
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text("Take a Photo"),
                                  onTap: () {
                                    pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text("Choose from Gallery"),
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Save & Cancel Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Handle saving note & images
                          Navigator.pop(context);
                        },
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
