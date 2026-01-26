import '../../../../general_index.dart';
import '../../user_profile/widget/review_sheet.dart';

class RatingProfile extends StatelessWidget {
  const RatingProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.light1000,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neutral900.withOpacity(0.3),
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
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.star_sharp, color: Colors.orange, size: 20),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("كل التعليقات", style: TextStyle(color: Colors.black)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "لويس فاندسون",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                          icon: Icon(Icons.flag_outlined, color: Colors.red),
                        ),
                      ],
                    ),
                    Text(
                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                      style: TextStyle(color: AppColors.neutral400),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          "الجودة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text(
                          "التواصل",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text(
                          "التسليم ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(),
                            Text(
                              "لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت دولور ماجن. لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت ",
                              style: TextStyle(color: AppColors.neutral600),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "لويس فاندسون",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: AppColors.neutral400),
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          "الجودة",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text(
                          "التواصل",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text(
                          "التسليم ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text("4.2", style: TextStyle(fontSize: 14)),
                      ],
                    ),

                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            " مفيد 5m",
                            style: TextStyle(color: AppColors.primary400),
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          builder: (context) => const ReviewSheet(),
                        );
                      },
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
      ),
    );
  }
}
