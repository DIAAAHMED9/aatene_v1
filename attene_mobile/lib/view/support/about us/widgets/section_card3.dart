import 'package:flutter/material.dart';

import '../../../../utlis/colors/app_color.dart';

class SectionCard3 extends StatelessWidget {
  const SectionCard3({super.key, required this.title, required this.subtitle, required this.icon});
  final String title ;
  final String subtitle ;
  final Icon icon ;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.light1000,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          spacing: 10,
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
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.neutral700),),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
