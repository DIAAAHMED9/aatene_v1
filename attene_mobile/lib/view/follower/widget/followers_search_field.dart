import '../../../general_index.dart';

class FollowersSearchField extends StatelessWidget {
  const FollowersSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();
    return TextField(
      controller: controller.searchController,
      onChanged: controller.onSearch,
      decoration: InputDecoration(
        hintText: 'بحث...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}