import '../../../general_index.dart';
import '../controller/favorite_controller.dart';
import 'empty_page.dart';
import 'favorite_card_adapter.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Obx(() {
      if (controller.recentFavorites.isEmpty) {
        return const EmptyPage();
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.recentFavorites.length,
        itemBuilder: (context, index) {
          final item = controller.recentFavorites[index];
          final type = item['favs_type'] as String? ?? '';
          final data = item['favs'] as Map<String, dynamic>? ?? {};
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['cover'] ?? data['logo'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            title: Text(data['name'] ?? data['title'] ?? ''),
            subtitle: Text(type),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => controller.removeFromFavorites(
                type: _parseType(type),
                itemId: data['id'].toString(),
              ),
            ),
          );
        },
      );
    });
  }

  FavoriteType _parseType(String type) {
    switch (type) {
      case 'product': return FavoriteType.product;
      case 'service': return FavoriteType.service;
      case 'store': return FavoriteType.store;
      case 'blog': return FavoriteType.blog;
      default: return FavoriteType.product;
    }
  }
}