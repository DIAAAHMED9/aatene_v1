import '../../../general_index.dart';

class ProductsSection extends GetView<HomeController> {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _buildImageSlider(),
            const SizedBox(height: 15),
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
            _buildAdsSlider(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'أحذية',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          fontFamily: 'PingAR',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF1F7),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          '530',
                          style: TextStyle(
                            color: Color(0xFF4186F5),
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
                  "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(String imageUrl) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
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

  Widget _buildImageSlider() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: controller.images.length,
        onPageChanged: controller.onImageSliderPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.imageSliderCurrentIndex.value == index
                      ? 1.0
                      : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    controller.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdsSlider() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: controller.ads.length,
        onPageChanged: controller.onAdsPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.adsCurrentIndex.value == index
                      ? 1.0
                      : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    controller.ads[index].image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
