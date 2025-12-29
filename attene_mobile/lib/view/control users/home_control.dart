import 'package:attene_mobile/component/name_control.dart';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/view/control%20users/edit_profile.dart';
import 'package:attene_mobile/view/control%20users/followers/screen/followers.dart';
import 'package:attene_mobile/view/control%20users/personal_info.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/home/home.dart';
import 'package:attene_mobile/view/support/about%20us/about_us_screen.dart';
import 'package:attene_mobile/view/support/privacy/privacy_screen.dart';
import 'package:attene_mobile/view/support/report%20pages/sellect_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../utlis/colors/app_color.dart';
import '../support/terms of use/terms_of_use_screen.dart';
import 'block/screen/block_screen.dart';

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
                  Column(
                    children: [
                      SizedBox(height: 20),
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
                                  style: getBold(fontSize: 18),
                                ),
                                Text(
                                  " فلسطين ، الخليل",
                                  style: getRegular(fontSize: 18),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (context) => Edit_Profile(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.mode_edit_outline_outlined,
                                    color: AppColors.primary400,
                                    size: 15,
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
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Padding(
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
                      screen: HomeScreen(),
                    ),
                    NameControl(
                      name: "حساباتي",
                      icon: Icon(
                        Icons.person_outline,
                        color: AppColors.primary400,
                        size: 25,
                      ),
                      screen: HomeControl(),
                    ),
                    NameControl(
                      name: "تعديل الملف الشخصي",
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary400,
                        size: 25,
                      ),
                      screen: Edit_Profile(),
                    ),
                    NameControl(
                      name: "المتابعين",
                      icon: Icon(
                        Icons.person_add_alt,
                        color: AppColors.primary400,
                        size: 25,
                      ),
                      screen: Followers(),
                    ),
                    NameControl(
                      name: "قائمة الحظر",
                      icon: Icon(
                        Icons.block_outlined,
                        color: AppColors.primary400,
                        size: 25,
                      ),
                      screen: BlockScreen(),
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Text("الدعم", style: getBold(fontSize: 18)),
                      children: [
                        SizedBox(height: 10),
                        NameControl(
                          name: "اتصل بنا",
                          icon: Icon(
                            Icons.contact_support_outlined,
                            color: AppColors.primary400,
                            size: 25,
                          ),
                          screen: HomeControl(),
                        ),
                        NameControl(
                          name: "سياسة الخصوصية",
                          icon: Icon(
                            Icons.privacy_tip_outlined,
                            color: AppColors.primary400,
                            size: 25,
                          ),
                          screen: PrivacyScreen(),
                        ),
                        NameControl(
                          name: "شروط الخدمة",
                          icon: Icon(
                            Icons.local_police_outlined,
                            color: AppColors.primary400,
                            size: 25,
                          ),
                          screen: TermsOfUseScreen(),
                        ),
                        NameControl(
                          name: "بوابة الشكاوى والاقتراحات",
                          icon: Icon(
                            Icons.report_problem_outlined,
                            color: AppColors.primary400,
                            size: 25,
                          ),
                          screen: SellectReport(),
                        ),
                        NameControl(
                          name: "عن أعطيني",
                          icon: Icon(
                            Icons.lightbulb_circle_outlined,
                            color: AppColors.primary400,
                            size: 25,
                          ),
                          screen: AboutUsScreen(),
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
                            style: getBold(color: AppColors.error200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
