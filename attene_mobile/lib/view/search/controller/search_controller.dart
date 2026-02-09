// import 'package:flutter/material.dart';
//
// class UserAccountTypeWidget extends StatefulWidget {
//   const UserAccountTypeWidget({super.key});
//
//   @override
//   State<UserAccountTypeWidget> createState() => _UserAccountTypeWidgetState();
// }
//
// class _UserAccountTypeWidgetState extends State<UserAccountTypeWidget> {
//   bool isVerified = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           Text(
//             'حساب المستخدم',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//
//           /// Radio Item
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('حساب موثّق', style: Theme.of(context).textTheme.bodyLarge),
//               Radio<bool>(
//                 value: true,
//                 groupValue: isVerified,
//                 activeColor: Colors.blue,
//                 onChanged: (value) {
//                   setState(() {
//                     isVerified = value!;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import '../../../../general_index.dart';

class SearchScreenController extends GetxController {
  Map<String, dynamic> ProductDate = {};
  Map<String, dynamic> FilterProductDate = {};
  Map<String, dynamic> FilterServicesDate = {};
  Map<String, dynamic> ServicesDate = {};
  Map<String, dynamic> FilterUserDate = {};
  Map<String, dynamic> UserDate = {};
  Map<String, dynamic> FilterStoreDate = {};
  Map<String, dynamic> StorDate = {};
  RxBool isLoading = RxBool(true);
  RxBool hasError = RxBool(false);
  String errorMessage = '';

  final MyAppController myAppController = Get.find<MyAppController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductDate();
      fetchServicestDate();
      fetchUserSearchDate();
      fetchStoreSearchDate();
      fetchProductFilterDate();
      fetchServicestFilterDate();
      fetchUserSearchFilterDate();
      fetchStoreSearchFilterDate();
    });
  }

  /// Search Date
  /// Product
  Future<void> fetchProductDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchProductDate called');
      final res = await ApiHelper.get(
        path: "/products/search",
        withLoading: isLoading.value,
      );
      print('response product data: $res');

      if (res != null && res['status'] == true) {
        print('Product data fetched successfully');
        ProductDate = res['products'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateProductData(ProductDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Product data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchProductData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Services
  Future<void> fetchServicestDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchServicestDate called');
      final res = await ApiHelper.get(
        path: "/services/search?per_page=20",
        withLoading: isLoading.value,
      );
      print('response services data: $res');

      if (res != null && res['status'] == true) {
        print('Product data fetched successfully');
        ServicesDate = res['services'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateServicesData(ServicesDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Services data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchServicesData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// User
  Future<void> fetchUserSearchDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchUserSearchDate called');
      final res = await ApiHelper.get(
        path: "/users/search",
        withLoading: isLoading.value,
      );
      print('response User Search data: $res');

      if (res != null && res['status'] == true) {
        print('User Search data fetched successfully');
        ServicesDate = res['users'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateUserSearchData(UserDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load User Search data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchUserSearchData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Store
  Future<void> fetchStoreSearchDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchStoreSearchDate called');
      final res = await ApiHelper.get(
        path: "/stores/search",
        withLoading: isLoading.value,
      );
      print('response services data: $res');

      if (res != null && res['status'] == true) {
        print('Product data fetched successfully');
        ServicesDate = res['stores'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateStoreSearchData(StorDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Store Search data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchStoreSearch: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Filter Date
  /// Product
  ///  لم يتم تغيير path الموجود في الاعلى
  Future<void> fetchProductFilterDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchProductFilterDate called');
      final res = await ApiHelper.get(
        path: "/products/search-page",
        withLoading: isLoading.value,
      );
      print('response product filter data: $res');

      if (res != null && res['status'] == true) {
        print('Product Filter data fetched successfully');
        ProductDate = res['products'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateProductData(FilterProductDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Product Filter data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchProductFilterData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Services
  Future<void> fetchServicestFilterDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchServicestFilterDate called');
      final res = await ApiHelper.get(
        path: "/services/search-page",
        withLoading: isLoading.value,
      );
      print('response services filter data: $res');

      if (res != null && res['status'] == true) {
        print('Services Filter data fetched successfully');
        ServicesDate = res['services'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateServicesData(FilterServicesDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Services Filter data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchServicesFilterData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// User
  Future<void> fetchUserSearchFilterDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchUserSearchFilterDate called');
      final res = await ApiHelper.get(
        path: "/users/search-page",
        withLoading: isLoading.value,
      );
      print('response User Search Filter data: $res');

      if (res != null && res['status'] == true) {
        print('User Search Filter data fetched successfully');
        ServicesDate = res['users'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateUserSearchData(FilterUserDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load User Filter data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchUserFilterData: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Store
  Future<void> fetchStoreSearchFilterDate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('fetchStoreFilterDate called');
      final res = await ApiHelper.get(
        path: "/stores/search-page",
        withLoading: isLoading.value,
      );
      print('response Store Filter data: $res');

      if (res != null && res['status'] == true) {
        print('Store Filter data fetched successfully');
        ServicesDate = res['stores'] ?? {};

        // Update shared data if needed
        if (Get.isRegistered<MyAppController>()) {
          final myAppController = Get.find<MyAppController>();
          myAppController.updateStoreSearchData(FilterStoreDate);
        }
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'Failed to load Store Search data';
        print('Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'Network error: ${e.toString()}';
      print('Exception in fetchStoreSearch: $e\n$stack');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
