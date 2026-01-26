import '../../../general_index.dart';
import '../widget/services_widget/big_services_card.dart';

class HomeServices extends GetView<HomeController> {
  const HomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      drawer: AateneDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Container(
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
              Container(
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
      body: SingleChildScrollView(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => HomeProduct(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 30,
                        child: Center(
                          child: Text(
                            'منتاجات',
                            style: getMedium(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => HomeServices(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 30,
                        child: Center(
                          child: Text(
                            'خدمات',
                            style: getBlack(
                              fontSize: 14,
                              color: AppColors.light1000,
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
              JobAdvertisementCard(),
              BigServicesCard(),
            ],
          ),
        ),
      ),
    );
  }
}
