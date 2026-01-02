

import '../../general_index.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      notchWidthRatio: 0.3,
      notchDepthRatio: 0.4,
      pageName: ['الرئسية', 'منتجات', 'دردشة', 'USER'],
      pages: [
        ManageAccountStore(),
        ProductScreen(),
        ChatScreen(),
        ServicesListScreen(),
      ],
      icons: const [
        Icons.home_filled,
        Icons.production_quantity_limits,
        Icons.chat_sharp,
        Icons.person_sharp,
      ],
      fabIcon: Icons.add,
      fabColor: AppColors.primary400,
      selectedColor: AppColors.primary400,
      unselectedColor: Colors.grey,
      onFabTap: () => Get.to(ServiceStepperScreen()),
    );
  }
}