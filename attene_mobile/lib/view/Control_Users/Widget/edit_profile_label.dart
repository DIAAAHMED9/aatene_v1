
import 'package:flutter/material.dart';

import '../../../utlis/colors/app_color.dart';

class EditProfileLabel extends StatelessWidget {
  const EditProfileLabel({super.key, required this.title, required this.subtitle, required this.icon, this.onTap});
  final String title;
  final String subtitle;
  final Widget icon;
  final Function()? onTap;



  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.neutral1000,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
          ),
          child: Row(
            spacing: 12,
            children: [
           icon,
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.neutral300),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.neutral50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
