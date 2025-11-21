import 'package:attene_mobile/component/aatene_button/aatene_button_with_arrow_icon.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

import '../../../component/aatene_button/aatene_button.dart';


class ManageAccountStore extends StatelessWidget {
  const ManageAccountStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ادارة الحسابات",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(color: AppColors.primary100),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "الحساب/المتجر",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primary400,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "الاجراءات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primary400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      // radius: 20,
                      maxRadius: 20,
                      backgroundImage: AssetImage(
                        'assets/images/png/logo_aatrne.png',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Diaa",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F4F8),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              SizedBox(width: 2),
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.success300,
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: AppColors.light1000,
                                ),
                              ),
                              Text(
                                "خليج بايرون، أستراليا",
                                style: TextStyle(fontSize: 7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary100,
                        ),
                        child: Icon(
                          Icons.mode_edit_outline_outlined,
                          size: 20,
                          color: AppColors.primary400,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.error100,
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.error300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 3,
            ),
            AateneButtonWithIcon(buttonText: "buttonText", icon: Icon(Icons.add),),
          ],
        ),
      ),
    );
  }
}
