import 'package:attene_mobile/component/aatene_button/aatene_button_with_arrow_icon.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';

import '../../../utlis/colors/app_color.dart';

class ShippingMethod extends StatefulWidget {
  const ShippingMethod({super.key});

  @override
  State<ShippingMethod> createState() => _ShippingMethodState();
}

bool _isChecked = false;

class _ShippingMethodState extends State<ShippingMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "طريقة الشحن",
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "كيف تود شحن المنتجات؟",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      borderRadius: BorderRadiusGeometry.circular(50),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "إخفاء رقم الهاتف على الملف الشخصي",
                    style: TextStyle(fontSize: 14, color: AppColors.neutral200),
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
                      borderRadius: BorderRadiusGeometry.circular(50),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "من يد ليد “دون شركات توصيل”",
                    style: TextStyle(fontSize: 14, color: AppColors.neutral200),
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
                      borderRadius: BorderRadiusGeometry.circular(50),
                    ),
                    side: BorderSide(
                      color: Colors.grey, // Border color when unselected
                      width: 1.0,
                    ),
                    // Color when focused
                  ),
                  Text(
                    "إخفاء رقم الهاتف على الملف الشخصي",
                    style: TextStyle(fontSize: 14, color: AppColors.neutral200),
                  ),
                ],
              ),
              Divider(color: AppColors.primary400),
              Row(
                children: [
                  Text(
                    "شركات الشحن",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(
                    color: AppColors.neutral900,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.cyanAccent
                          ),
                          child: Text("أساسي", style: TextStyle(fontSize: 14,color: AppColors.light1000),),
                        ),
                        Spacer(),
                        Icon(Icons.delete_outline_outlined, color: AppColors.error200,),
                        Icon(Icons.mode_edit_outlined),

                      ],
                    ),
                    Text("data", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text("data",style:  TextStyle(fontSize: 12,),),

                  ],
                ),
              ),
              AateneButtonWithIcon(buttonText: "حفظ وانشاء"),],
          ),
        ),
      ),
    );
  }
}
