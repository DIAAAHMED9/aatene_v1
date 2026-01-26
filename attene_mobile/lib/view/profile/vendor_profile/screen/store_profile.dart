import 'package:attene_mobile/general_index.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../user profile/widget/rating_profile_screen.dart';
import '../../user profile/widget/sellect_report.dart';
import '../../user_profile/widget/story_items.dart';
import '../widget/offers.dart';
import '../widget/store_states.dart';

class StoreProfilePage extends StatefulWidget {
  const StoreProfilePage({super.key});

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 1. الجزء العلوي (صورة الغلاف فقط)
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                elevation: 0,
                leading: _buildCircleIcon(
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  _buildCircleIcon(
                    SvgPicture.asset(
                      "assets/images/svg_images/waze.svg",
                      height: 20,
                      width: 20,
                      color: Colors.black,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _buildCircleIcon(
                    Icon(Icons.favorite_border, color: Colors.black, size: 20),
                  ),
                  _buildCircleIcon(
                    GestureDetector(
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.black,
                        size: 20,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          elevation: 5,
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 20,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "المزيد",
                                    textAlign: TextAlign.center,
                                    style: getMedium(fontSize: 18),
                                  ),

                                  ///ارسال رسالة
                                  GestureDetector(
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg_images/massages.svg',
                                          semanticsLabel: 'My SVG Image',
                                          height: 32,
                                          width: 32,
                                          color: AppColors.neutra90,
                                        ),
                                        Text(
                                          "ارسل رسالة",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///تفعيل الاشعارات
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SizedBox(
                                          height: 320,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                20.0,
                                              ),
                                              child: Column(
                                                spacing: 15,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "اشعارات",
                                                    style: getMedium(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    title: Text(
                                                      "اشعارات المنتجات الجديدة",
                                                      style: getMedium(),
                                                    ),
                                                    trailing: Switch(
                                                      value: true,
                                                      onChanged: (value) {},
                                                      activeColor: Colors.green,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    title: Text(
                                                      "اشعارات العروض",
                                                      style: getMedium(),
                                                    ),
                                                    trailing: Switch(
                                                      value: false,
                                                      onChanged: (value) {},
                                                      activeColor: Colors.green,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    title: Text(
                                                      "اشعارات القصص",
                                                      style: getMedium(),
                                                    ),
                                                    trailing: Switch(
                                                      value: false,
                                                      onChanged: (value) {},
                                                      activeColor: Colors.green,
                                                    ),
                                                  ),
                                                  AateneButton(
                                                    buttonText: "احفظ اختياري",
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    borderColor:
                                                        AppColors.primary400,
                                                    textColor:
                                                        AppColors.light1000,
                                                    color: AppColors.primary400,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg_images/notofication.svg',
                                          semanticsLabel: 'My SVG Image',
                                          height: 32,
                                          width: 32,
                                          color: AppColors.neutra90,
                                        ),
                                        Text(
                                          "تفعيل الاشعارات",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///مشاركة المتجر
                                  GestureDetector(
                                    onTap: () {
                                      SharePlus.instance.share(
                                        ShareParams(
                                          title: 'Check out this app!',
                                          text: 'Check out this app!',
                                        ),
                                      );
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg_images/share.svg',
                                          semanticsLabel: 'My SVG Image',
                                          height: 32,
                                          width: 32,
                                          color: AppColors.neutra90,
                                        ),
                                        Text(
                                          "مشاركة",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///مواعيد العمل
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => StoreStatusPage(
                                          status: StoreStatus.open,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: AppColors.neutral400,
                                          size: 24,
                                        ),
                                        Text(
                                          "مواعيد العمل",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///عن المتجر
                                  GestureDetector(
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: AppColors.neutral400,
                                          size: 24,
                                        ),
                                        Text(
                                          "عن المتجر",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///حظر المتجر
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SizedBox(
                                          height: 150,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                20.0,
                                              ),
                                              child: Column(
                                                spacing: 15,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "هل أنت متأكد من حظر حساب المستخدم؟",
                                                    style: getBold(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Row(
                                                    spacing: 10,
                                                    children: [
                                                      Expanded(
                                                        child: AateneButton(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder: (context) => SizedBox(
                                                                height: 300,
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          20.0,
                                                                        ),
                                                                    child: Column(
                                                                      spacing:
                                                                          15,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .check_circle_rounded,
                                                                          color:
                                                                              Colors.green,
                                                                          size:
                                                                              80,
                                                                        ),
                                                                        Text(
                                                                          "تم الحظر بنجاح",
                                                                          style: getBlack(
                                                                            fontSize:
                                                                                25,
                                                                          ),
                                                                        ),
                                                                        AateneButton(
                                                                          buttonText:
                                                                              " عودة للرئيسية",
                                                                          color:
                                                                              AppColors.primary400,
                                                                          borderColor:
                                                                              AppColors.primary400,
                                                                          textColor:
                                                                              AppColors.light1000,
                                                                          onTap: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute<
                                                                                void
                                                                              >(
                                                                                builder:
                                                                                    (
                                                                                      context,
                                                                                    ) => ProfilePage(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },

                                                          buttonText: "حظر",
                                                          color: AppColors
                                                              .primary400,
                                                          borderColor: AppColors
                                                              .primary400,
                                                          textColor: AppColors
                                                              .light1000,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: AateneButton(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          buttonText: "إلغاء",
                                                          color: AppColors
                                                              .primary100,
                                                          borderColor: AppColors
                                                              .primary100,
                                                          textColor: AppColors
                                                              .primary400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg_images/block.svg',
                                          semanticsLabel: 'My SVG Image',
                                          height: 32,
                                          width: 32,
                                          color: AppColors.neutra90,
                                        ),
                                        Text(
                                          "حظر",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///الابلاغ عن المتجر
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            const SelectionBottomSheet(),
                                      );
                                    },
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/svg_images/report.svg',
                                          semanticsLabel: 'My SVG Image',
                                          height: 32,
                                          width: 32,
                                          color: AppColors.neutra90,
                                        ),
                                        Text(
                                          "الابلاغ عن إساءه",
                                          style: getMedium(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/images/png/background_product.png', // صورة الغلاف
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. كرت المتجر
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: _buildMainStoreCard(),
                ),
              ),

              // 3. التبويبات (ثابتة عند التمرير)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.light1000,
                        border: Border.all(
                          color: AppColors.neutral1000,
                          width: 2,
                        ),
                      ),
                      child: TabBar(
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFE8F1FF),
                        ),
                        labelColor: AppColors.primary400,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text("نظرة عامة"),
                            ),
                          ),
                          Tab(text: "أقسام"),
                          Tab(text: "منتجات"),
                          Tab(text: "عروض"),
                          Tab(text: "مراجعات"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildOverviewContent(),
              _buildCategoriesGrid(),
              const Center(child: Text("منتجات")),
              OffersTabPage(),
              RatingProfile(),
            ],
          ),
        ),
      ),
    );
  }

  // كرت المتجر الرئيسي المعدل بحسب الصورة
  Widget _buildMainStoreCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          // الجزء العلوي: الاسم والشعار والتقييم
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                  'assets/images/png/placeholder_bag_image_png.png',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "EtnixByron",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: const [
                      SizedBox(width: 5),
                      Text(
                        "خليج بايرون، أستراليا",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Icon(Icons.location_on, size: 14, color: Colors.green),
                    ],
                  ),
                  Text(
                    "4.5 ⭐ (2,372)",
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              _buildNotificationIcon(),
            ],
          ),

          // زر المتابعة وعدد المتابعين
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? AppColors.primary50
                        : AppColors.primary400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => setState(() => isFollowing = !isFollowing),
                  icon: Icon(
                    isFollowing ? Icons.done : Icons.person_add_alt_1,
                    color: isFollowing
                        ? AppColors.primary500
                        : AppColors.light1000,
                  ),
                  label: Text(
                    isFollowing ? "متابع" : "متابعة",
                    style: TextStyle(
                      color: isFollowing
                          ? AppColors.primary500
                          : AppColors.light1000,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  // FollowersAvatars(
                  //   images: [
                  //     "assets/images/png/placeholder_bag_image_png.png",
                  //     "assets/images/png/placeholder_bag_image_png.png",
                  //     "assets/images/png/placeholder_bag_image_png.png",
                  //   ],
                  // ),
                  const Text(
                    "350K متابع",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          // الإحصائيات (الطلبات، المفضل، وقت العمل)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icon(Icons.access_time, color: Colors.grey, size: 20),
                "المتجر يعمل",
                "من 9AM - 1AM",
              ),

              _buildStatItem(
                Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                "متجر مفضل لـ",
                "30K مستخدم",
              ),
              _buildStatItem(
                SvgPicture.asset(
                  "assets/images/svg_images/boxsvg.svg",
                  height: 20,
                  width: 20,
                ),
                "الطلبات",
                "1002 طلب",
              ),
            ],
          ),

          // شريط "هذا المتجر معتمد"
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Text(
                  "هذا المتجر معتمد PRO",
                  style: getBold(color: AppColors.primary400, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(Widget icon, String label, String value) {
    return Column(
      spacing: 5,
      children: [
        Row(
          spacing: 3,
          children: [
            icon,
            // Icon(icon, color: Colors.grey, size: 20),
            Text(label, style: getMedium(color: Colors.grey, fontSize: 12)),
          ],
        ),
        Text(value, style: getBold(fontSize: 12, color: AppColors.primary400)),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F7),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        "assets/images/svg_images/notification12.svg",
        width: 20,
        height: 20,
      ),
    );
  }

  // باقي عناصر الواجهة (نظرة عامة والمنتجات) تظل كما هي في الكود السابق مع تحسينات طفيفة
  Widget _buildOverviewContent() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        StoryItem(),
        SizedBox(height: 10),
        _bioCard(),
        SizedBox(height: 10),
        // _buildSectionHeader("منتجات"),
        // SizedBox(height: 10),
        // _buildProductGrid(isShrinkWrap: true),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildCircleIcon(Widget icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary200.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: icon,
    );
  }

  /// دالة بناء شبكة المنتجات (كما في الرد السابق)
  Widget _buildProductGrid({bool isShrinkWrap = false}) {
    return GridView.builder(
      shrinkWrap: isShrinkWrap,
      physics: isShrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 2,
      itemBuilder: (context, index) => _buildProductCard(index == 0),
    );
  }

  /// product card
  Widget _buildProductCard(bool hasDiscount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/svg_images/done.svg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                if (hasDiscount)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "-20%",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text("T-Shirt Sailing", style: TextStyle(fontSize: 14)),
        Text(
          hasDiscount ? "14\$" : "10\$",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _bioCard() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary50),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
              ReadMoreText(
                'A paragraph is a unit of text that consists of a group of sentences related to a central topic or idea. It serves as a container for expressing a complete thought or developing a specific aspect of an argument.',
                trimMode: TrimMode.Line,
                trimLines: 3,
                colorClickableText: AppColors.neutral500,
                trimCollapsedText: 'عرض المزيد',
                trimExpandedText: 'عرض أقل',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary400,
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  SvgPicture.asset(
                    "assets/images/svg_images/facebook9.svg",
                    height: 15,
                    width: 15,
                  ),
                  SvgPicture.asset(
                    "assets/images/svg_images/instagram9.svg",
                    height: 15,
                    width: 15,
                  ),
                  SvgPicture.asset(
                    "assets/images/svg_images/tiktok9.svg",
                    height: 15,
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'المنتجات المفضلة ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          runSpacing: 15,
          children: [
            ProductCard(),

            ProductCard(),

            ProductCard(),

            ProductCard(),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      children: [
        _buildCategoryCard("جديد", "27035 عنصر", Colors.green[100]!),
        _buildCategoryCard("ملابس", "271 عنصر", Colors.brown[100]!),
        _buildCategoryCard("مستعمل", "12312 عنصر", Colors.purple[100]!),
        _buildCategoryCard("أحذية", "271 عنصر", Colors.blueGrey[100]!),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/200'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            count,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child);

  final Widget _child;

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(context, shrinkOffset, overlapsContent) => _child;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
