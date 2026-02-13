import '../../../general_index.dart';
import '../controller/favorite_controller.dart';
import 'empty_page.dart';
import 'favorite_card_adapter.dart';
import 'menu_group.dart';

class FavoriteListScreen extends StatelessWidget {
  final String listId;
  const FavoriteListScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchFavoritesInList(listId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(() {
          final list = controller.favoriteLists.firstWhereOrNull(
            (l) => l['id'].toString() == listId,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                list?['name'] ?? 'المجموعة',
                style: getBold(color: AppColors.neutral100, fontSize: 20),
              ),
              Text(
                '${int.tryParse(list?['favs_count']?.toString() ?? '0') ?? 0} عناصر',
                style: getMedium(color: AppColors.primary400, fontSize: 14),
              ),
            ],
          );
        }),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: const Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
        actions: [
          Obx(() {
            final list = controller.favoriteLists.firstWhereOrNull(
              (l) => l['id'].toString() == listId,
            );
            if (list == null) return const SizedBox();
            return CustomMenuWidget(
              listId: listId,
              listName: list['name'] ?? '',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.selectedList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = controller.selectedList['items'] as List? ?? [];

        if (items.isEmpty) {
          return const EmptyPage();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchFavoritesInList(listId),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final type = item['favs_type'] as String? ?? '';
              final data = item['favs'] as Map<String, dynamic>? ?? {};
              return FavoriteCardAdapter.buildCard(type, data);
            },
          ),
        );
      }),
    );
  }
}