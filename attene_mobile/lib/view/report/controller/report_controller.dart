// import '../../../../general_index.dart';
//
// class ReportController extends GetxController {
//
//   Map<String, dynamic> reportStates = {};
//   List<dynamic> reportData = [];
//
//
//   bool isLoading = true;
//   bool hasError = false;
//   String errorMessage = '';
//
//   @override
//   void onReady() {
//     super.onReady();
//     fetchReportStateData();
//     fetchReportTypeData();
//     fetchReportData();
//   }
//
//   Future<void> fetchReportData() async {
//     try {
//       isLoading = true;
//       hasError = false;
//       update();
//
//       final res = await ApiHelper.reportData();
//
//       if (res != null && res['status'] == true) {
//         reportData = res['reports'] ?? [];
//       } else {
//         hasError = true;
//         errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
//       }
//     } catch (e) {
//       hasError = true;
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
//
//   Future<void> fetchReportStateData() async {
//     try {
//       isLoading = true;
//       hasError = false;
//       update();
//
//       final res = await ApiHelper.reportStates();
//
//       if (res != null && res['status'] == true) {
//         reportStates = res['by_status'] ?? {};
//       } else {
//         hasError = true;
//         errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
//       }
//
//     } catch (e) {
//       hasError = true;
//       errorMessage = e.toString();
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
//
//   /// helper لتحويل الحالة إلى لون
//   Color getStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return AppColors.primary400;
//
//       case 'processing':
//         return Colors.orange;
//
//       case 'finished':
//         return Colors.green;
//
//       case 'cancelled':
//         return Colors.red;
//
//       default:
//         return Colors.grey;
//     }
//   }
//
//   /// helper لتحويل الحالة إلى نص عربي
//   String getStatusTitle(String status) {
//     switch (status) {
//       case 'pending':
//         return "جديدة";
//
//       case 'processing':
//         return "قيد المراجعة";
//
//       case 'finished':
//         return "مكتملة";
//
//       case 'cancelled':
//         return "ملغية";
//
//       default:
//         return status;
//     }
//   }
// }
//

import '../../../../general_index.dart';

class ReportController extends GetxController {
  Map<String, dynamic> reportStates = {};
  List<dynamic> reportTypes = [];

  List<dynamic> reportData = [];

  /// القائمة النهائية بعد البحث + الفلترة
  List<dynamic> filteredReports = [];

  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  /// الحالة المختارة للفلترة
  String selectedStatus = "all";

  @override
  void onReady() {
    super.onReady();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchReportStateData(),
      fetchReportData(),
      fetchReportTypeData(),
    ]);
  }

  Future<void> fetchReportTypeData() async {
    try {
      isLoading = true;
      hasError = false;
      update();

      final res = await ApiHelper.reportType();

      if (res != null && res['status'] == true) {
        reportTypes = res['report_types'] ?? [];
      } else {
        hasError = true;
        errorMessage = res?['message'] ?? 'حدث خطأ أثناء جلب البيانات';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchReportData() async {
    try {
      final res = await ApiHelper.reportData();

      if (res != null && res['status'] == true) {
        reportData = res['reports'] ?? [];
        applyFilters(); // تطبيق أولي
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchReportStateData() async {
    try {
      final res = await ApiHelper.reportStates();
      if (res != null && res['status'] == true) {
        reportStates = res['by_status'] ?? {};
      }
    } catch (_) {}
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();

    filteredReports = reportData.where((report) {
      /// فلترة حسب الحالة
      final matchesStatus = selectedStatus == "all"
          ? true
          : report['status'] == selectedStatus;

      /// فلترة حسب البحث
      final uuid = (report['uuid'] ?? '').toString().toLowerCase();
      final typeName = (report['report_type']?['name'] ?? '')
          .toString()
          .toLowerCase();
      final createdAt = (report['created_at'] ?? '').toString().toLowerCase();
      final statusTitle = getStatusTitle(report['status']).toLowerCase();

      final matchesSearch = query.isEmpty
          ? true
          : uuid.contains(query) ||
                typeName.contains(query) ||
                createdAt.contains(query) ||
                statusTitle.contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

    update();
  }

  /// عند تغيير الفلتر
  void changeStatusFilter(String status) {
    selectedStatus = status;
    applyFilters();
  }

  /// عند البحث
  void onSearchChanged(String value) {
    applyFilters();
  }

  /// الحالة
  Color getStatusColor(String status) {
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

  String getStatusTitle(String status) {
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
}
