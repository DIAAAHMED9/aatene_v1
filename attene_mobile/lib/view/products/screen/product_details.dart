import '../../../general_index.dart';


class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

bool _isChecked = false;
bool isLiked = false;

class _ProductDetailsState extends State<ProductDetails> {
  final isRTL = LanguageUtils.isRTL;

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

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
                                  "منتج",
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Armando نظارة شمس أسيتيت أصلية من أرماندو كافللي",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text("الجليل . فلسطين "),
                      ],
                    ),
                    Text(
                      "وصف موجز",
                      style: TextStyle(color: AppColors.neutral400),
                    ),
                    Row(
                      children: [
                        Text(" السعر", style: TextStyle(fontSize: 13)),
                        Text(
                          " 190.54 ₪",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "380.21 ₪",
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "  50% off ",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.error200,
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
                              Icons.directions_car_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("معلومات التوصيل"),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                spacing: 20,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      Icons.calendar_month_outlined,
                                      color: AppColors.neutral500,
                                    ),
                                  ),
                                  Text(
                                    "يتم التوصيل خلال 1–4 أيام ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.directions_car_filled_outlined,
                                      color: AppColors.neutral500,
                                    ),
                                    Text(
                                      "توصيل إلي الناصرة من 2-3 أيام",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "1200.0 ₪",
                                      style: TextStyle(
                                        color: AppColors.primary400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.sim_card_outlined,
                                    color: AppColors.neutral500,
                                  ),
                                ),
                                Text(
                                  "التوصيل إلى: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary400,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        Icons.location_city_outlined,
                                        color: AppColors.light1000,
                                      ),
                                    ),
                                    Text(
                                      "شركة مرسال للتوصيل ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: Icon(
                              Icons.local_offer_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("عروض"),
                        ],
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColors.primary50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "اسم العرض",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "5 منتجات / وصف العرض",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.neutral400,
                                  ),
                                ),
                                Text(
                                  "₪ 1200.0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.success300,
                                  ),
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "بدلاَ من",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.neutral500,
                                      ),
                                    ),
                                    Text(
                                      "₪ 1200.0",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.error200,
                                        decoration: TextDecoration.lineThrough,
                                      ),
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
                              Icons.person_outline_rounded,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("معلومات عن بائع الخدمة"),
                        ],
                      ),
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "محمد علي",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                                                style: TextStyle(
                                                  color: AppColors.primary400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      MaterialButton(
                                        onPressed: () {},
                                        child: Container(
                                          width: 60,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary400,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
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
                                                style: TextStyle(
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
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
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
                                  Divider(
                                    color: AppColors.primary50,
                                    height: 2,
                                  ),
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
                              Icons.info_outline_rounded,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("مواصفات المنتج"),
                        ],
                      ),
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "وصف موجز: سماعة استريو logitech crystal audio للبيع كالجديدة استخدام بسيط جدا وارد الخارج بنصف الثمن سعرها 8000 بدون فصال نهائي لعدم تضيع الوقت",
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                          Text("تقييمات ومراجعات"),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.light1000,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.neutral900.withOpacity(
                                      0.3,
                                    ),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "4.5",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      spacing: 10,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.star_sharp,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        Text(
                                          "بناءً على 2,372 مراجعة",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.neutral600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "عالي",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "سيتم عرض جميع التعليقات هنا",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        "كل التعليقات",
                                        style: TextStyle(color: Colors.black),
                                      ),
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: TextStyle(fontSize: 12),
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
                                      style: TextStyle(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                              style: TextStyle(
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
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: TextStyle(fontSize: 12),
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
                                    Text(
                                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                                      style: TextStyle(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                            style: TextStyle(
                                              color: AppColors.primary400,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.sms_outlined,
                                            color: AppColors.neutral600,
                                          ),
                                        ),
                                        Text(
                                          "رد",
                                          style: TextStyle(
                                            color: AppColors.neutral600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AateneButton(
                                      buttonText: "أضف تعليقك",
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: Icon(
                              Icons.local_offer_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text("العلامات"),
                        ],
                      ),
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey[100],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Muse",
                                          style: TextStyle(fontSize: 12),
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
                    Text(
                      "المتاجر المميزة",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral300,
                      ),
                    ),
                    Container(
                      width: 170,
                      height: 270,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1520975916090-3105956dac38',
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'جديد',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: -18,
                                left: 10,
                                child: GestureDetector(
                                  onTap: toggleLike,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      size: 15,
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 5,
                                  children: [
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "(5)",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'T-Shirt Sailing',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      '21\$',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      '14\$',
                                      style: TextStyle(
                                        color: AppColors.error200,
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
                    Text(
                      "المتاجر المميزة",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral300,
                      ),
                    ),
                    Container(
                      width: 162,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neutral900,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/png/ser1.png',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'إعلان ممول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -15,
                                left: 10,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blue,
                                  child: const Icon(
                                    Icons.person_add_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          const Text(
                            '👑 EtnixByron ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            spacing: 7,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.stars_rounded,
                                size: 16,
                                color: Colors.orange,
                              ),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.neutral400,
                                ),
                              ),
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 16,
                                color: AppColors.success300,
                              ),
                              Icon(
                                Icons.shield_moon_outlined,
                                size: 16,
                                color: Colors.teal,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 200),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary400),
                      ),
                      child: Row(
                        children: [
                          AateneButton(buttonText: "buttonText"),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.primary400),
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
            ],
          ),
        ),
      ),
    );
  }
}