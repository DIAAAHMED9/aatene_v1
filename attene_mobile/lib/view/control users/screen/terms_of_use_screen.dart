import '../../../general_index.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  int expandedIndex = 0;

  final List<Map<String, String>> items = [
    {
      'title': 'قبول الشروط',
      'content':
          'نحن في أعضائي نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.\n'
          'توضح هذه الصفحة كيف نقوم بجمع معلوماتك واستخدامها وحمايتها أثناء استخدامك لمنصتنا.',
    },
    {
      'title': 'إنشاء الحساب والمسؤولية',
      'content': 'نقوم بجمع بعض المعلومات الأساسية لتحسين تجربة الاستخدام.',
    },
    {
      'title': 'استخدام المنصة',
      'content': 'تُستخدم المعلومات لتقديم الخدمات وتطوير التطبيق.',
    },
    {
      'title': 'حقوق الملكية الفكرية',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': 'التعاملات المالية',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': ' تقييمات المستخدمين والمحتوى',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
    {
      'title': 'الإنهاء أو التعليق',
      'content': 'لا نقوم بمشاركة بياناتك مع أي جهة خارجية دون موافقتك.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "شروط الخدمة",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 4),
            child: SizedBox(
              width: 110,
              height: 55,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular((5)),
                  ),
                ),
                dropdownColor: AppColors.primary50,
                icon: Icon(Icons.language, size: 15),
                value: selectedLanguage,
                hint: Text("اختر اللغة"),
                items: [
                  DropdownMenuItem<String>(
                    value: 'ar',
                    child: Text('العربية', style: getRegular(fontSize: 14)),
                  ),
                  DropdownMenuItem<String>(
                    value: 'he',
                    child: Text('عبري', style: getRegular(fontSize: 14)),
                  ),
                  DropdownMenuItem<String>(
                    value: 'en',
                    child: Text('english', style: getRegular(fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  selectedLanguage = value;

                  Get.updateLocale(Locale(value!));
                },
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
              'assets/images/gif/Accept_terms.gif',
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
              child: SingleChildScrollView(
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
                          Text(
                            items[index]['title']!,
                            style: getRegular(fontSize: 14),
                          ),
                          const Spacer(),
                          _circleIconPlus(
                            isExpanded ? Icons.remove : Icons.add,
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          items[index]['content']!,
                          style: getRegular(fontSize: 12),
                        ),
                      ),
                  ],
                ),
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
