import '../../../general_index.dart';
import 'inquiry_about_complaints.dart';

class CompleteAbuse extends StatelessWidget {
  const CompleteAbuse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/png/done.png'),
              Text("شكرا لك", style: getBold(fontSize: 32)),
              Text(
                "تم ارسال طلبك وهو في الطريق تحقق من بريدك الالكتروني للحصول على التفاصيل",
                style: getRegular(color: Colors.grey),
              ),
              Spacer(),
              AateneButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => InquiryAboutComplaints(),
                    ),
                  );
                },
                buttonText: "استعلام عن الشكاوى",
                color: AppColors.primary300,
                textColor: AppColors.light1000,
                borderColor: AppColors.primary300,
              ),
              AateneButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => HomeControl(),
                    ),
                  );
                },
                buttonText: "العودة للرئيسية",
                color: AppColors.primary500,
                textColor: AppColors.light1000,
                borderColor: AppColors.primary500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
