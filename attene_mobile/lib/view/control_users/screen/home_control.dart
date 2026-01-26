import '../../../general_index.dart';

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/png/aatene_logo_horiz.png",
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      icon: SvgPicture.asset(
                        'assets/images/svg_images/home.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 20,
                        width: 20,
                      ),
                      screen: DashboardView(),
                    ),
                    NameControl(
                      name: "حساباتي",
                      screen: HomeControl(),
                      icon: Icon(
                        Icons.person_outlined,
                        color: AppColors.primary400,
                        size: 25,
                      ),
                    ),
                    NameControl(
                      name: "تعديل الملف الشخصي",
                      icon: SvgPicture.asset(
                        'assets/images/svg_images/edit.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 20,
                        width: 20,
                      ),
                      screen: Edit_Profile(),
                    ),
                    NameControl(
                      name: "اعدادات التنبيهعات",
                      icon: SvgPicture.asset(
                        'assets/images/svg_images/Notification.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 20,
                        width: 20,
                      ),
                      screen: NotificationFeed(),
                    ),
                    NameControl(
                      name: "المتابعين",
                      icon: SvgPicture.asset(
                        'assets/images/svg_images/add-team.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 25,
                        width: 25,
                      ),
                      screen: FollowersPage(),
                    ),
                    // NameControl(
                    //   name: "قائمة الحظر",
                    //   icon: Icon(
                    //     Icons.block_outlined,
                    //     color: AppColors.primary400,
                    //     size: 22,
                    //   ),
                    //   screen: BlockScreen(),
                    // ),
                    ExpansionTile(
                      maintainState: true,
                      title: Text("الدعم", style: getBold(fontSize: 18)),
                      children: [
                        SizedBox(height: 10), //
                        NameControl(
                          name: "اتصل بنا",
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/bx_message.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 27,
                            width: 27,
                          ),
                          screen: HomeControl(),
                        ),
                        NameControl(
                          name: "سياسة الخصوصية",
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/privecy.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 18,
                            width: 18,
                          ),
                          screen: PrivacyScreen(),
                        ),
                        NameControl(
                          name: "شروط الخدمة",
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/shode_services.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 22,
                            width: 22,
                          ),
                          screen: TermsOfUseScreen(),
                        ),
                        NameControl(
                          name: "بوابة الشكاوى والاقتراحات",
                          icon: Icon(
                            Icons.report_problem_outlined,
                            color: AppColors.primary400,
                            size: 22,
                          ),
                          screen: SellectReport(),
                        ),
                        NameControl(
                          name: "عن أعطيني",
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/ix_about.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 18,
                            width: 18,
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
