import '../../../general_index.dart';
import '../controller/support_controller.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  int expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
      init: SupportController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "سياسة الخصوصية",
              style: getBold(color: AppColors.neutral100, fontSize: 20),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                width: 45,
                height: 45,
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
                    value: Get.locale?.languageCode,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: const Icon(Icons.language, size: 16),
                    items: const [
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'he', child: Text('עברית')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        Get.updateLocale(Locale(value));
                        controller.update();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.hasError
              ? Center(child: Text(controller.errorMessage))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/gif/Privacy_policy.gif',
                        height: 200,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ...List.generate(controller.privacyPolicy.length, (index) {
                      final item = controller.privacyPolicy[index];

                      final isExpanded = expandedIndex == index;

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
                                  style: getMedium(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.getTitlePolicy(item),
                                      style: getMedium(fontSize: 14),
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primary400,
                                    child: Icon(
                                      isExpanded ? Icons.remove : Icons.add,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  controller
                                      .getContentPolicy(item)
                                      .replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style: getMedium(fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
        );
      },
    );
  }
}
