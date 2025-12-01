import 'package:attene_mobile/demo_stepper_screen.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/Control_Panal_Vendor/vindor_home.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/chat/chat.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/profile/profile.dart';
import 'package:flutter/material.dart';

import '../../view/screens_navigator_bottom_bar/home/home.dart';
import 'custom_bottom_navigation.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      notchWidthRatio: 0.3,
      notchDepthRatio: 0.4,
      pageName: [
        'الرئسية',
        'المنتجات',
        'دردشة',
        'USER',

      ],
      pages: [
     VindorHome(),
     ProductScreen(),
     ChatScreen(),
     ProfileScreen(),

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
      onFabTap: () => debugPrint('FAB tapped'),
    );
  }
}
