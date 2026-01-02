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
        TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('حذف'),
        ),
      ],
    );
  }
}
