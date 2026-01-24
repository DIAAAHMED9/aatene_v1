import '../../../general_index.dart';

class NotificationFeed extends StatefulWidget {
  const NotificationFeed({super.key});

  @override
  State<NotificationFeed> createState() => _NotificationFeedState();
}

class _NotificationFeedState extends State<NotificationFeed> {
  bool activity = true;
  bool updates = true;
  bool messages = true;
  bool following = true;
  bool recommendations = true;

  Widget _settingItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(title, style: getMedium()),
          subtitle: Text(subtitle, style: getRegular(fontSize: 13)),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "إعدادات الإشعارات",
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

      body: Column(
        children: [
          _settingItem(
            title: 'نشاطي',
            subtitle: 'الإشعارات والتنبيهات استنادًا إلى نشاطك في المنصة.',
            value: activity,
            onChanged: (v) => setState(() => activity = v),
          ),
          _settingItem(
            title: 'اتجاهات وتحديثات المنصة',
            subtitle: 'أحدث الاكتشافات وأبرز ميزات التطبيق الجديدة.',
            value: updates,
            onChanged: (v) => setState(() => updates = v),
          ),
          _settingItem(
            title: 'الرسائل',
            subtitle: 'رسائل من البائعين أو من أعضاء آخرين في المنصة.',
            value: messages,
            onChanged: (v) => setState(() => messages = v),
          ),
          _settingItem(
            title: 'المتاجر أو الأشخاص الذين تتابعهم',
            subtitle: 'نشاط المتاجر أو الأشخاص الذين قمت بمتابعتهم.',
            value: following,
            onChanged: (v) => setState(() => following = v),
          ),
          _settingItem(
            title: 'التوصيات المخصصة',
            subtitle:
                'اقتراح متاجر أو منتجات أو فعاليات استنادًا إلى تاريخك ونشاطك.',
            value: recommendations,
            onChanged: (v) => setState(() => recommendations = v),
          ),
        ],
      ),
    );
  }
}
