import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قائمة الحظر",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "مستخدمين",
                          style: TextStyle(
                            color: AppColors.light1000,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "مستخدمين",
                          style: TextStyle(
                            color: AppColors.light1000,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "بحث",
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary400,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search_rounded,
                        color: AppColors.light1000,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                spacing: 15,
                children: [
                  CircleAvatar(radius: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ahmed Ali",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "@ahmed",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral300,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.primary400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "إلغاء الحظر",
                          style: TextStyle(
                            color: AppColors.light1000,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
