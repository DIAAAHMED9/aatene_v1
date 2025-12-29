import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/text/aatene_custom_text.dart';
import '../controller/block_controller.dart';

class BlockItem extends StatelessWidget {
  final String name;
  final int index;
  final int tab;

  BlockItem({
    super.key,
    required this.name,
    required this.index,
    required this.tab,
  });

  final controller = Get.find<BlockController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 10),
          Text(name, style: getBold()),
          const Spacer(),
          GestureDetector(
            onTap: _confirmDialog,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'إلغاء الحظر',
                  style: getRegular(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'تأكيد',
          style: getBold(color: AppColors.primary500, fontSize: 18),
        ),
        content: Text('هل أنت متأكد من إلغاء الحظر؟', style: getMedium()),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('إلغاء', style: getRegular()),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // ⬅️ إغلاق الـ Dialog أولاً
              controller.unblock(tab: tab, index: index);
            },
            child: Text('تأكيد', style: getRegular(color: AppColors.error300)),
          ),
        ],
      ),
    );
  }
}
