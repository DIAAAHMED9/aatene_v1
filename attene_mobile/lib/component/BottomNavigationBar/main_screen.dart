import '../../general_index.dart';
import '../../services/screen/auth_required_screen.dart';
import '../../api/core/api_helper.dart';
import '../../view/home/screen/home_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataInitializerService.to;
    final bool isGuest = ApiHelper.isGuestMode;

    List<String> names = ['الرئسية', 'منتجات', 'دردشة', 'USER'];
    List<Widget> pages = [
      HomePageWithTab(),
      SearchScreen(),
      isGuest ? const AuthRequiredScreen(featureName: 'الدردشة') : ChatScreen(),
      isGuest
          ? const AuthRequiredScreen(featureName: 'الملف الشخصي')
          : ProfilePage(),
    ];
    List<IconData> icons = const [
      Icons.home_filled,
      Icons.search,
      Icons.chat_sharp,
      Icons.person_sharp,
    ];

    if (dataService.isMerchantUser) {
      final mode = dataService.currentStoreMode;

      final List<String> mNames = [];
      final List<Widget> mPages = [];
      final List<IconData> mIcons = [];

      mNames.add('الرئسية');
      mPages.add(isGuest ? SearchScreen() : HomePageWithTab());
      mIcons.add(Icons.home_filled);

      mNames.add('بحث');
      mPages.add(SearchScreen());
      mIcons.add(Icons.search);

      mNames.add('دردشة');
      mPages.add(
        isGuest
            ? const AuthRequiredScreen(featureName: 'المحادثات')
            : ChatScreen(),
      );
      mIcons.add(Icons.chat_sharp);

      mNames.add('الحساب');
      mPages.add(
        isGuest
            ? const AuthRequiredScreen(featureName: 'الحساب')
            : ProfilePage(),
      );
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
          onFabTap: () {
            final di = Get.find<DataInitializerService>();
            if (ApiHelper.isGuestMode) {
              Get.to(
                    () =>
                const AuthRequiredScreen(featureName: 'إضافة منتج/خدمة'),
              );
              return;
            }
            if (di.currentStoreMode == StoreMode.services) {
              Get.toNamed('/services-Screen');
            } else {
              Get.toNamed('/products-Screen');
              try {
                Get.find<ProductController>().navigateToAddProduct();
              } catch (_) {}
            }
          },
        ),
      ],
    );
  }
}
