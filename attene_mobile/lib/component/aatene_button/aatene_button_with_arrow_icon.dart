import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primary400,
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios, color: AppColors.light1000, size: 15),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.light1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
