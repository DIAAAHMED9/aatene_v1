import '../../../general_index.dart';
import 'complete_abuse.dart';

class ReportAddAbuse extends StatelessWidget {
  const ReportAddAbuse({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary400, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral700.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(4, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الإبلاغ عن إساءة', style: getBold(fontSize: 18)),
                  Text(
                    'ما الذي تقدر أن نساعدك به ؟',
                    style: getRegular(fontSize: 12, color: Colors.grey),
                  ),

                  Text('الموضوع', style: getRegular(fontSize: 14)),
                  TextFiledAatene(
                    isRTL: isRTL,
                    hintText: "اكتب هنا",
                    textInputAction: TextInputAction.next, textInputType: TextInputType.name,
                  ),

                  Text('الشكوى/ الأفتراح', style: getRegular(fontSize: 14)),
                  TextFiledAatene(
                    isRTL: isRTL,
                    hintText: "اكتب هنا",
                    textInputType: TextInputType.multiline,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 10),
                  AateneButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => CompleteAbuse(),
                        ),
                      );
                    },
                    buttonText: "ارسال",
                    color: AppColors.primary400,
                    textColor: AppColors.light1000,
                    borderColor: AppColors.primary400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
