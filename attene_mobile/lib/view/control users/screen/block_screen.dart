import '../../../general_index.dart';

class BlockScreen extends StatelessWidget {
  BlockScreen({super.key});

  final controller = Get.put(BlockController());

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قائمة الحظر",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
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
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Obx(
              () => GenericTabs(
                tabs: const ['مستخدمين', 'متاجر'],
                selectedIndex: controller.currentIndex.value,
                onTap: controller.changeTab,
                selectedColor: AppColors.primary500,
                unSelectedColor: AppColors.customColor10,
              ),
            ),
            const SizedBox(height: 12),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: 'بحث',
              textInputAction: TextInputAction.done,
              onChanged: controller.onSearch, textInputType: TextInputType.name,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const BlockSkeleton();
                }

                return PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    Obx(
                      () => ListView.builder(
                        itemCount: controller.filteredUsers.length,
                        itemBuilder: (_, i) => BlockItem(
                          entry: controller.filteredUsers[i],
                          index: i,
                          tab: 0,
                        ),
                      ),
                    ),
                    Obx(
                      () => ListView.builder(
                        itemCount: controller.filteredStores.length,
                        itemBuilder: (_, i) => BlockItem(
                          entry: controller.filteredStores[i],
                          index: i,
                          tab: 1,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
