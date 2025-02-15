import 'package:flutter/material.dart';

class CustomServiceButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color leadingIconColor;
  final Color numberColor;
  final Color trailingIconColor;
  final String value;

  const CustomServiceButton({
    Key? key,
    required this.title,
    required this.subtitle,
    this.borderColor = Colors.grey,
    this.titleColor = Colors.black,
    this.subtitleColor = Colors.grey,
    this.leadingIconColor = Colors.amber,
    this.numberColor = Colors.black,
    this.trailingIconColor = Colors.black,
    this.value = "30",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.star, color: leadingIconColor),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: numberColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 16, color: trailingIconColor),
            ],
          ),
        ],
      ),
    );
  }
}
