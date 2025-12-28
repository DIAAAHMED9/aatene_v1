import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/aatene_text_filed.dart';
import '../../../../utlis/language/language_utils.dart';
import '../controller/block_controller.dart';
import '../widgets/block_item.dart';
import '../widgets/block_skeleton.dart';
import '../widgets/generic_tabs.dart';

class BlockScreen extends StatelessWidget {
  BlockScreen({super.key});

  final controller = Get.put(BlockController());

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الحظر')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Obx(() {
              return GenericTabs(
                tabs: const ['مستخدمين', 'متاجر'],
                selectedIndex: controller.currentIndex.value,
                onTap: controller.changeTab,
                selectedColor: const Color(0xFF3E5C7F),
                unSelectedColor: const Color(0xFFDCE6F3),
              );
            }),

            const SizedBox(height: 12),

            TextFiledAatene(
              isRTL: isRTL,
              hintText: 'بحث',
              textInputAction: TextInputAction.done,
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
                        itemCount: controller.blockedUsers.length,
                        itemBuilder: (_, i) => BlockItem(
                          name: controller.blockedUsers[i],
                          index: i,
                          isStore: false,
                        ),
                      ),
                    ),
                    Obx(
                      () => ListView.builder(
                        itemCount: controller.blockedStores.length,
                        itemBuilder: (_, i) => BlockItem(
                          name: controller.blockedStores[i],
                          index: i,
                          isStore: true,
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
