import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/favorite/widget/add_group_bottom_sheet.dart';

import '../controller/favorite_controller.dart';

class AddToListBottomSheet extends StatelessWidget {
  final FavoriteType itemType;
  final String itemId;
  final Map<String, dynamic> itemData;

  const AddToListBottomSheet({
    super.key,
    required this.itemType,
    required this.itemId,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
    final selectedListId = Rxn<String>();

    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('اختر مجموعة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  itemData['cover'] ?? itemData['logo'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemData['name'] ?? itemData['title'] ?? 'عنصر',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      itemType.name,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (controller.favoriteLists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لا توجد مجموعات'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddGroupBottomSheet(),
                          );
                        },
                        child: const Text('إنشاء مجموعة جديدة'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.favoriteLists.length,
                itemBuilder: (context, index) {
                  final list = controller.favoriteLists[index];
                  return RadioListTile<String>(
                    title: Text(list['name'] ?? ''),
                    subtitle: Text('${list['favs_count'] ?? 0} عناصر'),
                    secondary: Icon(
                      list['is_private'] == 1 ? Icons.lock : Icons.public,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    value: list['id'].toString(),
                    groupValue: selectedListId.value,
                    onChanged: (value) => selectedListId.value = value,
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AateneButton(
                  onTap: () => Get.back(),
                  buttonText: 'إلغاء',
                  color: AppColors.light1000,
                  textColor: AppColors.primary400,
                  borderColor: AppColors.primary400,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => AateneButton(
                  onTap: selectedListId.value == null
                      ? null
                      : () async {
  final success = await controller.addToFavorites(
    type: itemType,
    itemId: itemId,
    listId: selectedListId.value,
  );
  if (success) {
    Get.back();
  }
},
                  buttonText: 'إضافة',
                  color: selectedListId.value == null
                      ? AppColors.neutral300
                      : AppColors.primary400,
                  textColor: AppColors.light1000,
                  borderColor: selectedListId.value == null
                      ? AppColors.neutral300
                      : AppColors.primary400,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}