import '../../../general_index.dart';
import '../controller/report_controller.dart';
import 'report_add_abuse.dart';

class ReportAbuseScreen extends StatefulWidget {
  const ReportAbuseScreen({super.key});

  @override
  State<ReportAbuseScreen> createState() => _ReportAbuseScreenState();
}

class _ReportAbuseScreenState extends State<ReportAbuseScreen> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
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
            centerTitle: false,
            title: Text(
              "الشكاوى والاقتراحات",
              style: getBold(color: AppColors.neutral100, fontSize: 20),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary400),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.hasError
                    ? Center(child: Text(controller.errorMessage))
                    : controller.reportTypes.isEmpty
                    ? const Center(child: Text("لا يوجد بيانات"))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          Text(
                            'الإبلاغ عن إساءة',
                            style: getBold(fontSize: 18),
                          ),

                          Text(
                            'ما الذي تقدر أن نساعدك به ؟',
                            style: getMedium(fontSize: 12, color: Colors.grey),
                          ),

                          const SizedBox(height: 20),

                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.reportTypes.length,
                              itemBuilder: (context, index) {
                                final item = controller.reportTypes[index];

                                return RadioListTile<int>(
                                  value: index,
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value;
                                    });
                                  },
                                  activeColor: AppColors.primary400,
                                  title: Text(
                                    item['name'] ?? '',
                                    style: getMedium(),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          AateneButton(
                            onTap: selectedOption == null
                                ? null
                                : () {
                                    final selectedItem =
                                        controller.reportTypes[selectedOption!];

                                    Get.to(
                                      ReportAddAbuse(),
                                      arguments: {
                                        "report_type_id": selectedItem['id'],
                                      },
                                    );
                                  },
                            buttonText: "التالي",
                            color: AppColors.primary400,
                            textColor: AppColors.light1000,
                            borderColor: AppColors.primary400,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}