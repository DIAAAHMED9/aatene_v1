

import '../../../general_index.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FollowersController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'قائمة المتابعين',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const FollowersTabBar(),
            const SizedBox(height: 16),
            const SearchField(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                    () => ListView.separated(
                  itemCount: controller.filteredFollowers.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return FollowerItem(
                      model: controller.filteredFollowers[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
