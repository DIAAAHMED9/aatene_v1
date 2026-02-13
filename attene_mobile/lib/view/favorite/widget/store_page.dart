import '../../../general_index.dart';
import '../controller/favorite_controller.dart';
import 'empty_page.dart';
import 'favorite_card_adapter.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      if (controller.isLoading.value && controller.stores.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.stores.isEmpty) {
        return const EmptyPage();
      }
      return RefreshIndicator(
        onRefresh: () => controller.fetchFavoritesByType(FavoriteType.store, refresh: true),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.stores.length,
          itemBuilder: (context, index) {
            return FavoriteCardAdapter.buildCard('store', controller.stores[index]);
          },
        ),
      );
    });
  }
}