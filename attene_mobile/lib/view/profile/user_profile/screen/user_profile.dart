import 'package:attene_mobile/general_index.dart' hide VendorCard;
import 'package:attene_mobile/view/story_vendor_ui/dummy/story_vendor_dummy.dart';
import 'package:attene_mobile/view/story_vendor_ui/widgets/story_highlights_row.dart';
import 'package:attene_mobile/view/profile/user_profile/widget/rating_profile_screen.dart';
import 'package:attene_mobile/view/profile/user_profile/widget/sellect_report.dart';
import 'package:attene_mobile/view/profile/user_profile/widget/silver_tabs.dart';
import 'package:attene_mobile/view/profile/user_profile/widget/read_more_text.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/user_controller.dart';
import '../widget/vendor_card.dart';
import '../widget/row_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // SliverAppBar (UPDATED)
              SliverAppBar(
                expandedHeight: size.height * 0.32,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: _circleIcon(Icons.arrow_back, () => Get.back()),
                actions: [
                  _circleIcon(Icons.favorite_border, () {}),
                  _circleIcon(Icons.more_horiz, () {
                    showModalBottomSheet(
                      elevation: 5,
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "المزيد",
                              textAlign: TextAlign.center,
                              style: getMedium(fontSize: 18),
                            ),
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
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 320,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          spacing: 15,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "اشعارات",
                                              style: getMedium(fontSize: 18),
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
                                              borderColor: AppColors.primary400,
                                              textColor: AppColors.light1000,
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
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          spacing: 15,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "هل أنت متأكد من حظر حساب المستخدم؟",
                                              style: getBold(fontSize: 18),
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
                                                                spacing: 15,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle_rounded,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 80,
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
                                                                    color: AppColors
                                                                        .primary400,
                                                                    borderColor:
                                                                        AppColors
                                                                            .primary400,
                                                                    textColor:
                                                                        AppColors
                                                                            .light1000,
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
                                                    color: AppColors.primary400,
                                                    borderColor:
                                                        AppColors.primary400,
                                                    textColor:
                                                        AppColors.light1000,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AateneButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: "إلغاء",
                                                    color: AppColors.primary100,
                                                    borderColor:
                                                        AppColors.primary100,
                                                    textColor:
                                                        AppColors.primary400,
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
                                  Text("حظر", style: getMedium(fontSize: 16)),
                                ],
                              ),
                            ),
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
                    );
                  }),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final top = constraints.biggest.height;
                    final isCollapsed = top <= kToolbarHeight + 20;

                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: _coverImage(),
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isCollapsed ? 1 : 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 6,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(
                                'assets/images/png/open-store.png',
                              ),
                            ),
                            Text(
                              'Cody Fisher',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --------------------------------------------------
              // Profile Card
              // --------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _profileCard(controller),
                ),
              ),

              // --------------------------------------------------
              // Tabs (SliverPersistentHeader)
              // --------------------------------------------------
              SliverPersistentHeader(
                pinned: true,
                delegate: SilverTabs(controller),
              ),

              // --------------------------------------------------
              // Body Content
              // --------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _bodyContent(controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  Widget _coverImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/png/mainus.png', fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.45)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon, final Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }

  // --------------------------------------------------
  Widget _profileCard(ProfileController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                spacing: 5,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: const AssetImage(
                      'assets/images/png/open-store.png',
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // controller.profileData['fullname']??
                        'Cody Fisher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'username1128',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.neutral900,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          spacing: 3,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 8,
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "فلسطين - الخليل",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Follow Button Animation
              Obx(
                () => AnimatedScale(
                  scale: controller.isFollowing.value ? 1.05 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: Row(
                    spacing: 5,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.primary400),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/notofication.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 24,
                            width: 24,
                          ),

                          color: AppColors.neutra90,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.toggleFollow();
                            },
                            icon: Icon(
                              controller.isFollowing.value
                                  ? Icons.arrow_back
                                  : Icons.person_add_alt_1,
                              color: controller.isFollowing.value
                                  ? AppColors.primary400
                                  : AppColors.light1000,
                            ),
                            label: Text(
                              controller.isFollowing.value
                                  ? 'تمت المتابعة'
                                  : 'متابعة',
                              style: TextStyle(
                                color: controller.isFollowing.value
                                    ? AppColors.primary400
                                    : AppColors.light1000,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isFollowing.value
                                  ? AppColors.primary100
                                  : AppColors.primary400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.primary400),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/massages.svg',
                            semanticsLabel: 'My SVG Image',
                            height: 24,
                            width: 24,
                          ),

                          color: AppColors.neutra90,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ProfileStatsRow(),
            ],
          ),
        ),
        StoryHighlightsRow(vendors: demoVendors),
      ],
    );
  }

  // --------------------------------------------------
  Widget _bodyContent(ProfileController controller) {
    return Obx(() {
      switch (controller.currentTab.value) {
        case 0:
          return _bioCard();
        case 1:
          return RatingProfile();
        case 2:
          return VendorCard(
            storeName: "Linda Store",
            productImages: [
              'https://example.com/image1.jpg',
              'https://example.com/image2.jpg',
              'https://example.com/image3.jpg',
            ],
          );
        default:
          return const SizedBox();
      }
    });
  }

  Widget _bioCard() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    );
  }
}
