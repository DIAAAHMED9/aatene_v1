import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/aatene_text_filed.dart';
import '../../../../component/text/aatene_custom_text.dart';
import '../../../../utlis/colors/app_color.dart';
import '../../../../utlis/language/language_utils.dart';
import '../controller/followers_controller.dart';
import '../widgets/follower_item.dart';
import '../widgets/followers_tabs.dart';


class Followers extends StatelessWidget {
  Followers({super.key});

  final controller = Get.put(FollowersController());

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قائمة المتابعين",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FollowersTabs(),

            const SizedBox(height: 12),

            Row(
              children: [
                Text("350K", style: getBold(fontSize: 18)),
                const SizedBox(width: 6),
                Text("متابع", style: getRegular(fontSize: 18)),
              ],
            ),

            const SizedBox(height: 12),

            TextFiledAatene(
              isRTL: isRTL,
              hintText: "بحث",
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary400,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.search, color: AppColors.light1000),
                ),
              ), textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: const [
                  _FollowersList(),
                  _FollowersList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowersList extends StatelessWidget {
  const _FollowersList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, __) =>  FollowerItem(),
    );
  }
}
