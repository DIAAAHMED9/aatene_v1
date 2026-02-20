import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../../../api/core/api_helper.dart';

enum AppViewMode { user, merchantProducts, merchantServices }

extension AppViewModeX on AppViewMode {
  String get key => switch (this) {
        AppViewMode.user => 'user',
        AppViewMode.merchantProducts => 'merchant_products',
        AppViewMode.merchantServices => 'merchant_services',
      };

  static AppViewMode fromKey(String? v) {
    switch (v) {
      case 'merchant_products':
        return AppViewMode.merchantProducts;
      case 'merchant_services':
        return AppViewMode.merchantServices;
      default:
        return AppViewMode.user;
    }
  }
}

class DashboardController extends GetxController {
  final favoritesCount = 0.obs;
  final productsCount = 0.obs;
  final points = 0.obs;

  /// فلتر المحتوى
  /// - افتراضيًا: الشهر الحالي
  final filterLabel = 'الشهر الحالي'.obs;
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();

  /// فعّل فلتر الشهر الحالي
  void applyCurrentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
    fromDate.value = start;
    toDate.value = end;
    filterLabel.value = 'الشهر الحالي';
    fetchMerchantCounters();
  }

  /// فعّل فلتر حسب التاريخ (مدى تاريخي)
  void applyCustomRange(DateTime start, DateTime end) {
    fromDate.value = DateUtils.dateOnly(start);
    toDate.value = DateUtils.dateOnly(end);
    filterLabel.value = '${_fmtDate(fromDate.value)} - ${_fmtDate(toDate.value)}';
    fetchMerchantCounters();
  }

  /// نافذة اختيار الفلتر
  Future<void> openFilterSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('الشهر الحالي'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  applyCurrentMonth();
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range_outlined),
                title: const Text('حسب التاريخ'),
                subtitle: const Text('اختر مدة زمنية مخصصة'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2026, 1, 1),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange: (fromDate.value != null && toDate.value != null)
                        ? DateTimeRange(start: fromDate.value!, end: toDate.value!)
                        : null,
                  );
                  if (picked != null) {
                    applyCustomRange(picked.start, picked.end);
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
  final isLoading = false.obs;
  final hasError = false.obs;
  String errorMessage = '';

  /// الرصيد الحالي
  // final points = 0.obs;

  /// الباقات
  final packages = [].obs;

  /// وضع التطبيق الحالي (User / Merchant Products / Merchant Services)
  AppViewMode get currentMode {
    try {
      final box = GetStorage();
      return AppViewModeX.fromKey(box.read('app_view_mode')?.toString());
    } catch (_) {
      return AppViewMode.user;
    }
  }

  bool get isServicesMode => currentMode == AppViewMode.merchantServices;

  /// ==============================
  /// Fetch Merchant Dashboard Counters
  /// - total items count (products/services)
  /// - favorites sum across items (products/services)
  ///
  /// ملاحظة: لا يوجد Endpoint واضح في Postman يعيد counters جاهزة للتاجر.
  /// لذلك نعتمد على قائمة المنتجات/الخدمات ونقرأ الـ pagination + نجمع favorites_count.
  /// ==============================
  Future<void> fetchMerchantCounters() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final String path = isServicesMode
          ? '/merchants/services'
          : '/merchants/products';

      int page = 1;
      const int perPage = 100;
      int total = 0;
      int favSum = 0;

      while (true) {
        dynamic resDyn = await ApiHelper.get(
          path: path,
          queryParameters: {
            'page': page,
            'per_page': perPage,
            // فلاتر التاريخ (إن وُجدت)
            if (fromDate.value != null) 'date_from': _apiDate(fromDate.value!),
            if (toDate.value != null) 'date_to': _apiDate(toDate.value!),
          },
          // لا نعرض رسائل لكل صفحة حتى لا يزعج المستخدم
          shouldShowMessage: false,
        );

        // بعض الـ APIs قد لا تدعم date_from/date_to
        // إذا فشلت أول صفحة مع الفلتر، جرّب مرة واحدة بدون فلتر لتجنب تعطّل لوحة التاجر.
        Map<String, dynamic>? res = (resDyn is Map) ? resDyn.cast<String, dynamic>() : null;

        if (res == null && page == 1 && (fromDate.value != null || toDate.value != null)) {
          resDyn = await ApiHelper.get(
            path: path,
            queryParameters: {
              'page': page,
              'per_page': perPage,
            },
            shouldShowMessage: false,
          );

          res = (resDyn is Map) ? resDyn.cast<String, dynamic>() : null;

          if (res != null) {
            // نُبقي الفلتر على واجهة المستخدم كما هو، لكن ننبه أن السيرفر تجاهله
            Get.snackbar('تنبيه', 'الفلترة بالتاريخ غير مدعومة حاليًا من السيرفر لهذا المحتوى');
          }
        }

        if (res == null) {
          hasError.value = true;
          errorMessage = 'Failed to load merchant data';
          break;
        }

        // محاولة استخراج القائمة من أكثر من شكل شائع في الـ API
        final dynamic listRaw =
            res['data'] ?? res['items'] ?? res['products'] ?? res['services'];
        final List items = (listRaw is List) ? listRaw : <dynamic>[];

        // total من meta أو pagination إن وجد
        final dynamic meta = res['meta'] ?? res['pagination'] ?? res['paginate'];
        if (meta is Map) {
          final t = meta['total'] ?? meta['total_items'] ?? meta['count'];
          if (t != null) total = int.tryParse(t.toString()) ?? total;
        }

        // في حال لم يوجد meta.total، نجمع بناءً على طول القائمة
        if (total == 0) {
          total = (page - 1) * perPage + items.length;
        }

        for (final it in items) {
          if (it is Map) {
            final fc = it['favorites_count'] ?? it['favoritesCount'] ?? 0;
            favSum += int.tryParse(fc.toString()) ?? 0;
          }
        }

        // stop condition
        if (items.length < perPage) {
          break;
        }

        // safety guard (منع حلقات لا نهائية إذا الـ API أعاد نفس الصفحة)
        if (page > 50) {
          break;
        }

        page++;
      }

      productsCount.value = total;
      favoritesCount.value = favSum;
    } catch (e) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// ==============================
  /// Fetch Balance
  /// ==============================
  Future<void> fetchBalance() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchBalance called');

      final res = await ApiHelper.get(path: '/merchants/coins/balance');
      print('response balance: $res');

      if (res != null && res['status'] == true) {
        points.value = int.tryParse(res['balance'].toString()) ?? 0;
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load balance';
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchBalance: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// ==============================
  /// Fetch Packages
  /// ==============================
  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await ApiHelper.get(path: '/merchants/coins/packages');
      print('response packages: $res');

      if (res != null && res['status'] == true) {
        packages.value = res['packages'] ?? [];
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load packages';
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchPackages: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// ==============================
  /// Purchase Coins (POST)
  /// ==============================
  Future<void> purchaseCoins(int packageId) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('purchaseCoins called');

      final res = await ApiHelper.post(path: '/merchants/coins/general');
      print('response purchase: $res');

      if (res != null && res['status'] == true) {
        await fetchBalance(); // تحديث الرصيد بعد الشراء
        Get.snackbar("نجاح", "تمت عملية الشراء بنجاح");
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Purchase failed';
        Get.snackbar("خطأ", errorMessage);
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in purchaseCoins: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    // افتراضيًا: الشهر الحالي
    applyCurrentMonth();
    fetchBalance();
    fetchPackages();
    super.onInit();
  }

  String _apiDate(DateTime d) {
    final dd = DateUtils.dateOnly(d);
    final y = dd.year.toString().padLeft(4, '0');
    final m = dd.month.toString().padLeft(2, '0');
    final day = dd.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = DateUtils.dateOnly(d);
    final day = dd.day.toString().padLeft(2, '0');
    final m = dd.month.toString().padLeft(2, '0');
    final y = dd.year.toString();
    return '$day/$m/$y';
  }
}
