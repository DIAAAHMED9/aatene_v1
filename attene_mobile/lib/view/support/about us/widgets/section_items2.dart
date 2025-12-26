import 'package:flutter/material.dart';

import '../../../../utlis/colors/app_color.dart';

class SectionItems2 extends StatelessWidget {
  const SectionItems2({super.key, required this.title, required this.subtitle, required this.icon});
  final String title ;
  final String subtitle ;
  final Image icon ;

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFf6f6f6),
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
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.primary400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: icon,
                  ),
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
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
