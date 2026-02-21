import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/control_users/controller/support_controller.dart';


class SafetyTipsPage extends StatelessWidget {
  const SafetyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.hasError) {
          return Scaffold(body: Center(child: Text(controller.errorMessage)));
        }

        if (controller.safetyRules.isEmpty) {
          return const Scaffold(body: Center(child: Text("No Data")));
        }

        final rules = controller.safetyRules;

        final tabsKeys = rules.keys
            .where(
              (key) =>
                  key != 'title' &&
                  key != 'content' &&
                  key != 'keep_account_save',
            )
            .toList();

        return DefaultTabController(
          length: tabsKeys.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(rules["title"] ?? ''),
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
              bottom: TabBar(
                unselectedLabelColor: AppColors.neutral100,
                // dividerColor: Colors.blue,
                labelColor: AppColors.primary400,
                indicatorColor: AppColors.primary400,
                isScrollable: true,
                tabs: tabsKeys.map((key) => Tab(text: key)).toList(),
              ),
            ),
            body: TabBarView(
              children: tabsKeys.map((key) {
                final List<dynamic> items = rules[key] ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rules['content'] ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 20),

                      if (rules['keep_account_save'] != null)
                        _buildKeepAccountCard(rules['keep_account_save']),

                      const SizedBox(height: 20),

                      ...items.map((item) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                if (item['image_url'] != null)
                                  Image.network(
                                    item['image_url'],
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeepAccountCard(Map data) {
    final sections = data['sections'] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(data['content'] ?? ''),

            const SizedBox(height: 16),

            ...sections.map<Widget>((section) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 6),

                    Text(section['content'] ?? ''),

                    const SizedBox(height: 6),

                    if (section['image_url'] != null)
                      Image.network(
                        section['image_url'],
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}