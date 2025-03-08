import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/screens/BundleServicePage.dart';
import 'package:glam1/screens/HomePage.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomServiceSelectionContainer.dart';

class SingleServicePage extends StatefulWidget {
  const SingleServicePage({Key? key}) : super(key: key);

  @override
  State<SingleServicePage> createState() => _SingleServicePageState();
}

class _SingleServicePageState extends State<SingleServicePage> {
  CustomServiceSelectionContainer? serviceWidget;

  void _addService() {
    setState(() {
      serviceWidget = CustomServiceSelectionContainer(
        title: 'New Service',
        serviceCategory: 'Luxury',
        buttonBorderColor: AppColors.hintText.withOpacity(0.4),
        borderColor: AppColors.hintText,
        hintText: 'Service description',
        borderRadius: 16,
        durationLabel: '2',
        priceLabel: '40,000',
        artistName: 'New Artist',
        artistSpecialization: 'Specialist',
        serviceType: 'Mobile Service',
        serviceIcon: 'assets/images/f.svg',
        leadingIconColor: AppColors.primary,
        trailingIconColor: AppColors.primary,
        artistImage: 'assets/images/img.svg',
        onDelete: _removeService,
      );
    });
  }

  void _removeService() {
    setState(() {
      serviceWidget = null;
    });
  }

  int _calculateTotalTime() => serviceWidget != null ? 2 : 0;
  int _calculateTotalPrice() => serviceWidget != null ? 40000 : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        title: const Text("Add Service"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton2(text: "Bundle", borderColor: AppColors.primary, onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BundleServicePage()));
                    },),
                   CustomButton2(text: "Single", borderColor: AppColors.primary, fillColor: AppColors.primary.withOpacity(0.2),textColor: AppColors.title,),
                ],
              ),
              Row(
                children: [
                  const Text("Total time:", style: TextStyle(color: AppColors.hintText)),
                  const SizedBox(width: 15),
                  Text("${_calculateTotalTime()} hours"),
                  const Spacer(),
                  const Text("Total price:", style: TextStyle(color: AppColors.hintText)),
                  const SizedBox(width: 15),
                  Text("${_calculateTotalPrice()}"),
                ],
              ),
              const SizedBox(height: 16.0),
              if (serviceWidget != null)
                CustomServiceSelectionContainer(
                  title: serviceWidget!.title,
                  serviceCategory: serviceWidget!.serviceCategory,
                  buttonBorderColor: serviceWidget!.buttonBorderColor,
                  borderColor: serviceWidget!.borderColor,
                  hintText: serviceWidget!.hintText,
                  borderRadius: serviceWidget!.borderRadius,
                  durationLabel: serviceWidget!.durationLabel,
                  priceLabel: serviceWidget!.priceLabel,
                  artistName: serviceWidget!.artistName,
                  artistSpecialization: serviceWidget!.artistSpecialization,
                  serviceType: 'Mobile Service',
                  serviceIcon: serviceWidget!.serviceIcon,
                  leadingIconColor: serviceWidget!.leadingIconColor,
                  trailingIconColor: serviceWidget!.trailingIconColor,
                  artistImage: serviceWidget!.artistImage,
                  onDelete: _removeService,
                ),
              const SizedBox(height: 16),
              if (serviceWidget == null)
                CustomButton(
                  icon: Icons.add,
                  text: "Add Service",
                  color: Colors.transparent,
                  onPressed: _addService,
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  border: true,
                  borderThickness: 0.4,
                ),
              if (serviceWidget != null)
                CustomButton(
                  text: "Save Service",
                  color: AppColors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}