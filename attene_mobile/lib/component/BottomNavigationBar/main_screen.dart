

import '../../general_index.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBottomNavigation(
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
        ),

        // زر مؤقت لتغيير المتجر لاختبار المرحلة الأولى
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await DataInitializerService.to.updateUserData({
                  'store_id': null,
                  'active_store_id': null,
                  'store': null,
                });
                Get.offAllNamed('/selectStore');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.store_mall_directory_outlined, size: 18),
                    SizedBox(width: 6),
                    Text('تغيير المتجر', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}