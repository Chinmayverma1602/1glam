import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/widgets/CustomButton2.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Add Service"),),
      body: Column(
        children: [
          Row(
            children: [
              CustomButton2(text: "Bundle", borderColor: AppColors.primary),
              CustomButton2(text: "Bundle", borderColor: AppColors.primary),
            ],
          ),
          Row(children: [
            Text("Total time :"),
            Text("4 hours"),
            Text("Total price"),
            Text("65,000"),
          ],),
          

        ],
      ),
    );
  }
}