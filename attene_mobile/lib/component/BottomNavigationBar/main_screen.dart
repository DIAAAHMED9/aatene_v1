import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';

import 'custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      notchWidthRatio: 0.3,
      notchDepthRatio: 0.4,
      pageName: ['الرئسية', 'المنتجات', 'دردشة', 'USER'],
      pages: [
        Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: Text('الرئسية')),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: Text('المنتجات')),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: Text('دردشة')),
        ),
        Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: Text('USER')),
        ),
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
