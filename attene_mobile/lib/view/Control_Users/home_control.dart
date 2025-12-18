import 'package:attene_mobile/component/name_control.dart';
import 'package:flutter/material.dart';

import '../../utlis/colors/app_color.dart';

class HomeControl extends StatelessWidget {
  const HomeControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Image.asset("assets/images/png/controler_bacground.png", width: double.infinity, height: 260,),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/png/aatene_logo_horiz.png",
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(right: 70),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(radius: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "jerusalemlll",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " فلسطين ، الخليل",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.primary100,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.mode_edit_outline_outlined,
                                    color: AppColors.primary400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                spacing: 10,
                children: [
                  NameControl(
                    name: "لوحة القيادة",
                    icon: Icon(
                      Icons.home_outlined,
                      color: AppColors.primary400,
                      size: 25,
                    ),
                  ),
                  NameControl(
                    name: "حساباتي",
                    icon: Icon(
                      Icons.person_outline,
                      color: AppColors.primary400,
                      size: 25,
                    ),
                  ),
                  NameControl(
                    name: "تعديل الملف الشخصي",
                    icon: Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary400,
                      size: 25,
                    ),
                  ),
                  NameControl(
                    name: "المتابعين",
                    icon: Icon(
                      Icons.person_add_alt,
                      color: AppColors.primary400,
                      size: 25,
                    ),
                  ),
                  NameControl(
                    name: "قائمة الحظر",
                    icon: Icon(
                      Icons.block_outlined,
                      color: AppColors.primary400,
                      size: 25,
                    ),
                  ),
                  ExpansionTile(
                    splashColor: AppColors.primary50,
                    maintainState: true,
                    title: Text(
                      "الدعم",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    children: [
                      NameControl(
                        name: "اتصل بنا",
                        icon: Icon(
                          Icons.contact_support_outlined,
                          color: AppColors.primary400,
                          size: 25,
                        ),
                      ),
                      NameControl(
                        name: "سياسة الخصوصية",
                        icon: Icon(
                          Icons.privacy_tip_outlined,
                          color: AppColors.primary400,
                          size: 25,
                        ),
                      ),
                      NameControl(
                        name: "تشروط الخدمة",
                        icon: Icon(
                          Icons.local_police_outlined,
                          color: AppColors.primary400,
                          size: 25,
                        ),
                      ),
                      NameControl(
                        name: "بوابة الشكاوى والاقتراحات",
                        icon: Icon(
                          Icons.report_problem_outlined,
                          color: AppColors.primary400,
                          size: 25,
                        ),
                      ),
                      NameControl(
                        name: "عن أعطيني",
                        icon: Icon(
                          Icons.lightbulb_circle_outlined,
                          color: AppColors.primary400,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.login_rounded, color: AppColors.error200),
                        Text(
                          "تسجيل خروج",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
