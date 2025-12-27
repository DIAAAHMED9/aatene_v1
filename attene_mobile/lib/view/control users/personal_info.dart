import 'package:attene_mobile/component/Text/text_with_star.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "المعلومات الشخصية",
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الاسم الكامل",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الاسم الكامل",
                textInputType: TextInputType.name,
                heightTextFiled: 45, textInputAction: TextInputAction.next,
              ),
              TextWithStar(text: "الجنس"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "ذكر",
                suffixIcon: Icon(Icons.keyboard_arrow_down), textInputAction: TextInputAction.next,
              ),
              TextWithStar(text: "تاريخ الميلاد"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "4/11/1998",
                suffixIcon: Icon(Icons.date_range, color: AppColors.primary400), textInputAction: TextInputAction.next,
              ),
              TextWithStar(text: "المدينة"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الناصرة",
                suffixIcon: Icon(Icons.keyboard_arrow_down), textInputAction: TextInputAction.next,
              ),
              TextWithStar(text: "الحي"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الناصرة",
                suffixIcon: Icon(Icons.keyboard_arrow_down), textInputAction: TextInputAction.next,
              ),
              Text(
                "النبذة الشخصية",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "هنا مثال لوص....",
                textInputType: TextInputType.name,
                heightTextFiled: 100, textInputAction: TextInputAction.next,
              ),
              Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary400,
                    size: 20,
                  ),
                  Text("لا بأس إن تجاوز النص 300 كلمة.\n يسمح بمرونة في عدد الكلمات حسب الحاجة.", style: TextStyle(fontSize: 12,color: AppColors.neutral400),),
                  Spacer(),
                  Text("0/50"),
                ],
              ),
              AateneButton(buttonText: "حفظ", color: AppColors.primary400,borderColor: AppColors.primary400,textColor: AppColors.light1000,)
            ],
          ),
        ),
      ),
    );
  }
}
