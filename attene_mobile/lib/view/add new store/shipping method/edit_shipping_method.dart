import 'package:attene_mobile/component/aatene_button/aatene_button_with_arrow_icon.dart';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

import '../../../component/aatene_text_filed.dart';
import '../../../utlis/language/language_utils.dart';

class EditShippingMethod extends StatelessWidget {
  const EditShippingMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تعديل شركة الشحن",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.primary500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("اسم ملف الشحن"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "اكتب اسم الشركة هنا",
                textInputAction: TextInputAction.next,
              ),
              Text("شركة الشحن"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "اسم شركة الشحن",
                textInputAction: TextInputAction.next,
              ),
              Text("رقم الهاتف"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "01289022985",
                prefixIcon: Icon(Icons.phone_outlined),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.primary100,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "(+970)",
                          style: getBold(
                            fontSize: 10,
                            color: AppColors.primary400,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 24,
                          color: AppColors.neutral100,
                        ),
                      ],
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              Divider(color: AppColors.neutral900),
              Row(
                children: [
                  Text("القدس وضواحيها", style: getBold(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: AppColors.error200,
                    ),
                  ),
                ],
              ),
              Text("موعد التسليم"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "٣",
                suffixIcon: Icon(Icons.keyboard_arrow_down, size: 30),
                textInputAction: TextInputAction.next,
              ),
              Text("سعر التوصيل"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "٣",
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "₪",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
              AateneButtonWithIcon(buttonText: "التالي"),
            ],
          ),
        ),
      ),
    );
  }
}
