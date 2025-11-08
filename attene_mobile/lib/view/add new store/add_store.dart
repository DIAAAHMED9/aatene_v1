import 'package:attene_mobile/component/aatene_button.dart';
import 'package:flutter/material.dart';

import '../../utlis/colors/app_color.dart';

class AddStore extends StatelessWidget {
  const AddStore({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "نوع المتجر",
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
            spacing: 20,
            children: [
              Text(
                "قم باختيار نوع المتجر الذي تريده  (تقديم خدمات/بيع منتجات)",
              ),
              MaterialButton(
                onPressed: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: AppColors.primary400,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: AppColors.primary400),
                      Text(
                        "لبيع المنتجات",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ImageIcon(AssetImage(""), size: 24,),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: AppColors.neutral100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: AppColors.neutral100),
                      Text(
                        "لبيع المنتجات",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.neutral100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ImageIcon(AssetImage(""), size: 24,),
                    ],
                  ),
                ),
              ),
              AateneButton(buttonText: "التالي"),
            ],
          ),
        ),
      ),
    );
  }
}
