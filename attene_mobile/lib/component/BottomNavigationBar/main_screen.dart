import '../../general_index.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataInitializerService.to;

    // Default tabs (used for customer as well)
    List<String> names = ['الرئسية', 'منتجات', 'دردشة', 'USER'];
    List<Widget> pages = [
      HomeProduct(),
      // ManageAccountStore(),
      SearchScreen(),
      ProductScreen(),
      ChatScreen(),
      ProfilePage(),
    ];
    List<IconData> icons = const [
      Icons.home_filled,
      Icons.production_quantity_limits,
      Icons.chat_sharp,
      Icons.person_sharp,
    ];

    // ✅ Merchant tabs depend on selected store type (products/services/mixed)
    if (dataService.isMerchantUser) {
      final mode = dataService.currentStoreMode;

      final List<String> mNames = [];
      final List<Widget> mPages = [];
      final List<IconData> mIcons = [];

      // Home
      mNames.add('الرئسية');
      mPages.add(HomeProduct());
      mIcons.add(Icons.home_filled);

      /// Products tab
      // if (mode == StoreMode.products || mode == StoreMode.mixed) {
      //   mNames.add('منتجات');
      //   mPages.add(ProductScreen());
      //   mIcons.add(Icons.production_quantity_limits);
      // }

      /// Search Tab
      mNames.add('بحث');
      mPages.add(SearchScreen());
      mIcons.add(Icons.search);

      /// Services tab
      // if (mode == StoreMode.services || mode == StoreMode.mixed) {
      //   mNames.add('خدمات');
      //   mPages.add(ServicesListScreen());
      //   mIcons.add(Icons.miscellaneous_services_rounded);
      // }

      // Chat
      mNames.add('دردشة');
      mPages.add(ChatScreen());
      mIcons.add(Icons.chat_sharp);

      // User/Profile
      mNames.add('USER');
      mPages.add(HomeControl());
      mIcons.add(Icons.person_sharp);

      names = mNames;
      pages = mPages;
      icons = mIcons;
    }

    return Stack(
      children: [
        CustomBottomNavigation(
          notchWidthRatio: 0.3,
          notchDepthRatio: 0.4,
          pageName: names,
          pages: pages,
          icons: icons,
          fabIcon: Icons.add,
          fabColor: AppColors.primary400,
          selectedColor: AppColors.primary400,
          unselectedColor: Colors.grey,
          onFabTap: () => Get.to(ProductScreen()),
          // onFabTap: () => Get.to(ServiceStepperScreen()),
        ),

        /// ✅ زر مؤقت لتغيير المتجر (للتاجر فقط)
        // if (dataService.isMerchantUser)
        //   Positioned(
        //     top: MediaQuery.of(context).padding.top + 8,
        //     right: 12,
        //     child: Material(
        //       elevation: 3,
        //       borderRadius: BorderRadius.circular(12),
        //       child: InkWell(
        //         borderRadius: BorderRadius.circular(12),
        //         onTap: () async {
        //           await dataService.updateUserData({
        //             'store_id': null,
        //             'active_store_id': null,
        //             'store': null,
        //           });
        //           Get.offAllNamed('/selectStore');
        //         },
        //         child: Container(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //             vertical: 8,
        //           ),
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(12),
        //             color: Colors.white,
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: const [
        //               Icon(Icons.store_mall_directory_outlined, size: 18),
        //               SizedBox(width: 6),
        //               Text(
        //                 'تغيير المتجر',
        //                 style: TextStyle(
        //                   fontSize: 12,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
