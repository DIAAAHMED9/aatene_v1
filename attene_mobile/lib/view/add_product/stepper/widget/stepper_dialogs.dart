import '../../../../general_index.dart';

class AddProductStepperDialogs {
  static Future<bool> confirmCancel() async {
    final result = await Get.defaultDialog<bool>(
      title: 'تأكيد الإلغاء',
      middleText: 'هل أنت متأكد من إلغاء عملية إضافة المنتج؟',

      // textConfirm: 'نعم، إلغاء',
      // textCancel: 'لا، استمر',
      // confirmTextColor: Colors.white,
      actions: [
        AateneButton(
          onTap: () {
            Get.back(result: true);
            Get.back();
          },
          buttonText: "لا،استمر",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(result: false),
          buttonText: "نعم،إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
      // cancelTextColor: AppColors.primary400,
      // buttonColor: AppColors.primary400,
      // onConfirm: () {
      //   Get.back(result: true);
      //   Get.back();
      // },
      // onCancel: () => Get.back(result: false),
    );
    return result ?? false;
  }

  static void showStepErrors({
    required Map<String, String> errors,
    required String stepName,
    required String Function(String key) fieldNameResolver,
  }) {
    if (errors.isEmpty) return;

    final errorMessages = errors.entries
        .map((e) => '• ${e.value} (${fieldNameResolver(e.key)})')
        .join('\n');

    Get.dialog(
      AlertDialog(
        title: Text('أخطاء في $stepName'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يوجد أخطاء في الحقول التالية:'),
              const SizedBox(height: 10),
              Text(errorMessages, style: getRegular(color: Colors.red)),
              const SizedBox(height: 20),
              Text(
                'يرجى تصحيح هذه الأخطاء قبل المتابعة',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          AateneButton(
            onTap: () => Get.back(),
            buttonText: "حسناً",
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
            color: AppColors.primary400,
          ),
        ],
      ),
    );
  }

  static void showSuccessDialog({
    required Map<String, dynamic> result,
    required VoidCallback onOk,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // title: Row(
        //   children: const [
        //     Icon(Icons.check_circle, color: Colors.green, size: 28),
        //     SizedBox(width: 12),
        //     Text('تمت العملية بنجاح!'),
        //   ],
        // ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            SvgPicture.asset(
              'assets/images/svg_images/done.svg',
              semanticsLabel: 'My SVG Image',
              height: 80,
              width: 80,
            ),

            Text(
              'تم إضافة المنتج بنجاح',
              style: getMedium(color: Colors.black87, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (result['data'] != null && result['data'] is List)
              Text(
                'رقم المنتج: ${_extractProductSku(result)}',
                style: getRegular(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          AateneButton(
            onTap: () => onOk,
            buttonText: "حسناً",
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
            color: AppColors.primary400,
          ),
        ],
      ),
    );
  }

  static String _extractProductSku(Map<String, dynamic> result) {
    try {
      if (result['data'] is List && (result['data'] as List).isNotEmpty) {
        final firstItem = result['data'][0] as Map<String, dynamic>;
        return firstItem['sku']?.toString() ?? 'N/A';
      }
    } catch (_) {}
    return 'N/A';
  }
}
