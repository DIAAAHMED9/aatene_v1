import '../../../general_index.dart';
import '../../../api/core/api_helper.dart';
import '../../../services/screen/auth_required_screen.dart';

class HomeProduct extends GetView<HomeController> {
  const HomeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    if (ApiHelper.isGuestMode) {
      return const AuthRequiredScreen(featureName: 'الرئيسية');
    }
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      drawer: AateneDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(FavoritesScreen());
                },
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
                    onPressed: () {
                      Get.to(FavoritesScreen());
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(FavoritesScreen());
                },
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
                    onPressed: () {
                      Get.to(NotificationPage());
                    },
                  ),
                ),
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
      ),
      body: SingleChildScrollView(
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
                      onTap: () {
                        Get.to(SearchScreen());
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColors.neutral700),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'ابحث عن المتاجر أو المنتجات التي تريدها',
                              style: getMedium(
                                fontSize: 12,
                                color: AppColors.neutral300,
                              ),
                            ),
                            Spacer(),
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
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(HomeProduct());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 30,
                        child: Center(
                          child: Text(
                            'منتجات',
                            style: getBlack(
                              fontSize: 14,
                              color: AppColors.light1000,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(HomeServices());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 30,
                        child: Center(
                          child: Text(
                            'خدمات',
                            style: getMedium(
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
              // Row(
              //   spacing: 10,
              //   children: [
              //     Expanded(
              //       child: TextFiledAatene(
              //         isRTL: isRTL,
              //         hintText: "ابحث عن المنتجات التي تريدها",
              //         textInputAction: TextInputAction.done,
              //         suffixIcon: Padding(
              //           padding: const EdgeInsets.all(5),
              //           child: CircleAvatar(
              //             backgroundColor: AppColors.primary400,
              //             child: const Icon(Icons.search, color: Colors.white),
              //           ),
              //         ),
              //         textInputType: TextInputType.name,
              //       ),
              //     ),
              //     CircleAvatar(
              //       backgroundColor: AppColors.primary50,
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: SvgPicture.asset(
              //           'assets/images/svg_images/Filter.svg',
              //           semanticsLabel: 'My SVG Image',
              //           height: 18,
              //           width: 18,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              TextButton(
                onPressed: () {
                  Get.to(ProductScreen);
                },
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
                height: 160, // نفس ارتفاع الإعلان تقريبًا
                child: PageView.builder(
                  itemCount: controller.ads.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        // زوايا ناعمة مثل الصورة
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "هل أنت بائع جديد؟",
                              style: getBold(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "قم بإنشاء متجرك الخاص وابدأ في البيع اليوم!",
                              style: getMedium(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(ManageAccountStore());
                                // تنفيذ الإجراء المطلوب عند الضغط على الزر
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                "ابدأ الآن",
                                style: getMedium(
                                  color: AppColors.light1000,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/png/cover.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              ProductCardUI(),
              ShowAllTitle(title: "فئات"),
              Container(
                // The main card container
                padding: const EdgeInsets.all(12.0),
                width: 165,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The 2x2 Image Grid
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildImageItem(
                                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&q=80',
                              ),
                              const SizedBox(width: 8),
                              _buildImageItem(
                                'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=300&q=80',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildImageItem(
                                'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=300&q=80',
                              ),
                              const SizedBox(width: 8),
                              _buildImageItem(
                                'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=300&q=80',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // The Bottom Row with Text and Number Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Arabic Text "أحذية"
                        const Text(
                          'أحذية',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            fontFamily:
                                'PingAR', // Use a font that supports Arabic well
                          ),
                        ),
                        // Number Badge "530"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF1F7),
                            // Light grey-blue background
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Text(
                            '530',
                            style: TextStyle(
                              color: Color(0xFF4186F5), // Blue text color
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ShowAllTitle(title: "الأكثر شعبية"),
              ProductCard(),
              PromotionalCard(),
              ShowAllTitle(title: "المنتج الموصى به"),
              DistinctProduct(
                storeName: "storeName",
                productName: "productName",
                description: "description",
                price: 6,
                oldPrice: 8,
                rating: 4,
                imageUrl: "imageUrl",
              ),
              StoreCard(
                storeName: "EtnixByron",
                description:
                    "متجر إلكتروني متخصص في أحدث صيحات الموضة والأزياء العصرية للشباب والشابات",
                rating: 5.0,
                imagePath:
                    "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80", // صورة تعبيرية
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(String imageUrl) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1, // Keeps the images square
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
<<<<<<< HEAD

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
=======
>>>>>>> ba3d79ec1ed78a2a6c460ab2b593a67393a9188e
