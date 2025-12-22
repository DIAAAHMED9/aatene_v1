import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/colors/app_color.dart';

class ReportAbuse extends StatefulWidget {
  const ReportAbuse({super.key});

  @override
  State<ReportAbuse> createState() => _ReportAbuseState();
}

class _ReportAbuseState extends State<ReportAbuse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الشكاوى والاقتراحات",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary400),
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الإبلاغ عن إساءة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
              ],
            ),
          ),
        ),
      ),


    );
  }
}
