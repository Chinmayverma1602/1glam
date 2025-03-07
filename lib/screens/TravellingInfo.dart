import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:glam1/model/travelling_model.dart';
import 'package:glam1/screens/ServicesInfoPage.dart';
import 'package:glam1/services/travelling_service.dart';
import 'package:glam1/widgets/CustomButton.dart';
import 'package:glam1/widgets/CustomButton2.dart';
import 'package:glam1/widgets/CustomDistanceSlider.dart';
import 'package:glam1/widgets/CustomHeader.dart';
import 'package:glam1/widgets/CustomSubtitle.dart';
import 'package:glam1/widgets/CustomTitle.dart';

class TravellingInfoPage extends StatefulWidget {
  const TravellingInfoPage({super.key});

  @override
  State<TravellingInfoPage> createState() => _TravellingInfoPageState();
}

class _TravellingInfoPageState extends State<TravellingInfoPage> {
  late SingleValueDropDownController _paymentController;
  late SingleValueDropDownController _travelFeeController;
  final TravelFeeService _travelFeeService = TravelFeeService();

  final List<DropDownValueModel> _paymentMethods = const [
    DropDownValueModel(name: "Free", value: "free"),
    DropDownValueModel(name: "Starts from", value: "starts from"),
    DropDownValueModel(name: "Fixed", value: "fixed"),
  ];

  final List<DropDownValueModel> _travelFeeOptions = const [
    DropDownValueModel(name: "Per km", value: "per_km"),
    DropDownValueModel(name: "Per mile", value: "per_mile"),
  ];

  @override
  void initState() {
    super.initState();
    _paymentController = SingleValueDropDownController();
    _travelFeeController = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _travelFeeController.dispose();
    super.dispose();
  }

  void _submitTravelFee() async {
    TravelFee travelFee = TravelFee(
      user: "hade@example.com",
      feeType: _travelFeeController.dropDownValue?.value ?? "",
      paymentMethod: _paymentController.dropDownValue?.value ?? "",
      maxDistance: "78",
    );

    bool success = await _travelFeeService.submitTravelFee(travelFee);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesInfoPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit travel fee.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(),
              const SizedBox(height: 35),
              CustomTitle(title: "What is your travel fee?"),
              const SizedBox(height: 35),
              DropDownTextField(
                controller: _paymentController,
                listSpace: 2,
                dropdownRadius: 12,
                textFieldDecoration: InputDecoration(
                  hintText: "Select Payment Method",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/leading.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),
                dropDownList: _paymentMethods,
              ),
              const SizedBox(height: 15),
              DropDownTextField(
                controller: _travelFeeController,
                listSpace: 2,
                dropdownRadius: 12,
                textFieldDecoration: InputDecoration(
                  hintText: "Travel Fee per km/mile",
                  prefixIcon: const Icon(
                    Icons.monetization_on,
                    size: 24,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),
                dropDownList: _travelFeeOptions,
              ),
              const SizedBox(height: 15),
              CustomDistanceSlider(),
              const SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/images/globe.svg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              CustomSubTitle(
                subtitle: "Travel & Fee Policy (Optional)",
                color: AppColors.text,
              ),
              const SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Travel to restricted areas, congested zone,...",
                    style: TextStyle(color: AppColors.hintText),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              CustomButton(
                text: "Skip for now",
                color: Colors.white,
                textColor: AppColors.primary,
                onPressed: () {},
                border: false,
                elevation: 0.1,
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "Continue",
                color: AppColors.subtitle,
                onPressed: _submitTravelFee,
              )
            ],
          ),
        ),
      ),
    );
  }
}
