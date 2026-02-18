import '../../../general_index.dart';
import '../controller/report_controller.dart'; // قد نحتاج إلى دوال المساعدة getStatusTitle, getStatusColor

class ShowReport extends StatelessWidget {
  const ShowReport({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> report = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الشكاوى والاقتراحات",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 500),
            // حد أقصى مع إمكانية التمدد
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary400, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral700.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(4, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("تفاصيل الشكوى", style: getBold(fontSize: 18)),
                    _buildInfoRow(
                      "رقم الشكوى",
                      report['uuid'] ?? "غير معروف",
                      isBoldValue: true,
                    ),
                    Divider(),
                    _buildStatusRow(report['status'] ?? ''),
                    Divider(),
                    _buildInfoRow(
                      "تاريخ التقديم",
                      _formatDate(report['created_at']),
                      isBoldValue: true,
                    ),
                    Divider(),
                    _buildInfoRow(
                      "نوع الشكوى",
                      report['report_type']?['name'] ?? "",
                      valueColor: Colors.grey,
                    ),
                    Divider(),
                    _buildInfoRow(
                      "المحتوى",
                      report['content'] ?? "",
                      valueColor: Colors.grey,
                    ),
                    Divider(),
                    // يمكن إضافة المزيد من المعلومات مثل المستخدم إذا رغبت:
                    // _buildInfoRow("مقدم الشكوى", report['user']?['fullname'] ?? "غير معروف"),
                    // Divider(),
                    AateneButton(
                      onTap: () => Get.back(),
                      // رجوع بسيط
                      buttonText: "إغلاق",
                      color: AppColors.primary400,
                      borderColor: AppColors.primary400,
                      textColor: AppColors.light1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: getMedium()),
        Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: isBoldValue
                ? getBold(color: valueColor ?? AppColors.primary400)
                : getMedium(color: valueColor ?? Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String status) {
    // استخدام دوال المساعدة من ReportController (إذا كانت متاحة static) أو تكرارها هنا
    String statusText = _getStatusTitle(status);
    Color statusColor = _getStatusColor(status);

    return Row(
      children: [
        Text("الحالة"),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.colorShowReport,
            border: Border.all(color: AppColors.customColor02),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Center(
              child: Text(
                statusText,
                style: getMedium(fontSize: 10, color: statusColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'pending':
        return "جديدة";
      case 'processing':
        return "مراجعة";
      case 'finished':
        return "مكتملة";
      case 'cancelled':
        return "ملغية";
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.primary400;
      case 'processing':
        return Colors.orange;
      case 'finished':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      // تنسيق عربي بسيط: 2026-02-10
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }
}
