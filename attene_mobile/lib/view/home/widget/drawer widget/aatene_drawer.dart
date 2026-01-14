
import '../../../../general_index.dart';
import '../../../../utlis/responsive/responsive_dimensions.dart';
import '../../controller/controller_drawer.dart';
import 'account_item.dart';
import 'menu_item.dart';

class AateneDrawer extends StatelessWidget {
  AateneDrawer({super.key});

  final controller = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: AppColors.primary400,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/png/aatene_logo_horiz.png",
                width: ResponsiveDimensions.w(160),
                height: ResponsiveDimensions.h(50),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('تسجيل دخول عن طريق', style: getMedium()),
                      ...List.generate(
                        controller.accounts.length,
                        (index) => DrawerAccountItem(
                          name: controller.accounts[index].name,
                          avatar: controller.accounts[index].avatar,
                          isSelected:
                              controller.selectedAccountIndex.value == index,
                          onTap: () => controller.switchAccount(index),
                        ),
                      ),
                      InkWell(
                        onTap: controller.addAccount,
                        child: const Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text('اضافة حساب/متجر اخر'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              DrawerMenuItem(
                icon: SvgPicture.asset(
                  'assets/images/svg_images/Setting.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 22,
                  width: 22,
                ),
                title: 'اعدادات الحساب',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: Icon(
                  Icons.headset_mic_outlined,
                  color: AppColors.neutral500,
                ),
                title: 'تواصل معنا',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: SvgPicture.asset(
                  'assets/images/svg_images/policy1.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 18,
                  width: 18,
                ),
                title: 'سياسة الخصوصية',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: SvgPicture.asset(
                  'assets/images/svg_images/hugeicons_policy.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 22,
                  width: 22,
                ),
                title: 'شروط الخدمة',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: Icon(
                  Icons.report_problem_outlined,
                  color: AppColors.neutral500,
                ),
                title: 'بوابة الشكاوى والاقتراحات',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: SvgPicture.asset(
                  'assets/images/svg_images/safety_rules.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 22,
                  width: 22,
                ),
                title: 'قواعد السلامة',
                onTap: () {},
              ),
              DrawerMenuItem(
                icon: Icon(Icons.info_outline, color: AppColors.neutral500),
                title: 'عن أعطيني',
                onTap: () {},
              ),
              DrawerMenuItem(
                //chat-question
                icon: SvgPicture.asset(
                  'assets/images/svg_images/chat-question.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 22,
                  width: 22,
                ),
                title: 'الأسئلة الشائعة',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Text(
            'A’atene',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          CircleAvatar(child: Text('A')),
        ],
      ),
    );
  }
}
