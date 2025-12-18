import 'package:flutter/material.dart';

import '../utlis/colors/app_color.dart';

class NameControl extends StatelessWidget {
  const NameControl({super.key, required this.name, required this.icon, this.onTap, });

  final String name;
  final Widget icon;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              icon,
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(
            color: AppColors.neutral800,
          ),
        ],
      ),
    );
  }
}
