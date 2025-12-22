import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utlis/colors/app_color.dart';
import '../../utlis/language/language_utils.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قائمة الحظر",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            /// Tabs
            Row(
              children: [
                Expanded(child: _tabButton(text: 'مستخدمين', selected: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: _tabButton(text: 'متاجر', selected: false),
                ),
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
            ),

            /// List
            Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return _blockItem();
                },
              ),
            ),
          ],
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
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF3E5C7F),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _blockItem() {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          /// Avatar
          const CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),

          /// Name + block
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ahmed Ali',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                '@ahmed',
                style: TextStyle(color: Colors.grey, fontSize: 13),
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
            child: Center(
              child: Text(
                'إلغاء الحظر',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
