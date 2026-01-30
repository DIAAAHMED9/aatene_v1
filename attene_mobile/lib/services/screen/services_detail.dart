import 'package:readmore/readmore.dart';

import '../../general_index.dart';
import '../../view/support/empty.dart';

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
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.neutral100,
                        ),
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
                                  style: getMedium(
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "خدمات شباك متخصصة – تركيب وصيانة",
                      style: getBold(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text("الجليل . فلسطين ", style: getMedium()),
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
                        Text(" 5 أيام", style: getBold(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
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
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                                SvgPicture.asset(
                                  "assets/images/svg_images/share.svg",
                                  width: 30,
                                  height: 30,
                                  color: AppColors.neutral300,
                                ),
                                Text(
                                  "مشاركه",
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    ExpansionTile(
                      maintainState: true,
                      // shape: StadiumBorder(),
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/services_deta.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("تفاصيل الخدمة", style: getMedium()),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "هل تواجه موقفًا قانونيًا طارئًا وتحتاج إلى استشارة موثوقة وسريعة",
                            style: getMedium(fontSize: 14),
                          ),
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/plus.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("تطويرات الخدمة", style: getMedium()),
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
                              padding: EdgeInsets.all(7),
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
                                            return AppColors.primary400;
                                          }
                                          return Colors.white;
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "هل تواجه موقفًا قانونيًا طارئًا وتحتاج إلى استشارة موثوقة وسريعة",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                          style: getMedium(fontSize: 14),
                                        ),

                                        const SizedBox(height: 4),

                                        Row(
                                          children: [
                                            Text(
                                              "50.0 ₪",
                                              style: getMedium(
                                                color: AppColors.neutral600,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Icon(
                                              Icons.access_time,
                                              color: AppColors.neutral600,
                                              size: 24,
                                            ),
                                            Text(
                                              " 5 أيام",
                                              style: getMedium(
                                                color: AppColors.neutral600,
                                              ),
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/user.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("معلومات عن بائع الخدمة", style: getMedium()),
                        ],
                      ),
                      children: [
                        GestureDetector(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Row(
                                  spacing: 5,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("محمد علي", style: getBold()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: AppColors.primary400,
                                              size: 15,
                                            ),
                                            Text(
                                              "فلسطين, الخليل",
                                              style: getMedium(
                                                color: AppColors.primary400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      spacing: 5,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Container(
                                            width: 100,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary400,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 5,
                                              children: [
                                                Icon(
                                                  Icons.person_add_alt,
                                                  color: AppColors.light1000,
                                                  size: 15,
                                                ),
                                                Text(
                                                  "متابعة",
                                                  style: getMedium(
                                                    color: AppColors.light1000,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Container(
                                            width: 100,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: AppColors.error200,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 5,
                                              children: [
                                                Icon(
                                                  Icons.flag_outlined,
                                                  color: AppColors.light1000,
                                                  size: 15,
                                                ),
                                                Text(
                                                  "بلغ عن إساءة",
                                                  style: TextStyle(
                                                    color: AppColors.light1000,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(color: AppColors.primary50, height: 2),
                                Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.timer_sharp),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text("عضو منذ "),
                                        Text(" 19-03-2025 "),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.star_border_rounded),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(" تقيم التاجر"),
                                        Text("5.0"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                              Icons.location_on_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text(
                            "المدن التي يمكنه العمل بها",
                            style: getMedium(),
                          ),
                        ],
                      ),
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.neutral900,
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "الناصرة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 0),
                          itemCount: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.neutral900),
                                color: AppColors.primary50,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "الناصرة",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
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
                              Icons.star_border_rounded,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("تقييمات ومراجعات", style: getMedium()),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            RatingSummaryWidget(
                              rating: 4.2,
                              totalReviews: 1280,
                              ratingCount: const [20, 15, 5, 4, 2],
                            ),

                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "التعليقات",
                                      style: getBold(fontSize: 24),
                                    ),
                                    Text(
                                      "سيتم عرض جميع التعليقات هنا",
                                      style: getMedium(
                                        fontSize: 14,
                                        color: AppColors.neutral500,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text("كل التعليقات", style: getMedium()),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        CircleAvatar(),
                                        Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "لويس فاندسون",
                                              style: getBold(),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: getMedium(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.flag_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                                      style: getMedium(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.primary50,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(),
                                            Text(
                                              "لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت دولور ماجن. لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت ",
                                              style: getMedium(
                                                color: AppColors.neutral600,
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.flag_outlined,
                                                    color: AppColors.error200,
                                                  ),
                                                  Text(
                                                    "بلغ عن إساءة",
                                                    style: getBold(
                                                      color: AppColors.error200,
                                                    ),
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
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        CircleAvatar(),
                                        Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "لويس فاندسون",
                                              style: getBold(),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: getMedium(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                color: AppColors.error200,
                                              ),
                                              Text(
                                                "بلغ عن إساءة",
                                                style: getBold(
                                                  color: AppColors.error200,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                                      style: getMedium(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            " مفيد 5m",
                                            style: getMedium(
                                              color: AppColors.primary400,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            "assets/images/svg_images/message-2.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ),
                                        Text(
                                          "رد",
                                          style: getBold(
                                            color: AppColors.neutral600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AateneButton(
                                      buttonText: "إطرح سؤالاً",
                                      borderColor: AppColors.primary400,
                                      textColor: AppColors.primary400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/quastion.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("الأسئلة الشائعة", style: getMedium()),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الأسئلة الشائعة",
                              style: getBold(fontSize: 18),
                            ),
                            Text(
                              "اكتب إجابات للأسئلة الشائعة التي يطرحها عميلك. أضف حتى خمسة أسئلة.",
                              style: getMedium(
                                fontSize: 14,
                                color: AppColors.neutral600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1. ما هي خدمة “محامٍ إلى جانبك”؟",
                              style: getBold(),
                            ),
                            Text(
                              "هي خدمة تتيح لك الحصول على استشارة قانونية فورية من محامٍ مختص، في مختلف المجالات القانونية، دون الحاجة لحجز موعد مسبق",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            Divider(color: AppColors.primary100),
                          ],
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/Chat.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("أسئلة وأجوبة", style: getMedium()),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("أسئلة وأجوبة", style: getBold(fontSize: 18)),
                            Text(
                              "جميع الإجابات المنشورة تمثل آراء وتجارب أصحابها فقط، ولا تعبّر بالضرورة عن وجهة نظر منصة أعطيني. لا تقوم المنصة بمراجعة أو التحقق من صحة هذه الإجابات أو الادعاءات، ولا تُعد مؤيدة لها بأي شكل من الأشكال.",
                              style: getMedium(
                                fontSize: 14,
                                color: AppColors.neutral600,
                              ),
                            ),
                            SizedBox(height: 10),
                            AateneButton(
                              buttonText: "أضف تعليقك",
                              borderColor: AppColors.primary400,
                              textColor: AppColors.primary400,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.primary100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "هل المحامي يرد على الاستشارة فورًا؟",
                                      style: getBold(fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: AppColors.primary400,
                                              ),
                                            ),
                                            child: Center(
                                              child: Row(
                                                spacing: 5,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/svg_images/Chat.svg",
                                                    width: 13,
                                                    height: 13,
                                                  ),
                                                  Text(
                                                    "الاجابة",
                                                    style: getMedium(
                                                      color:
                                                          AppColors.primary400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                color: AppColors.error200,
                                              ),
                                              Text(
                                                "بلغ عن إساءة",
                                                style: getBold(
                                                  color: AppColors.error200,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary50,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          spacing: 15,
                                          children: [
                                            Row(
                                              spacing: 15,
                                              children: [
                                                CircleAvatar(),
                                                Text(
                                                  "لارا أحمد",
                                                  style: getMedium(),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "12 - 08 - 2025",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: AppColors.neutral500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "يعتمد وقت الرد على توفر المحامي وطبيعة الاستشارة. نسعى للرد في أقرب وقت ممكن، لكن قد يستغرق الأمر بعض الوقت في حال كان المحامي مشغولًا أو تتطلب الاستشارة مراجعة دقيقة. نقدر تفهمك وحرصك على الحصول على خدمة قانونية دقيقة ومتكاملة.",
                                              style: getMedium(
                                                color: AppColors.neutral400,
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.flag_outlined,
                                                    color: AppColors.error200,
                                                  ),
                                                  Text(
                                                    "بلغ عن إساءة",
                                                    style: getBold(
                                                      color: AppColors.error200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            "عرض المزيد من الإجابات (34)",
                                            style: getMedium(
                                              color: AppColors.primary400,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppColors.primary400,
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
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary50),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            "assets/images/svg_images/message-butt.svg",
                            width: 24,
                            height: 24,
                          ),

                          onPressed: () {},
                          label: Text(
                            'دردش',
                            style: getMedium(color: AppColors.light1000),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.primary400,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.call_outlined,
                          color: AppColors.primary400,
                        ),
                      ),
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
