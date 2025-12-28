import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../utlis/colors/app_color.dart';

class AateneButtonWithIcon extends StatelessWidget {
  const AateneButtonWithIcon({
    super.key,
    required this.buttonText,
    this.color,
    this.icon,
  });

  final String buttonText;
  final Color? color;
  final Icon? icon;
  final double borderRadius = 100;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.primary400,
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios, color: AppColors.light1000, size: 15),
            Text(buttonText, style: getMedium(color: AppColors.light1000)),
          ],
        ),
      ),
    );
  }
}
