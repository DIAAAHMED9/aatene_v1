// lib/view/add new store/choose_type_store/manage_account_store.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/models/store_model.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';

import 'manage_account_store_controller.dart';

class ManageAccountStore extends StatefulWidget {
  const ManageAccountStore({super.key});

  @override
  State<ManageAccountStore> createState() => _ManageAccountStoreState();
}

class _ManageAccountStoreState extends State<ManageAccountStore> {
  late ManageAccountStoreController controller;
  late MyAppController myAppController;
  late DataInitializerService dataService;
  
  @override
  void initState() {
    super.initState();
    print('🔄 [ManageAccountStore] تهيئة الشاشة');
    
    // الحصول على المتحكمات
    controller = Get.put(ManageAccountStoreController(), permanent: true);
    myAppController = Get.find<MyAppController>();
    dataService = Get.find<DataInitializerService>();
    
    // عند بدء الشاشة، تأكد من عدم وجود متجر محدد تلقائياً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.stores.isNotEmpty && controller.selectedStore == null) {
        _showStoreSelectionPrompt();
      }
    });
  }

  void _showStoreSelectionPrompt() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && controller.selectedStore == null) {
        Get.snackbar(
          'اختيار المتجر',
          'يرجى اختيار متجر من القائمة للبدء',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  @override
  void dispose() {
    print('🔚 [ManageAccountStore] إغلاق الشاشة');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'إدارة الحسابات',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() => _buildBody(isRTL)),
    );
  }

  Widget _buildBody(bool isRTL) {
    // التحقق من تهيئة المتحكم
    if (!controller.isControllerInitialized) {
      return _buildInitializingView();
    }

    if (!myAppController.isLoggedIn.value) {
      return _buildLoginRequiredView();
    }

    if (controller.isLoading) {
      return _buildLoadingView();
    }

    if (controller.errorMessage.isNotEmpty) {
      return _buildErrorView();
    }

    if (controller.stores.isEmpty) {
      return _buildEmptyAccountsView();
    }

    return _buildAccountsListView();
  }

  Widget _buildInitializingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تهيئة البيانات...'),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل المتاجر...'),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              controller.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          AateneButton(
            buttonText: 'إعادة المحاولة',
            textColor: Colors.white,
            color: AppColors.primary400,
            borderColor: AppColors.primary400,
            raduis: 10,
            onTap: controller.loadStores,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAccountsView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/png/empty_store.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'لا يوجد لديك أي متاجر',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 280,
              child: Text(
                'يمكنك البدء بإضافة متاجر جديدة لإدارتها بشكل منفصل',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: 'إضافة متجر جديد',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 30,
              onTap: controller.addNewStore,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsListView() {
    // استخدام Obx للمراقبة التلقائية للتحديثات
    return Obx(() {
      final List<Store> filteredStores = controller.stores.where((store) {
        if (controller.searchQuery.isNotEmpty) {
          final query = controller.searchQuery.toLowerCase();
          return store.name.toLowerCase().contains(query) ||
                 store.address.toLowerCase().contains(query) ||
                 (store.email?.toLowerCase() ?? '').contains(query);
        }
        return true;
      }).toList();

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'ابحث عن متجر...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // إضافة رسالة تذكير باختيار المتجر إذا لم يكن هناك متجر محدد
          if (controller.selectedStore == null && filteredStores.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'يرجى اختيار متجر من القائمة أدناه للبدء',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          Container(
            margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0XFFF0F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'الحساب/المتجر',
                    style: TextStyle(
                      color: const Color(0xFF395A7D),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'الإجراءات',
                  style: TextStyle(
                    color: const Color(0xFF395A7D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredStores.length,
              itemBuilder: (context, index) {
                final store = filteredStores[index];
                return _buildStoreItem(store);
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AateneButton(
              buttonText: 'إضافة متجر جديد',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: controller.addNewStore,
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildStoreItem(Store store) {
    // استخدام Obx للمراقبة التلقائية للتحديد
    return Obx(() {
      final bool isSelected = controller.isStoreSelected(store);
      
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            // عند الضغط على المتجر، نقوم بتحديده
            controller.selectStore(store);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary50 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary400 : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // أيقونة التحديد
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primary400,
                      size: 24,
                    ),
                  ),
                
                _buildStoreLogo(store, isSelected),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              store.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primary500 : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // إظهار ID المتجر
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ID: ${store.id}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F4F8),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0XFF1BB532),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      store.address,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(store.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(store.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getStatusText(store.status),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _getStatusColor(store.status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // أزرار التعديل والحذف
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => controller.editStore(store),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary100,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: AppColors.primary400,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    GestureDetector(
                      onTap: () => controller.deleteStore(store),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.error100,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error200,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStoreLogo(Store store, bool isSelected) {
    if (store.logoUrl != null && store.logoUrl!.isNotEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary400 : Colors.grey[200]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            store.logoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(isSelected),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      );
    }
    
    return _buildDefaultLogo(isSelected);
  }

  Widget _buildDefaultLogo(bool isSelected) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isSelected ? AppColors.primary100 : AppColors.primary50,
        border: Border.all(
          color: isSelected ? AppColors.primary400 : Colors.transparent,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.store,
        size: 30,
        color: isSelected ? AppColors.primary500 : AppColors.primary400,
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success200;
      case 'pending':
        return AppColors.warning200;
      case 'not-active':
        return AppColors.error200;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'نشط';
      case 'pending':
        return 'قيد المراجعة';
      case 'not-active':
        return 'غير نشط';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير محدد';
    }
  }

  Widget _buildLoginRequiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
             Text(
              'يجب تسجيل الدخول',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
             Text(
              'يرجى تسجيل الدخول للوصول إلى إدارة الحسابات والمتاجر',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: 'تسجيل الدخول',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () {
                Get.toNamed('/login');
              },
            ),
            const SizedBox(height: 16),
            AateneButton(
              buttonText: 'إنشاء حساب جديد',
              textColor: AppColors.primary400,
              color: Colors.white,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () {
                Get.toNamed('/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}