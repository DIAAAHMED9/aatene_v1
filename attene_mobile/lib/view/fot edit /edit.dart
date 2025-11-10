import 'package:flutter/material.dart';

import '../../utlis/colors/app_color.dart';

class Edit extends StatelessWidget {
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(color: AppColors.primary200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [Text("الحساب/المتجر"), Spacer(), Text("الاجراءات")],
              ),
            ),
          ),

          Row(
            children: [
              CircleAvatar(

                radius: 30,


              ),
            ],
          ),
        ],
      ),
    );
  }
}
