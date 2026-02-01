import '../../../general_index.dart';
import '../../../api/core/api_helper.dart';
import '../../../services/screen/auth_required_screen.dart';
import '../widget/services_widget/big_services_card.dart';
import 'home_services.dart';

class HomeProduct extends StatefulWidget {
  final int initialTab;
  const HomeProduct({super.key, this.initialTab = 0});

  @override
  State<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  late final PageController _pageController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab.clamp(0, 1);
    _pageController = PageController(initialPage: _tabIndex);
  }

  void _goTo(int index) {
    if (index == _tabIndex) return;
    setState(() => _tabIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ApiHelper.isGuestMode) {
      return const AuthRequiredScreen(featureName: 'الرئيسية');
    }

    final controller = Get.find<HomeController>();

    return Scaffold(
      drawer: AateneDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(FavoritesScreen()),
                child: Container(
                  margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: AppColors.primary50),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg_images/Heart.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 22,
                      width: 22,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(NotificationPage()),
                child: Container(
                  margin: const EdgeInsets.only(right: 5.0, left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: AppColors.primary50),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg_images/Notification.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 22,
                      width: 22,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أهلاً, 👋', style: getRegular(fontSize: 14)),
            Text('اسم المستخدم', style: getMedium()),
          ],
        ),
        centerTitle: false,
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _tabIndex = i),
        children: [
          _HomeProductsContent(
            controller: controller,
            tabIndex: _tabIndex,
            onTabChange: _goTo,
          ),
          _HomeServicesContent(
            controller: controller,
            tabIndex: _tabIndex,
            onTabChange: _goTo,
          ),
        ],
      ),
    );
  }
}

class _HomeProductsContent extends StatelessWidget {
  final HomeController controller;
  final int tabIndex;
  final void Function(int) onTabChange;

  const _HomeProductsContent({
    required this.controller,
    required this.tabIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Row(
              spacing: 5,
              children: [
                Container(
                  width: 90,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.primary400),
                  ),
                  child: Center(
                    child: Row(
                      spacing: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "كل المدن",
                          style: getMedium(
                            color: AppColors.primary400,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.secondary400,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(SearchScreen()),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppColors.neutral700),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ابحث عن المطاعم، البقالة والمزيد..',
                            style: getMedium(
                              fontSize: 12,
                              color: AppColors.neutral300,
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColors.primary400,
                            child: const Icon(Icons.search, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () => onTabChange(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tabIndex == 0
                            ? AppColors.primary400
                            : AppColors.primary50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 30,
                      child: Center(
                        child: Text(
                          'منتاجات',
                          style: tabIndex == 0
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
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () => onTabChange(1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tabIndex == 1
                            ? AppColors.primary400
                            : AppColors.primary50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 30,
                      child: Center(
                        child: Text(
                          'خدمات',
                          style: tabIndex == 1
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
                  ),
                ),
              ],
            ),

            ImageSlider(),

            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextFiledAatene(
                    isRTL: isRTL,
                    hintText: "ابحث عن المنتجات التي تريدها",
                    textInputAction: TextInputAction.done,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary400,
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                    textInputType: TextInputType.name,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.primary50,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/svg_images/Filter.svg',
                      semanticsLabel: 'My SVG Image',
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ],
            ),

            TextButton(
              onPressed: () => Get.toNamed("/products-Screen"),
              child: Text(
                "اضافة منتجات (زر مؤقت لاضافة المنتجات)",
                style: getBlack(fontSize: 24, color: AppColors.primary400),
              ),
            ),

            Text("قصص", style: getBold(fontSize: 21)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PromoVideoCard(
                    model: controller.videos.first,
                    onTap: controller.openVideo,
                  ),
                ],
              ),
            ),

            TitleHome(
              title: "المتاجر المميزة",
              subtitle: "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
            ),
            VendorCard(),

            TitleHome(
              title: "منتجات تم تخصيصها لك",
              subtitle: "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
            ),
            ProductCard(),

            SizedBox(
              height: 160,
              child: PageView.builder(
                itemCount: controller.ads.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        controller.ads[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),

            ShowAllTitle(title: "عناصر جديدة"),
            ProductCard(),

          ],
        ),
      ),
    );
  }
}

class _HomeServicesContent extends StatelessWidget {
  final HomeController controller;
  final int tabIndex;
  final void Function(int) onTabChange;

  const _HomeServicesContent({
    required this.controller,
    required this.tabIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              spacing: 5,
              children: [
                Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.primary400),
                  ),
                  child: Center(
                    child: Row(
                      spacing: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "كل المدن",
                          style: getMedium(
                            color: AppColors.primary400,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.secondary400,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextFiledAatene(
                    isRTL: isRTL,
                    hintText: 'بحث',
                    filled: true,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary400,
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () => onTabChange(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tabIndex == 0
                            ? AppColors.primary400
                            : AppColors.primary50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 30,
                      child: Center(
                        child: Text(
                          'منتاجات',
                          style: tabIndex == 0
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
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: () => onTabChange(1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tabIndex == 1
                            ? AppColors.primary400
                            : AppColors.primary50,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 30,
                      child: Center(
                        child: Text(
                          'خدمات',
                          style: tabIndex == 1
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
                  ),
                ),
              ],
            ),

            ImageSlider(),

            TextButton(
              onPressed: () => Get.toNamed("/services-Screen"),
              child: Text(
                "اضافة خدمات (زر مؤقت لاضافة الخدمات)",
                style: getBlack(fontSize: 24, color: AppColors.primary400),
              ),
            ),

            Text("قصص", style: getBold(fontSize: 21)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PromoVideoCard(
                    model: controller.videos.first,
                    onTap: controller.openVideo,
                  ),
                ],
              ),
            ),

            TitleHome(
              title: "مقدمي الخدمات المميزين",
              subtitle: "أفضل البائعين موثوق بهم | ممول",
            ),
            ProfileCardSmall(),
            ShowAllTitle(title: "الخدمات الأعلى تقيماً"),
            ServicesCard(),

            SizedBox(
              height: 160,
              child: PageView.builder(
                itemCount: controller.ads.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        controller.ads[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            ),

            JobAdvertisementCard(),
            BigServicesCard(),
          ],
        ),
      ),
    );
  }
}