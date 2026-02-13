import 'package:attene_mobile/general_index.dart';

import 'package:share_plus/share_plus.dart';

import '../controller/favorite_controller.dart';
import 'add_group_bottom_sheet.dart';

class CustomMenuWidget extends StatelessWidget {
  final String listId;
  final String listName;

  const CustomMenuWidget({super.key, required this.listId, required this.listName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 10,
      offset: const Offset(0, 50),
      icon: const Icon(Icons.more_vert, color: AppColors.primary300),
      onSelected: (value) async {
        switch (value) {
          case 'rename':
            final list = controller.favoriteLists.firstWhereOrNull((l) => l['id'].toString() == listId);
            if (list != null) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddGroupBottomSheet(listToEdit: list),
              );
            }
            break;
          case 'share':
            SharePlus.instance.share(
              ShareParams(
                title: 'مجموعة $listName',
                text: 'شاهد مجموعتي "$listName" في تطبيق أعطيني',
              ),
            );
            break;
          case 'delete':
            _showDeleteConfirmation(context, controller, listId);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(
          value: 'rename',
          text: 'إعادة تسمية',
          iconPath: 'assets/images/svg_images/Edit1.svg',
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          value: 'share',
          text: 'مشاركة',
          iconPath: 'assets/images/svg_images/Send.svg',
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          value: 'delete',
          text: 'حذف المجموعة',
          iconPath: 'assets/images/svg_images/Delete.svg',
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, FavoriteController controller, String listId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المجموعة'),
        content: const Text('هل أنت متأكد من حذف المجموعة؟ سيؤدي ذلك لحذف جميع العناصر الموجودة بداخلها.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteFavoriteList(listId);
              Get.back();
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String text,
    required String iconPath,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 18, height: 18),
          const SizedBox(width: 12),
          Text(text, style: getMedium()),
        ],
      ),
    );
  }

  PopupMenuEntry<String> _buildDivider() {
    return const PopupMenuDivider(height: 1);
  }
}
