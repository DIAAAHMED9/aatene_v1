import 'package:flutter/material.dart';
import '../utlis/colors/app_color.dart';

class AateneAppbar extends StatelessWidget {
  const AateneAppbar({super.key, required this.title});

  final dynamic title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.neutral100,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey[300],
          ),
          child: Icon(Icons.arrow_back, color: AppColors.primary500),
        ),
      ),
    );
  }
}
