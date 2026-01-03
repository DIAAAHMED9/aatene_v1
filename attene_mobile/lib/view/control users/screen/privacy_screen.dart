

import '../../../general_index.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  int expandedIndex = 0;

  final List<Map<String, String>> items = [
    {
      'title': 'المقدمة',
      'content':
          'نحن في أعضائي نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.\n'
          'توضح هذه الصفحة كيف نقوم بجمع معلوماتك واستخدامها وحمايتها أثناء استخدامك لمنصتنا.',
    },
    {
      'title': 'المعلومات التي نجمعها',
      'content': 'نقوم بجمع بعض المعلومات الأساسية لتحسين تجربة الاستخدام.',
    },
    {
      'title': 'كيفية استخدام المعلومات',
      'content': 'تُستخدم المعلومات لتقديم الخدمات وتطوير التطبيق.',
    },
    {
      'title': 'مشاركة البيانات',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': 'حماية المعلومات',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': 'ملفات تعريف الارتباط (Cookies)',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': 'حقوق المستخدم',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "سياسة الخصوصية",
          style: getBold(color: AppColors.neutral100, fontSize: 18),
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.neutral700),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.language, size: 12),
                    Text("عربي (AR)", style: getRegular(fontSize: 10)),
                    Icon(Icons.keyboard_arrow_down_outlined, size: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.asset(
              'assets/images/gif/Privacy_policy.gif',
              height: 220,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24),

          ...List.generate(items.length, (index) {
            final bool isExpanded = expandedIndex == index;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.colorTermsOfUseScreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? -1 : index;
                      });
                    },
                    leading: CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.primary400,
                      child: Text(
                        '${index + 1}',
                        style: getRegular(fontSize: 11, color: Colors.white),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(items[index]['title']!, style: getRegular(fontSize: 14)),
                        const Spacer(),
                        _circleIconPlus(isExpanded ? Icons.remove : Icons.add),
                      ],
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        items[index]['content']!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontFamily: "PingAR",
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _circleIconPlus(IconData icon) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.primary400,
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}