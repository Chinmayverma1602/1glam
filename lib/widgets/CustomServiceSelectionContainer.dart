import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomButton2.dart';

class CustomServiceSelectionContainer extends StatelessWidget {
  final String title;
  final IconData deleteIcon;
  final String serviceCategory;
  final Color buttonBorderColor;
  final String trailingImage;
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
  final IconData serviceIcon;
  final IconData mobileServiceIcon;
  final Color textColor;
   final Color leadingIconColor;
    final Color trailingIconColor;
  final Color backgroundColor;
  final double containerHeight;


  const CustomServiceSelectionContainer({
    Key? key,
    required this.title ,
    this.deleteIcon = Icons.delete,
    required this.serviceCategory,
    required this.buttonBorderColor,
    this.trailingImage = 'assets/images/i.svg',
    required this.hintText ,
    required this.borderColor,
    required this.borderRadius,
    required this.durationLabel,
    required this.priceLabel ,
    this.artistLabel = "Select Artist (Optional)",
    this.changeLabel = "Change",
    required this.artistName ,
    required this.artistSpecialization ,
    required this.serviceType ,
    this.serviceIcon = Icons.pin,
    this.mobileServiceIcon = Icons.abc,
    this.textColor = Colors.black,
    this.leadingIconColor = Colors.black,
    this.trailingIconColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.containerHeight = 0.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * containerHeight,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Delete Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(deleteIcon, color: textColor),
            ],
          ),
          SizedBox(height: 8.0),

          // Custom Button
          CustomButton2(
            text: serviceCategory,
            borderColor: buttonBorderColor,
            trailingImage: trailingImage,
          ),
          SizedBox(height: 16.0),

          // Service Description
          TextField(
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: Colors.grey, width: 1.5), 
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0), 
    ),
            ),
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),

          // Duration and Price Labels
          Row(
            children: [
              Text("Duration", style: TextStyle(color: textColor)),
              SizedBox(width: 85),
              Text("Price", style: TextStyle(color: textColor)),
            ],
          ),
          SizedBox(height: 8.0),

          // Duration and Price Input Fields
          Row(
            children: [
              // Duration Input Field
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: durationLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Text("hours", style: TextStyle(color: textColor)),
              SizedBox(width: 8.0),

              // Price Input Field
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: priceLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),

          // Select Artist Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(artistLabel, style: TextStyle(color: textColor)),
              Text(
                changeLabel,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),

          // Artist Information
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundColor: Colors.grey),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artistName,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    artistSpecialization,
                    style: TextStyle(color: textColor.withOpacity(0.7)),
                  ),
                ],
              ),
            ],
          ),
          Divider(),

          // Service Type
          SizedBox(height: 10,),
         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Icon(serviceIcon, color: leadingIconColor),
        SizedBox(width: 8.0),
        Text(serviceType, style: TextStyle(color: textColor)),
      ],
    ),
    Icon(mobileServiceIcon, color: trailingIconColor),
  ],
)

        ],
      ),
    );
  }
}
