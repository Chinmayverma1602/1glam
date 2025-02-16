import 'package:flutter/material.dart';

class CustomStatsButton extends StatefulWidget {
  final String stats;
  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final Color textColor;

  const CustomStatsButton({
    Key? key,
    required this.label,
    required this.stats,
    this.labelColor = Colors.black,
    this.textColor  = Colors.black,
    this.backgroundColor  = Colors.white,
  }) : super(key: key);

  @override
  State<CustomStatsButton> createState() => _CustomStatsButtonState();
}

class _CustomStatsButtonState extends State<CustomStatsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.33,
      decoration: BoxDecoration(
        color: widget.backgroundColor, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.stats, 
            style: TextStyle(
              color: widget.textColor, 
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Text(
            widget.label, 
            style: TextStyle(
              color: widget.labelColor, 
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
