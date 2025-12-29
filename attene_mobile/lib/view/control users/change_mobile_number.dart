import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/aatene_button/aatene_button.dart';
import '../../component/aatene_text_filed.dart';
import '../../component/text/aatene_custom_text.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class ChangeMobileNumber extends StatelessWidget {
  const ChangeMobileNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير رقم الموبايل",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text("ارقم الهاتف", style: getRegular(fontSize: 14)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: "01289022985",
              textInputType: TextInputType.phone,
              heightTextFiled: 45,
              prefixIcon: Icon(Icons.phone_outlined),
              textInputAction: TextInputAction.done,
            ),
            AateneButton(
              buttonText: "حفظ",
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              textColor: AppColors.light1000,
            ),
          ],
        ),
      ),
    );
  }
}