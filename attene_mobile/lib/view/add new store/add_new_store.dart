import 'package:attene_mobile/component/Text/text_with_star.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button_with_arrow_icon.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';

import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class AddNewStore extends StatefulWidget {
  AddNewStore({super.key});

  @override
  State<AddNewStore> createState() => _AddNewStoreState();
}

class _AddNewStoreState extends State<AddNewStore> {
  final isRTL = LanguageUtils.isRTL;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "البيانات الاساسية",
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWithStar(text: "اسم المتجر"),
              TextFiledAatene(isRTL: isRTL, hintText: "متجر الافضل"),
              Text(
                "هوية متجرك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "ستظهر هوية متجرك في صفحة المتجر",
                style: TextStyle(fontSize: 12),
              ),
              Container(
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.add, size: 25, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'اضف صورة او فيديو',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'png , jpg , svg',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Text(
                "هوية متجرك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "ستظهر هوية متجرك في صفحة المتجر",
                style: TextStyle(fontSize: 12),
              ),
              Container(
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.add, size: 25, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'اضف صورة او فيديو',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'png , jpg , svg',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              TextWithStar(text: "وصف المتجر"),
              TextFiledAatene(isRTL: isRTL, hintText: "وصف المتجر"),
              TextWithStar(text: "البريد الالكتروني"),
              TextFiledAatene(isRTL: isRTL, hintText: "البريد الالكتروني"),
              TextWithStar(text: "المدينة"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "المدينة",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.location_city),
                ),
              ),
              TextWithStar(text: "الحي"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الحي",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.home_work_outlined),
                ),
              ),
              TextWithStar(text: "العنوان"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "العنوان",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.location_on_outlined),
                ),
              ),
              TextWithStar(text: "العملة"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "العملة",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.currency_bitcoin),
                ),
              ),
              TextWithStar(text: "المالك"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "المالك",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.person_outline_outlined),
                ),
              ),
              TextWithStar(text: "الهاتف المحمول"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الهاتف المحمول",
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.phone_outlined),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                    },
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith<Color>((
                      Set<MaterialState> states,
                    ) {
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primary400;
                      }
                      return Colors.white;
                    }),
                    side: BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  Text(
                    "إخفاء رقم الهاتف على الملف الشخصي",
                    style: TextStyle(fontSize: 14, color: AppColors.neutral700),
                  ),
                ],
              ),
              AateneButtonWithIcon(buttonText: "التالي"),
            ],
          ),
        ),
      ),
    );
  }
}
