import '../../../general_index.dart';

class StoreDeleteDialog extends StatelessWidget {
  final Store store;
  final VoidCallback onConfirm;

  const StoreDeleteDialog({
    super.key,
    required this.store,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('حذف المتجر'),
      content: Text('هل أنت متأكد من حذف المتجر "${store.name}"؟'),
      actions: [
        AateneButton(
          onTap: () {
            Get.back();
            onConfirm();
          },
          buttonText: "حذف",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(),
          buttonText: "إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
    );
  }
}
