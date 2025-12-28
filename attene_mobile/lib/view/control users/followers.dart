import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/text/aatene_custom_text.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              /// Tabs
              Row(
                children: [
                  Expanded(
                    child: _tabButton(text: 'أشخاص تتابعهم', selected: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _tabButton(text: 'المتابعين', selected: false),
                  ),
                ],
              ),

              Row(
                spacing: 10,
                children: [
                  Text("350K", style: getBold(fontSize: 18)),
                  Text("متابع", style: getRegular(fontSize: 18)),
                ],
              ),

              /// Search
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "بحث",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary400,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.search, color: AppColors.light1000),
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 8),

              /// List
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return _followerItem();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _tabButton({required String text, required bool selected}) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3E5C7F) : const Color(0xFFDCE6F3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: getMedium(
          color: selected ? Colors.white : AppColors.primary400
        ),
      ),
    );
  }

  static Widget _followerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          /// Avatar
          const CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),

          /// Name + followers
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('SideLimited', style: getBold(fontSize: 15)),
              SizedBox(height: 4),
              Text(
                '249K متابعين',
                style: getRegular(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),

          const Spacer(),

          /// Follow back button
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF3E5C7F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.person_add_alt, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'رد المتابعة',
                  style: getRegular(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
