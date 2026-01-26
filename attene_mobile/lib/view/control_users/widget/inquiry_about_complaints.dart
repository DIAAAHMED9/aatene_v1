import '../../../general_index.dart';
import 'complaints_card.dart';
import 'show_report.dart';

class InquiryAboutComplaints extends StatelessWidget {
  const InquiryAboutComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الشكاوى والاقتراحات",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text('إستعلام عن الشكاوي', style: getBold(fontSize: 18)),
              Text(
                'ما الذي تقدر أن نساعدك به ؟',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
              Row(
                spacing: 10,
                children: [
                  ComplaintsCard(
                    number: '8',
                    title: 'الاجمالي',
                    backgroundColor:
                        AppColors.backgroundColorInquiryAboutComplaints,
                    textColor: AppColors.primary400,
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "جديدة",
                    backgroundColor: AppColors.customColor04,
                    textColor: AppColors.textcolorInquiryAboutComplaints,
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "المراجعة",
                    backgroundColor: AppColors.customColor05,
                    textColor: AppColors.customColor06,
                  ),
                  ComplaintsCard(
                    number: "2",
                    title: "جديدة",
                    backgroundColor: AppColors.customColor07,
                    textColor: AppColors.customColor08,
                  ),
                ],
              ),
              Text("رقم الشكوى"),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFiledAatene(
                      isRTL: isRTL,
                      hintText: "اكتب هنا",
                      textInputAction: TextInputAction.done,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary400,
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ), textInputType: TextInputType.name,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.primary50,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/svg_images/Filter.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: AppColors.colorInquiryAboutComplaints,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Text(
                            "مشكلة في التوصيل",
                            style: getBold(fontSize: 14),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.colorShowReport,
                              border: Border.all(
                                color: AppColors.customColor02,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Center(
                                child: Text(
                                  "قيد المعالجة",
                                  style: getRegular(
                                    fontSize: 10,
                                    color: AppColors.customColor03,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Text(
                            "رقم الشكوي :",
                            style: getRegular(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            "C-2020-001",
                            style: getRegular(
                              fontSize: 10,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text(
                            "الفئة :",
                            style: getRegular(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            "خدمات",
                            style: getRegular(
                              fontSize: 10,
                              color: AppColors.primary400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            "التاريخ :",
                            style: getRegular(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            "C-2020-001",
                            style: getRegular(
                              fontSize: 10,
                              color: AppColors.primary400,
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => ShowReport(),
                            ),
                          );
                        },
                        child: Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.primary400,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: AppColors.light1000,
                                ),
                                Text(
                                  "عرض التفاصيل",
                                  style: getRegular(
                                    fontSize: 10,
                                    color: AppColors.light1000,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
