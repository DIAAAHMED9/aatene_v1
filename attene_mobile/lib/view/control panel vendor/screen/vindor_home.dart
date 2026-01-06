import '../../../general_index.dart';
import '../controller/vendor_controller.dart';
import '../widget/control_menu_item.dart';
import '../widget/control_stats.dart';
import '../widget/membership_card.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "لوحة القيادة",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Center(
              child: Image.asset('assets/images/png/aatene_logo_horiz.png'),
            ),
            MembershipCard(points: controller.points),
            Container(
              padding: EdgeInsets.only(right: 10, left: 7),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.primary50, width: 2),
              ),
              child: Row(
                children: [
                  Text(
                    "ابحث عن المستخدمين والتجار والخدمات",
                    style: getMedium(fontSize: 12, color: Colors.grey),
                  ),
                  Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary400,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.light1000,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 5,
              children: [
                Icon(Icons.campaign_outlined, size: 28),
                Text("المحتوي (الشهر الحالي)", style: getMedium(fontSize: 14)),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.primary50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg_images/calender_black.svg',
                        semanticsLabel: 'My SVG Image',
                        height: 17,
                        width: 17,
                      ),
                      Text("الشهر الحالي", style: getMedium(fontSize: 12)),
                      Icon(Icons.keyboard_arrow_down_outlined, size: 20),
                    ],
                  ),
                ),
              ],
            ),

            DashboardStats(controller: controller),

            _sectionTitle('المزيد'),
            Divider(
              color: AppColors.primary50,
              height: 3,
              indent: 4,
              thickness: 1,
            ),
            DashboardMenuItem(
              title: 'الحملات الاعلانية',
              subtitle: 'قم بإضافة إعلانات بكل سهولةمن خلال \n  التطبيق',
              icon: SvgPicture.asset(
                'assets/images/svg_images/volume.svg',
                semanticsLabel: 'My SVG Image',
                height: 22,
                width: 22,
              ),
            ),
            DashboardMenuItem(
              title: 'شراء عملات ذهبية',
              subtitle: 'قم بشراء عملات ذهبية',
              icon: Image.asset(
                'assets/images/png/coin.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'ابحث عن المستخدمين والتجار والخدمات والمزيد',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
