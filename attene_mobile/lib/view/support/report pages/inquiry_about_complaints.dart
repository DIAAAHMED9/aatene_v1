import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/view/control%20users/home_control.dart';
import 'package:attene_mobile/view/support/report%20pages/show_report.dart';
import 'package:attene_mobile/view/support/report%20pages/widget/complaints_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/text/aatene_custom_text.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // Title
              Text('إستعلام عن الشكاوي', style: getBold(fontSize: 18)),
              // Subtitle
              Text(
                'ما الذي تقدر أن نساعدك به ؟',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
              Row(
                spacing: 10,
                children: [
                  ComplaintsCard(
                    number: '8',
                    title: 'الاجمالي',
                    backgroundColor: Color(0xFFF2F8FF),
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
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFiledAatene(
                      isRTL: isRTL,
                      hintText: "اكتب هنا",
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.primary50,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list,
                        color: AppColors.primary400,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Color(0xFFd4d4d4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Text(
                            "مشكلة في التوصيل",
                            style: getBold(fontSize: 14),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFFF4E6),
                              border: Border.all(color: Color(0xFFFFE2CA)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Center(
                                child: Text(
                                  "قيد المعالجة",
                                  style: getRegular(
                                    fontSize: 10,
                                    color: Color(0xFFF17713),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Text(
                            "رقم الشكوي :",
                            style: getRegular(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "C-2020-001",
                            style: getRegular(
                              fontSize: 12,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text(
                            "الفئة :",
                            style: getRegular(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "خدمات",
                            style: getRegular(
                              fontSize: 12,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text(
                            "التاريخ :",
                            style: getRegular(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "C-2020-001",
                            style: getRegular(
                              fontSize: 12,
                              color: AppColors.primary400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => ShowReport(),
                            ),
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.primary400,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: AppColors.light1000,
                                ),
                                Text(
                                  "عرض التفاصيل",
                                  style: getRegular(
                                    fontSize: 10,
                                    color: AppColors.light1000,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
