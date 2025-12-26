import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:flutter/material.dart';

import '../../../../utlis/colors/app_color.dart';

class ComplaintsCard extends StatelessWidget {
  const ComplaintsCard({
    super.key,
    required this.number,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  final String number;
  final String title;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFD5D1D1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                number,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
