import 'package:attene_mobile/component/aatene_appbar.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

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

            Row(children: [CircleAvatar(radius: 25)]),
          ],
        ),
      ),
    );
  }
}
