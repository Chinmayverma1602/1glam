import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:glam1/widgets/CustomLoadingAnimation.dart';

class ImageSelectionRow extends StatefulWidget {
  @override
  _ImageSelectionRowState createState() => _ImageSelectionRowState();
}

class _ImageSelectionRowState extends State<ImageSelectionRow> {
  File? image1;
  File? image2;
  bool isLoading1 = false;
  bool isLoading2 = false;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(int cardIndex) async {
    final ImageSource? source = await _showImageSourceDialog();

    if (source == null) return; // If user cancels the selection

    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (cardIndex == 1) {
          isLoading1 = true;
        } else {
          isLoading2 = true;
        }
      });

      await Future.delayed(Duration(seconds: 1)); // Simulate loading time

      setState(() {
        if (cardIndex == 1) {
          image1 = File(pickedFile.path);
          isLoading1 = false;
        } else {
          image2 = File(pickedFile.path);
          isLoading2 = false;
        }
      });
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text("Gallery"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildImageCard(1, image1, isLoading1),
        _buildImageCard(2, image2, isLoading2),
      ],
    );
  }

  Widget _buildImageCard(int cardIndex, File? image, bool isLoading) {
    return GestureDetector(
      onTap: () => _pickImage(cardIndex),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 30, // Set desired width
                  height: 30, // Set desired height
                  child: CustomLoadingAnimations.waveDots(
                    size: 20,
                  ),
                )
              : image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(image,
                          width: 50, height: 50, fit: BoxFit.cover),
                    )
                  : Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
        ),
      ),
    );
  }
}
