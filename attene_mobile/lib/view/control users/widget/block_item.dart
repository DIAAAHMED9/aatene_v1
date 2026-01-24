import '../../../general_index.dart';

class BlockItem extends StatelessWidget {
  final BlockEntry entry;
  final int index;
  final int tab;

  BlockItem({
    super.key,
    required this.entry,
    required this.index,
    required this.tab,
  });

  final controller = Get.find<BlockController>();

  @override
  Widget build(BuildContext context) {
    final avatar = (entry.avatar ?? '').trim();
    final hasAvatar = avatar.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey[200],
            backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
            child: hasAvatar
                ? null
                : Icon(
                    entry.type.toLowerCase() == 'store'
                        ? Icons.store
                        : Icons.person,
                    color: Colors.grey[600],
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.displayName,
              style: getBold(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
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
          style: getBold(color: AppColors.primary500, fontSize: 20),
        ),
        content: Text('هل أنت متأكد من إلغاء الحظر؟', style: getMedium()),
        actions: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary400),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextButton(
              onPressed: Get.back,
              child: Text(
                'إلغاء',
                style: getMedium(color: AppColors.primary400),
              ),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),

            child: TextButton(
              onPressed: () {
                Get.back(); // ⬅️ إغلاق الـ Dialog أولاً
                controller.unblock(tab: tab, index: index);
              },
              child: Text(
                'تأكيد',
                style: getMedium(color: AppColors.light1000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
