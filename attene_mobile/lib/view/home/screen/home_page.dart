import '../../../general_index.dart';
import '../../../api/core/api_helper.dart';
import '../../../services/screen/auth_required_screen.dart';

class HomePageWithTab extends GetView<HomeController> {
  const HomePageWithTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (ApiHelper.isGuestMode) {
      return const AuthRequiredScreen(featureName: 'الرئيسية');
    }
    
    return Scaffold(
      drawer: AateneDrawer(),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // الجزء العلوي الثابت
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                _buildLocationAndSearch(),
                const SizedBox(height: 15),
                _buildToggleButtons(),
              ],
            ),
          ),
          // منطقة PageView الرئيسية
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              children: const [
                ProductsSection(),
                ServicesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        Row(
          children: [
            _buildIconButton(
              iconPath: 'assets/images/svg_images/Heart.svg',
              onPressed: () => Get.to(FavoritesScreen()),
              margin: const EdgeInsets.only(right: 5.0, left: 5.0),
            ),
            _buildIconButton(
              iconPath: 'assets/images/svg_images/Notification.svg',
              onPressed: () => Get.to(NotificationPage()),
              margin: const EdgeInsets.only(right: 5.0, left: 10.0),
            ),
          ],
        ),
      ],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('أهلاً, 👋', style: getMedium(fontSize: 14)),
          Text('اسم المستخدم', style: getMedium()),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required VoidCallback onPressed,
    required EdgeInsets margin,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: AppColors.primary50),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          iconPath,
          semanticsLabel: 'My SVG Image',
          height: 22,
          width: 22,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildLocationAndSearch() {
    return Row(
      children: [
        // زر المدينة
        Container(
          width: 90,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.primary400),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "كل المدن",
                  style: getMedium(
                    color: AppColors.primary400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.secondary400,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        // حقل البحث
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(SearchScreen());
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.neutral700),
              ),
              child: Row(
                children: [
                  Obx(() => Text(
                    controller.currentPage.value == 0
                        ? 'ابحث عن المتاجر أو المنتجات التي تريدها'
                        : 'ابحث عن المتاجر أو الخدمات التي تريدها',
                    style: getMedium(
                      fontSize: 12,
                      color: AppColors.neutral300,
                    ),
                  )),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: AppColors.primary400,
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => MaterialButton(
            onPressed: () {
              if (controller.currentPage.value != 0) {
                controller.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: controller.currentPage.value == 0
                    ? AppColors.primary400
                    : AppColors.primary50,
                borderRadius: BorderRadius.circular(50),
              ),
              height: 30,
              child: Center(
                child: Text(
                  'منتجات',
                  style: controller.currentPage.value == 0
                      ? getBlack(
                          fontSize: 14,
                          color: AppColors.light1000,
                        )
                      : getMedium(
                          fontSize: 12,
                          color: AppColors.primary400,
                        ),
                ),
              ),
            ),
          )),
        ),
        Expanded(
          child: Obx(() => MaterialButton(
            onPressed: () {
              if (controller.currentPage.value != 1) {
                controller.pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: controller.currentPage.value == 1
                    ? AppColors.primary400
                    : AppColors.primary50,
                borderRadius: BorderRadius.circular(50),
              ),
              height: 30,
              child: Center(
                child: Text(
                  'خدمات',
                  style: controller.currentPage.value == 1
                      ? getBlack(
                          fontSize: 14,
                          color: AppColors.light1000,
                        )
                      : getMedium(
                          fontSize: 12,
                          color: AppColors.primary400,
                        ),
                ),
              ),
            ),
          )),
        ),
      ],
    );
  }
}