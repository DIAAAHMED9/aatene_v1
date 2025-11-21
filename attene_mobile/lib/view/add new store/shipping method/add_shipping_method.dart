import 'package:attene_mobile/component/aatene_button/aatene_button_with_arrow_icon.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';

import '../../../utlis/colors/app_color.dart';
import '../../../utlis/language/language_utils.dart';

class AddShippingMethod extends StatefulWidget {
  const AddShippingMethod({super.key});

  @override
  State<AddShippingMethod> createState() => _AddShippingMethodState();
}

class _AddShippingMethodState extends State<AddShippingMethod> {
  bool _isChecked = false;

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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("اسم ملف الشحن"),
              TextFiledAatene(isRTL: isRTL, hintText: "اكتب اسم الشركة هنا"),
              Text("شركة الشحن"),
              TextFiledAatene(isRTL: isRTL, hintText: "اسم شركة الشحن"),
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
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
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
              ),
              Divider(color: AppColors.neutral900),
              Text(
                "المدن التي ترسل لها المنتجات؟",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                        return AppColors
                            .primary400; // Background color when selected
                      }
                      return Colors.white; // Background color when unselected
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(3),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "القدس وضواحيها",
                    style: TextStyle(fontSize: 16, ),
                  ),
                ],
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
                        return AppColors
                            .primary400; // Background color when selected
                      }
                      return Colors.white; // Background color when unselected
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(3),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "القدس وضواحيها",
                    style: TextStyle(fontSize: 16, ),
                  ),
                ],
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
                        return AppColors
                            .primary400; // Background color when selected
                      }
                      return Colors.white; // Background color when unselected
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(3),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "القدس وضواحيها",
                    style: TextStyle(fontSize: 16, ),
                  ),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.add_box_outlined, color: AppColors.primary400,),
                  Text("إضافة منطقة جديدة غير موجودة", style: TextStyle(
                    color: AppColors.primary400,
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              Text("المدينة"),
              TextFiledAatene(isRTL: isRTL, hintText: "الشمال", suffixIcon: Icon(Icons.keyboard_arrow_down, size: 30,),),

              AateneButtonWithIcon(buttonText: "التالي"),
            ],
          ),
        ),
      ),
    );
  }
}
