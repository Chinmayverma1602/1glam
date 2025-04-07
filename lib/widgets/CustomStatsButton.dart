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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
      padding: const EdgeInsets.only(left: 1.0,),
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width * 0.36,
        decoration: BoxDecoration(
          color: widget.backgroundColor, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.stats, 
                  style: TextStyle(
                    color: widget.textColor, 
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  widget.label, 
                  style: TextStyle(
                    color: widget.labelColor, 
                    fontSize: 16,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
