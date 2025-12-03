import 'package:flutter/material.dart';

import '../../../utlis/colors/app_color.dart';

class ServicesDetail extends StatefulWidget {
  const ServicesDetail({super.key});

  @override
  State<ServicesDetail> createState() => _ServicesDetailState();
}

bool _isChecked = false;

class _ServicesDetailState extends State<ServicesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/png/ser1.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 400,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.withOpacity(.5),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.neutral100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 320, right: 220),
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.light1000,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("9/", style: TextStyle(fontSize: 12)),
                          Text(
                            "1",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.image_outlined),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 360),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.light1000,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.primary400,
                              ),
                              child: Center(
                                child: Text(
                                  "خدمة",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.light1000,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.star, color: Colors.amberAccent),
                            Text("5.0"),
                            Text("(00)"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "خدمات شباك متخصصة – تركيب وصيانة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text("الجليل . فلسطين "),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          " 50.0 ₪",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.access_time, color: AppColors.neutral600),
                        Text(
                          " 5 أيام",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      spacing: 20,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary50,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: AppColors.neutral300,
                              ),
                              Text(
                                "اعجبني",
                                style: TextStyle(color: AppColors.neutral400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary50,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_outlined,
                                size: 30,
                                color: AppColors.neutral300,
                              ),
                              Text(
                                "مشاركه",
                                style: TextStyle(color: AppColors.neutral400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary50,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_border_rounded,
                                size: 40,
                                color: AppColors.neutral300,
                              ),
                              Text(
                                "تقيم",
                                style: TextStyle(color: AppColors.neutral400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.primary50,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 30,
                                color: AppColors.neutral300,
                              ),
                              Text(
                                "إبلاغ",
                                style: TextStyle(color: AppColors.neutral400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      shape: StadiumBorder(),
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("تفاصيل الخدمة"),
                        ],
                      ),
                      children: [
                        Text(
                          "هل تواجه موقفًا قانونيًا طارئًا وتحتاج إلى استشارة موثوقة وسريعة",
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: Icon(
                              Icons.add_box_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("تطويرات الخدمة"),
                        ],
                      ),
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _isChecked = newValue ?? false;
                                      });
                                    },
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.selected,
                                          )) {
                                            return AppColors
                                                .primary400;
                                          }
                                          return Colors
                                              .white;
                                        }),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(3),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "هل تواجه موقفًا قانونيًا طارئًا وتحتاج إلى استشارة موثوقة وسريعة",
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            " 50.0 ₪",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.neutral600,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Icon(
                                            Icons.access_time,
                                            color: AppColors.neutral600,
                                            size: 24,
                                          ),
                                          Text(
                                            " 5 أيام",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.neutral600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
                          itemCount: 2,
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("معلومات عن بائع الخدمة"),
                        ],
                      ),
                      children: [
                       Container(
                         width: double.infinity,
                         height: 100,
                       ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}