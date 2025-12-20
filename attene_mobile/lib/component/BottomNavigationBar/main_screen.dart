import 'package:attene_mobile/add_product_stepper_screen.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/add%20new%20store/choose_type_store/manage_account_store.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../five_step_screen.dart';
import '../../view/add_services/services_list_screen.dart';
import '../../view/products/product_screen.dart';
import 'custom_bottom_navigation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      notchWidthRatio: 0.3,
      notchDepthRatio: 0.4,
      pageName: ['الرئسية', 'المنتجات', 'دردشة', 'USER'],
      pages: [
        // لا تغلف الصفحات بأي شيء إضافي - دع CustomBottomNavigation يتعامل مع التمرير
        ManageAccountStore(),
        ProductScreen(),
        ChatScreen(),
        ServicesListScreen(),
      ],
      icons: const [
        Icons.home,
        Icons.production_quantity_limits,
        Icons.chat_bubble_outline,
        Icons.person,
      ],
      fabIcon: Icons.add,
      fabColor: AppColors.primary400,
      selectedColor: AppColors.primary400,
      unselectedColor: Colors.grey,
      onFabTap: () => Get.to(ServiceStepperScreen()),
    );
  }
}