import '../../../general_index.dart';
import '../controller/favorite_controller.dart';
import 'empty_page.dart';
import 'favorite_card_adapter.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      if (controller.isLoading.value && controller.allFavorites.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasError.value && controller.allFavorites.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchAllFavorites(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      if (controller.allFavorites.isEmpty) {
        return const EmptyPage();
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchAllFavorites(),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.allFavorites.length,
          itemBuilder: (context, index) {
            final item = controller.allFavorites[index];
            final type = item['favs_type'] as String? ?? '';
            final data = item['favs'] as Map<String, dynamic>? ?? {};
            return FavoriteCardAdapter.buildCard(type, data);
          },
        ),
      );
    });
  }
}