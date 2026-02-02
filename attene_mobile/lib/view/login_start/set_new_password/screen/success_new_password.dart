import 'package:attene_mobile/general_index.dart';

class SuccessNewPassword extends StatelessWidget {
  const SuccessNewPassword({super.key});

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
              Text("تم تعديل كلمة المرور بنجاح", style: getBold(fontSize: 32)),
              Text(
                "يمكنك الآن استخدام كلمة المرور الجديدة لتسجيل الدخول علي التطبيق",
                style: getMedium(color: Colors.grey),
              ),
              Spacer(),
              AateneButton(
                onTap: () {
                  Get.offAllNamed('/Login');
                },
                buttonText: "العودة لتسجيل الدخول",
                color: AppColors.primary300,
                textColor: AppColors.light1000,
                borderColor: AppColors.primary300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}