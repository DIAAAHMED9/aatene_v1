import '../../../general_index.dart';
import '../widget/inquiry_about_complaints.dart';
import '../widget/report_abuse.dart';
import '../widget/report_card.dart';

class SellectReport extends StatelessWidget {
  const SellectReport({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Text(
                "نحن نقدر ملاحظاتك واقتراحاتك ونحن هنا لمساعدتك في حل مشاكلك والاستماع إلى اقتراحاتك",
                style: getRegular(fontSize: 10, color: AppColors.neutral400),
              ),
              ReportCard(
                image: Image.asset(
                  'assets/images/png/report1.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                title: "إستعلام عن الشكاوي",
                screen: InquiryAboutComplaints(),
              ),
              ReportCard(
                image: Image.asset(
                  'assets/images/png/report2.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                title: "شكوى أو إفتراح",
                screen: ReportAbuseScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
