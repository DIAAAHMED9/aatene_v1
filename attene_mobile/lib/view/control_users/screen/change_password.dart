import '../../../general_index.dart';
import '../controller/profile_controller.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final ProfileCotrolController controller = Get.put(ProfileCotrolController());

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير كلمة المرور",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Text("كلمة المرور الجديدة", style: getMedium(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              controller: controller.newPasswordController,
              hintText: '********',
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),

            Text("تأكيد كلمة المرور الجديدة", style: getMedium(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              controller: controller.confirmPasswordController,
              hintText: '********',
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),

            Spacer(),

            AateneButton(
              buttonText: "حفظ",
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              textColor: AppColors.light1000,
              onTap: () async {
                if (controller.newPasswordController.text !=
                    controller.confirmPasswordController.text) {
                  Get.snackbar(
                    'خطأ',
                    'كلمتا المرور غير متطابقتين',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                Get.dialog(
                  const Center(child: CircularProgressIndicator.adaptive()),
                  barrierDismissible: false,
                );

                final success = await controller.updatePassword();

                if (Get.isDialogOpen == true) Get.back();
                _successBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _successBottomSheet(BuildContext context) {
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
            const SizedBox(height: 10),
            Text(
              "تم إعادة تعيين كلمة المرور بنجاح",
              style: getMedium(fontSize: 12),
            ),
            const SizedBox(height: 20),
            AateneButton(
              buttonText: "العودة",
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
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