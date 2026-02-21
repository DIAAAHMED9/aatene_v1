import 'package:attene_mobile/view/control_users/controller/support_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportController());

    return GetBuilder<SupportController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.hasError) {
          return Scaffold(
            body: Center(child: Text(controller.errorMessage)),
          );
        }

        if (controller.faqSections.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No Data")),
          );
        }

        return DefaultTabController(
          length: controller.faqSections.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("FAQs"),
              bottom: TabBar(
                isScrollable: true,
                tabs: controller.faqSections
                    .map<Widget>(
                      (category) => Tab(text: category['title'] ?? ''),
                )
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: controller.faqSections.map<Widget>((category) {
                final List faqs = category['faqs'] ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final item = faqs[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        title: Text(item['question'] ?? ''),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['answer'] ?? ''),

                                if (item['image_url'] != null &&
                                    item['image_url'].toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Image.network(
                                      item['image_url'],
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}