import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';

class CustomDistanceSlider extends StatefulWidget {
  final String title;
  final double minValue;
  final double maxValue;
  final double initialValue;
  final double textSize;
  final Color sliderActiveColor;
  final Color sliderInactiveColor;
  final Color textColor;

  const CustomDistanceSlider({
    Key? key,
    this.title = "Maximum Travel Distance",
    this.minValue = 0,
    this.maxValue = 100,
    this.initialValue = 50,
    this.textSize = 16,
    this.sliderActiveColor = AppColors.sliderColor,
    this.sliderInactiveColor = Colors.grey,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  _CustomDistanceSliderState createState() => _CustomDistanceSliderState();
}

class _CustomDistanceSliderState extends State<CustomDistanceSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Optional: Add border or background color if needed
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Text
          Text(
            widget.title,
            style: TextStyle(
              fontSize: widget.textSize,
              
              color: AppColors.hintText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Slider Row
          
          // Slider Widget
          Slider(
            value: _currentValue,
            min: widget.minValue,
            max: widget.maxValue,
            activeColor: widget.sliderActiveColor,
            inactiveColor: widget.sliderInactiveColor,
            onChanged: (double value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minimum Value Text
              Text(
                widget.minValue.toStringAsFixed(0)+"km",
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: widget.textColor,
                ),
              ),
              // Current Value Text
              Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentValue.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: widget.textSize,
                         
                          color: widget.textColor,
                        ),
                      ),
                      Text("km")
                    ],
                  ),
                ),
              ),
              // Maximum Value Text
              Text(
                widget.maxValue.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
