import '../../../general_index.dart';
import '../controller/profile_controller.dart';

class ChangeEmail extends StatelessWidget {
  ChangeEmail({super.key});

  final ProfileCotrolController controller = Get.put(ProfileCotrolController());

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير البريد الالكتروني",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("البريد الالكتروني", style: getMedium(fontSize: 14)),
            const SizedBox(height: 8),

            TextFiledAatene(
              isRTL: isRTL,
              hintText: "example@gmail.com",
              controller: controller.emailController,
              textInputType: TextInputType.emailAddress,
              heightTextFiled: 45,
              textInputAction: TextInputAction.send,
            ),

            const Spacer(),

            AateneButton(
              buttonText: "حفظ",
              borderColor: AppColors.primary400,
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              onTap: () async {
                final email = controller.emailController.text.trim();

                if (!GetUtils.isEmail(email)) {
                  Get.snackbar(
                    'تنبيه',
                    'الرجاء إدخال بريد إلكتروني صحيح',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }

                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                final success = await controller.updateEmail(email);

                if (Get.isDialogOpen == true) {
                  Get.back();
                }

                if (success) {
                  _showSuccessBottomSheet(context);
                } else {
                  Get.back();
                  _showSuccessBottomSheet(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text("تمت العملية بنجاح", style: getBold(fontSize: 22)),
            const SizedBox(height: 20),
            AateneButton(
              buttonText: "العودة",
              borderColor: AppColors.primary400,
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              onTap: () {
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}