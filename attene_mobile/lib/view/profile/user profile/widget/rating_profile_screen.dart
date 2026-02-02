import '../../../../general_index.dart';
import '../../../support/empty.dart';

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
                    Text("التعليقات", style: getBold(fontSize: 24)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("لويس فاندسون", style: getBold()),
                            Text(
                              "09:00 - 20 أكتوبر 2022",
                              style: getMedium(fontSize: 12),
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
                      style: getMedium(color: AppColors.neutral400),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text("الجودة", style: getBold(fontSize: 13)),
                        Icon(Icons.star, color: Colors.orange),
                        Text("4.2"),
                        Spacer(),
                        Text("التواصل", style: getBold(fontSize: 13)),
                        Icon(Icons.star, color: Colors.orange),
                        Text("4.2"),
                        Spacer(),
                        Text("التسليم ", style: getBold(fontSize: 13)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(),
                            Text(
                              "لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت دولور ماجن. لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت ",
                              style: getMedium(color: AppColors.neutral600),
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
                            Text("لويس فاندسون", style: getBold()),
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
                                style: getBold(color: AppColors.error200),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                      style: getMedium(color: AppColors.neutral400),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text("الجودة", style: getBold(fontSize: 13)),
                        Icon(Icons.star, color: Colors.orange),
                        Text("4.2"),
                        Spacer(),
                        Text("التواصل", style: getBold(fontSize: 13)),
                        Icon(Icons.star, color: Colors.orange),
                        Text("4.2"),
                        Spacer(),
                        Text("التسليم ", style: getBold(fontSize: 13)),
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
                            style: getMedium(color: AppColors.primary400),
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
                        Text("رد", style: getBold(color: AppColors.neutral600)),
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
      ),
    );
  }
}
