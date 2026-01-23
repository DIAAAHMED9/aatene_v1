import 'package:flutter/material.dart';

import '../../../api/api_request.dart';
import '../../../component/text/aatene_custom_text.dart';
import '../../../utlis/colors/app_color.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "المفضلة",
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
      body: SafeArea(
        child: DefaultTabController(
          length: 5, // عدد التبويبات
          child: Column(
            children: [
              // (TabBar)
              Align(
                alignment: Alignment.centerRight,
                child: TabBar(
                  isScrollable: true,
                  // للسماح بالتمرير إذا زادت العناصر
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  labelStyle: getBold(),
                  unselectedLabelStyle: getMedium(fontSize: 14),
                  indicatorColor: AppColors.primary400,
                  indicatorWeight: 4.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // إزالة الحواف الافتراضية
                  dividerColor: Colors.grey[300],
                  tabs: const [
                    Tab(text: 'الجديد'),
                    Tab(text: 'الكل'),
                    Tab(text: 'المجموعات'),
                    Tab(text: 'المتاجر المفضلة'),
                    Tab(text: 'المنتجات'),
                  ],
                ),
              ),

              // محتوى التبويبات
              const Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text('محتوى الجديد')),
                    Center(child: Text('محتوى الكل')),
                    Center(child: Text('محتوى المجموعات')),
                    Center(child: Text('محتوى المتاجر')),
                    Center(child: Text('محتوى المنتجات')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
