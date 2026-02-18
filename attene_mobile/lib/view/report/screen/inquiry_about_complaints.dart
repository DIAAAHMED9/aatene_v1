// import '../../../general_index.dart';
// import '../controller/report_controller.dart';
// import '../widget/complaints_card.dart';
// import 'show_report.dart';
//
// class InquiryAboutComplaints extends StatelessWidget {
//   const InquiryAboutComplaints({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<ReportController>(
//       builder: (controller) {
//
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             title: Text(
//               "الشكاوى والاقتراحات",
//               style: getBold(color: AppColors.neutral100, fontSize: 20),
//             ),
//           ),
//
//           body: controller.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Text('إستعلام عن الشكاوي',
//                       style: getBold(fontSize: 18)),
//
//                   const SizedBox(height: 10),
//
//                   /// ====== Status Cards ======
//                   Row(
//                     children: controller.reportStates.entries.map((entry) {
//
//                       final statusKey = entry.key;
//                       final count = entry.value.toString();
//                       final color = controller.getStatusColor(statusKey);
//
//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: ComplaintsCard(
//                             number: count,
//                             title: controller.getStatusTitle(statusKey),
//                             backgroundColor: color.withOpacity(0.15),
//                             textColor: color,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// ====== Reports List ======
//                   controller.reportData.isEmpty
//                       ? const Center(child: Text("لا يوجد شكاوي"))
//                       : Column(
//                     children: controller.reportData.map((report) {
//
//                       final status = report['status'];
//                       final color =
//                       controller.getStatusColor(status);
//
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                               color: AppColors
//                                   .colorInquiryAboutComplaints),
//                         ),
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//
//                             /// title + status
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     report['report_type']
//                                     ?['name'] ??
//                                         '',
//                                     style:
//                                     getBold(fontSize: 14),
//                                   ),
//                                 ),
//
//                                 Container(
//                                   padding:
//                                   const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4),
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.circular(8),
//                                     color:
//                                     color.withOpacity(0.15),
//                                     border: Border.all(
//                                         color: color),
//                                   ),
//                                   child: Text(
//                                     controller
//                                         .getStatusTitle(status),
//                                     style: getMedium(
//                                         fontSize: 10,
//                                         color: color),
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 8),
//
//                             /// UUID
//                             Row(
//                               children: [
//                                 Text("رقم الشكوى : ",
//                                     style: getMedium(
//                                         fontSize: 10,
//                                         color: Colors.grey)),
//                                 Text(
//                                   report['uuid'] ?? '',
//                                   style: getMedium(
//                                       fontSize: 10,
//                                       color: AppColors.primary400),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 5),
//
//                             /// Date
//                             Row(
//                               children: [
//                                 Text("التاريخ : ",
//                                     style: getMedium(
//                                         fontSize: 10,
//                                         color: Colors.grey)),
//                                 Text(
//                                   report['created_at'] ?? '',
//                                   style: getMedium(
//                                       fontSize: 10,
//                                       color: AppColors.primary400),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 10),
//
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(
//                                       () => ShowReport(),
//                                   arguments: report,
//                                 );
//                               },
//                               child: Container(
//                                 width: 140,
//                                 height: 38,
//                                 decoration: BoxDecoration(
//                                   borderRadius:
//                                   BorderRadius.circular(7),
//                                   color: AppColors.primary400,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons
//                                           .remove_red_eye_outlined,
//                                       color:
//                                       AppColors.light1000,
//                                       size: 18,
//                                     ),
//                                     const SizedBox(width: 5),
//                                     Text(
//                                       "عرض التفاصيل",
//                                       style: getMedium(
//                                           fontSize: 10,
//                                           color: AppColors
//                                               .light1000),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                     ).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:attene_mobile/view/report/screen/show_report.dart';

import '../../../general_index.dart';
import '../controller/report_controller.dart';
import '../widget/complaints_card.dart';

class InquiryAboutComplaints extends StatelessWidget {
  const InquiryAboutComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      init: ReportController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "الشكاوى والاقتراحات",
              style: getBold(color: AppColors.neutral100, fontSize: 20),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),

          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    /// ====== Status Cards ======
                    Row(
                      children: controller.reportStates.entries.map((entry) {
                        final statusKey = entry.key;
                        final count = entry.value.toString();
                        final color = controller.getStatusColor(statusKey);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ComplaintsCard(
                              number: count,
                              title: controller.getStatusTitle(statusKey),
                              backgroundColor: color.withOpacity(0.15),
                              textColor: color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "ابحث عن شكوى...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: controller.filteredReports.isEmpty
                          ? const Center(child: Text("لا يوجد نتائج"))
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: controller.filteredReports.length,
                              itemBuilder: (context, index) {
                                final report =
                                    controller.filteredReports[index];
                                final status = report['status'];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          AppColors.colorInquiryAboutComplaints,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// title + status
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              " ${report['content']}",

                                              style: getBold(fontSize: 14),
                                            ),
                                          ),

                                          /// states
                                          /// الحالة
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .getStatusColor(status)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              controller.getStatusTitle(status),
                                              style: TextStyle(
                                                color: controller
                                                    .getStatusColor(status),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Wrap(
                                        spacing: 5,
                                        children: [
                                          /// report type
                                          Text(
                                            "الفئة : ${report['report_type']?['name']}",

                                            style: getBold(fontSize: 14),
                                          ),

                                          /// UUID
                                          /// رقم الشكوى
                                          Text(
                                            "رقم الشكوى: ${report['uuid']}",
                                            style: getBold(fontSize: 14),
                                          ),
                                          // const SizedBox(height: 5),

                                          /// Date
                                          /// التاريخ
                                          Text(
                                            "التاريخ: ${report['created_at']}",
                                            style: getMedium(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      const SizedBox(height: 10),

                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ShowReport(),
                                            arguments: report,
                                          );
                                        },
                                        child: Container(
                                          width: 140,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                            color: AppColors.primary400,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppColors.light1000,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "عرض التفاصيل",
                                                style: getMedium(
                                                  fontSize: 10,
                                                  color: AppColors.light1000,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
