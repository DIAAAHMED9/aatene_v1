import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final isRTL = LanguageUtils.isRTL;
    final MyAppController myAppController = Get.find<MyAppController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithTabs(
        isRTL: isRTL,
        config: AppBarConfig(
          title: 'المنتجات',
          actionText: ' + اضافة منتج جديد',
          onActionPressed: controller.navigateToAddProduct,
          tabs: controller.tabs,
          searchController: controller.searchTextController,
          onSearchChanged: (value) => controller.searchQuery.value = value,
          onFilterPressed: () => Get.to(() => MediaLibraryScreen()),
          onSortPressed: controller.openSort,
          tabController: controller.tabController,
          onTabChanged: controller.changeTab,
          showSearch: true,
          showTabs: true,
        ),
      ),
      body: Obx(() => _buildBody(controller, isRTL, myAppController)),
    );
  }

  Widget _buildBody(ProductController controller, bool isRTL, MyAppController myAppController) {
    if (!myAppController.isLoggedIn.value) {
      return _buildLoginRequiredView();
    }

    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: controller.tabs.map((tab) => _buildTabContent(tab, controller, isRTL)).toList(),
          ),
        ),
      ],
    );
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
              'يرجى تسجيل الدخول للوصول إلى إدارة المنتجات والأقسام',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed('/login');
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('تسجيل الدخول'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Get.toNamed('/register');
              },
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('إنشاء حساب جديد'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(TabData tab, ProductController controller, bool isRTL) {
    final MyAppController myAppController = Get.find<MyAppController>();
    final BottomSheetController bottomSheetController = Get.find<BottomSheetController>();

    if (!myAppController.isLoggedIn.value) {
      return _buildEmptyTabContent(tab);
    }

    final hasSections = bottomSheetController.sections.isNotEmpty;

    if (!hasSections) {
      return _buildNoSectionsView(controller, isRTL);
    }

    if (controller.isLoadingProducts.value) {
      return _buildLoadingView();
    }

    if (controller.productsErrorMessage.isNotEmpty) {
      return _buildErrorView(controller);
    }

    final products = controller.getProductsForTab(controller.tabs.indexOf(tab));
    
    if (products.isEmpty) {
      return _buildEmptyProductsView(controller, isRTL);
    }

    return _buildProductsListView(controller, products, isRTL);
  }

  Widget _buildNoSectionsView(ProductController controller, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/png/empty_store.png')),
            const SizedBox(height: 24),
            Text(
              'لا يوجد لديك أي أقسام',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 280,
              child: Text(
                'إبدأ بإضافة أقسام متجرك لتتمكن من إضافة المنتجات وترتيبها بشكل منظم',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: isRTL ? 'إضافة قسم جديد للمتجر' : 'Add new Section for Store',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () {
                controller.openManageSections();
              },
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProductsView(ProductController controller, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/png/empty_store.png')),
            const SizedBox(height: 24),
            Text(
              'لا يوجد لديك أي منتجات',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 280,
              child: Text(
                'يمكنك البدء بإضافة منتجات جديدة إلى الأقسام التي قمت بإنشائها',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: isRTL ? 'إضافة منتج جديد' : 'Add New Product',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: controller.navigateToAddProduct,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('جاري تحميل المنتجات...'),
        ],
      ),
    );
  }

  Widget _buildErrorView(ProductController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
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
              controller.productsErrorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.reloadProducts();
            },
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsListView(ProductController controller, List<Product> products, bool isRTL) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'عرض ${products.length} منتج',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                onPressed: controller.openSort,
                icon: Icon(Icons.sort, color: AppColors.primary400),
              ),
              IconButton(
                onPressed: controller.openFilter,
                icon: Icon(Icons.filter_list, color: AppColors.primary400),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductItem(product, controller, isRTL);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Product product, ProductController controller, bool isRTL) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: product.coverUrl != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image, color: Colors.grey[400]);
                        },
                      ),
                    )
                  : Icon(Icons.image, color: Colors.grey[400]),
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Text(
                        'SKU: ${product.sku}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'قسم: ${product.sectionId ?? "غير محدد"}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(product.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(product.status),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      
                      Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        product.viewCount ?? '0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      Icon(Icons.favorite, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        product.favoritesCount,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    _editProduct(product);
                  },
                  icon: Icon(Icons.edit, color: AppColors.primary400),
                ),
                IconButton(
                  onPressed: () {
                    _deleteProduct(product, controller);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'not-active':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'not-active':
        return 'غير نشط';
      case 'pending':
        return 'قيد المراجعة';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير محدد';
    }
  }

  Widget _buildEmptyTabContent(TabData tab) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '${tab.label}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تسجيل الدخول مطلوب لعرض المحتوى',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(Product product) {
    Get.snackbar(
      'تحرير المنتج',
      'سيتم فتح شاشة تحرير ${product.name}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _deleteProduct(Product product, ProductController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف المنتج "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _performDeleteProduct(product, controller);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteProduct(Product product, ProductController controller) async {
    try {
      // await ApiHelper.delete(path: '/merchants/products/${product.id}');
      await controller.reloadProducts();
      
      Get.snackbar(
        'تم الحذف',
        'تم حذف المنتج بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف المنتج: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}