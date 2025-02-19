import 'package:flutter/material.dart';

class CustomScheduleButton extends StatefulWidget {
  final String time;
  final String timeBlock;
  final String userName;
  final String makeupType;

  const CustomScheduleButton({
    super.key,
    required this.time,
    required this.timeBlock,
    required this.userName,
    required this.makeupType,
  });

  @override
  State<CustomScheduleButton> createState() => _CustomScheduleButtonState();
}

class _CustomScheduleButtonState extends State<CustomScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.timeBlock,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.makeupType,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
