import '../../../general_index.dart';
import '../widget/services_widget/big_services_card.dart';

class ServicesSection extends GetView<HomeController> {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            const SizedBox(height: 15),
            _buildImageSlider(),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.to(ServicesListScreen);
              },
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
            _buildAdsSlider(),
            JobAdvertisementCard(),
            BigServicesCard(),
            const SizedBox(height: 20),
          ],
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
              child: Obx(() => AnimatedOpacity(
                opacity: controller.imageSliderCurrentIndex.value == index ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  controller.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )),
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
              child: Obx(() => AnimatedOpacity(
                opacity: controller.adsCurrentIndex.value == index ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  controller.ads[index].image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}