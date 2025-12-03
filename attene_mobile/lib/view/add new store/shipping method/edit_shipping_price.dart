import 'package:flutter/material.dart';

import '../../../component/aatene_button/aatene_button_with_arrow_icon.dart';
import '../../../component/aatene_text_filed.dart';
import '../../../utlis/colors/app_color.dart';
import '../../../utlis/language/language_utils.dart';

class EditShippingPrice extends StatelessWidget {
  const EditShippingPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إضافة شركة شحن جديدة",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Text(
                    "المدن التي ترسل لها المنتجات؟",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primary400),
                        Text(
                          "إضافة شركة شحن",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "القدس وضواحيها",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
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
              ),
              Text("سعر التوصيل"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "٣",
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("₪", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                ),
              ),
              AateneButtonWithIcon(buttonText: "حفظ ملف التوصيل"),
            ],
          ),
        ),
      ),
    );
  }
}