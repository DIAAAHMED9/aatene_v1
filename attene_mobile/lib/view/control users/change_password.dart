import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/aatene_text_filed.dart';
import '../../component/text/aatene_custom_text.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير كلمة المرور",
          style:getBold(
            color: AppColors.neutral100,
            fontSize: 20,
          ) ,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("كلمة المرور القديمة", style:getRegular(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword, textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            Text("كلمة المرور الجديدة", style:getRegular(fontSize: 12),),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword, textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            Text("تأكيد كلمة المرور الجديدة",  style:getRegular(fontSize: 12),),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword, textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),
            AateneButton(
              buttonText: "اعادة تعيين",
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),
          ],
        ),
      ),
    );
  }
}