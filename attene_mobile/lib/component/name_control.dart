import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';

import '../utlis/colors/app_color.dart';

class NameControl extends StatelessWidget {
  const NameControl({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    required this.screen,
  });

  final String name;
  final Widget icon;
  final Widget screen;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => screen),
        );
      },
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              icon,
              Text(name, style: getBold()),
            ],
          ),
          Divider(color: AppColors.neutral800),
        ],
      ),
    );
  }
}