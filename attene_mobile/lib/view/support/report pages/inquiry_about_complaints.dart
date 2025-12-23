import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/view/support/report%20pages/widget/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/colors/app_color.dart';
import '../../../utlis/language/language_utils.dart';

class InquiryAboutComplaints extends StatelessWidget {
  const InquiryAboutComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // Title
              const Text(
                'إستعلام عن الشكاوي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Subtitle
              const Text(
                'ما الذي تقدر أن نساعدك به ؟',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                spacing: 10,
                children: [
                  ComplaintsCard(
                    number:  '8',
                    title: 'إجمالي الشكاوى',
                    backgroundColor:  Color(0xFFF2F8FF),
                    textColor: AppColors.primary400,
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "جديدة",
                    backgroundColor: Color(0xFFE0EEFF),
                    textColor: Color(0xFF287CDA),
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "قيد المراجعة",
                    backgroundColor: Color(0xFFFFF3E9),
                    textColor: Color(0xFFFF7300),
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "جديدة",
                    backgroundColor: Color(0xFFD3FFDB),
                    textColor: Color(0xFF03B037),
                  ),
                ],
              ),
              Text("رقم الشكوى"),
              Row(
                 children: [

                   Expanded(child: TextFiledAatene(isRTL: isRTL, hintText: "اكتب هنا", )),
                   CircleAvatar(
                     backgroundColor: AppColors.secondary100,
                     child: IconButton(onPressed: (){}, icon: Icon(Icons.filter_list, color: AppColors.primary400,)),
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
