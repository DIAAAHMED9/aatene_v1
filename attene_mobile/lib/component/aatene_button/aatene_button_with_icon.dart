import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

class AateneButtonWithIcon extends StatelessWidget {
  const AateneButtonWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ImageIcon(AssetImage(""), size: 30, color: AppColors.primary400,),
        ],
      ),
    );
  }
}
