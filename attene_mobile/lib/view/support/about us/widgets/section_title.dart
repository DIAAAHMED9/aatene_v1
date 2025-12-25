import 'package:flutter/material.dart';

import '../../../../utlis/colors/app_color.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 8,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary300,
                  radius: 12,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
            subtitle,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
