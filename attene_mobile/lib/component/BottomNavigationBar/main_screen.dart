import '../../general_index.dart';
import '../../services/screen/auth_required_screen.dart';
import '../../api/core/api_helper.dart';
import '../../view/home/screen/home_page.dart';
import '../../services/app_view_mode.dart';
import '../../view/control_panel_vendor/screen/vindor_home.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

final dataService = DataInitializerService.to;
final bool isGuest = ApiHelper.isGuestMode;
final box = GetStorage();

AppViewMode viewMode = AppViewModeX.fromKey(box.read('app_view_mode')?.toString());

if (viewMode.isMerchant && !dataService.isMerchantUser) {
  viewMode = AppViewMode.user;
  box.write('app_view_mode', viewMode.key);
}

final bool isMerchantView = viewMode.isMerchant;

List<String> names;
List<Widget> pages;
List<IconData> icons;

if (!isMerchantView) {
  names = ['الرئسية', 'منتجات', 'دردشة', 'USER'];
  pages = [
    HomePageWithTab(),
    SearchScreen(),
    isGuest ? const AuthRequiredScreen(featureName: 'الدردشة') : ChatScreen(),
    isGuest
        ? const AuthRequiredScreen(featureName: 'الملف الشخصي')
        : ProfilePage(),
  ];
  icons = const [
    Icons.home_filled,
    Icons.search,
    Icons.chat_sharp,
    Icons.person_sharp,
  ];
} else {
  names = ['الرئسية', 'بحث', 'دردشة', 'الحساب'];
  pages = [
    DashboardView(),
    SearchScreen(),
    isGuest ? const AuthRequiredScreen(featureName: 'المحادثات') : ChatScreen(),
    isGuest ? const AuthRequiredScreen(featureName: 'الحساب') : ProfilePage(),
  ];
  icons = const [
    Icons.home_filled,
    Icons.search,
    Icons.chat_sharp,
    Icons.person_sharp,
  ];
}

final bool showFab = isMerchantView;
final bool isServices = viewMode == AppViewMode.merchantServices;

    return Stack(
      children: [
        CustomBottomNavigation(
          showFab: showFab,
          notchWidthRatio: 0.3,
          notchDepthRatio: 0.4,
          pageName: names,
          pages: pages,
          icons: icons,
          fabIcon: Icons.add,
          fabColor: AppColors.primary400,
          selectedColor: AppColors.primary400,
          unselectedColor: Colors.grey,
          onFabTap: !showFab
            ? null
            : () {
                if (ApiHelper.isGuestMode) {
                  Get.to(
                    () => const AuthRequiredScreen(featureName: 'إضافة منتج/خدمة'),
                  );
                  return;
                }

                if (isServices) {
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