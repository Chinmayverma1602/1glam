import 'package:flutter/material.dart';

class CustomScheduleButton extends StatefulWidget {
  const CustomScheduleButton({super.key});

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
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "10:00",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "AM",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Priya Shah",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Bridal Makeup",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );;
  }
}