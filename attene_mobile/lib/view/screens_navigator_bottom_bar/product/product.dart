import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import './product_controller.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final myAppController = Get.find<MyAppController>();
    final controller = Get.put(ProductController());

    return GetBuilder<ProductController>(
      id: controller.appBarUpdateId,
      builder: (ctx) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(ctx, isRTL),
          body: Obx(() => _buildBody(ctx, isRTL, myAppController)),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ProductController controller, bool isRTL) {
    return CustomAppBarWithTabs(
      key: ValueKey<int>(controller.tabs.length),
      isRTL: isRTL,
      config: AppBarConfig(
        title: 'المنتجات',
        actionText: ' + اضافة منتج جديد',
        onActionPressed: controller.navigateToAddProduct,
        tabs: controller.tabsList,
        searchController: controller.searchTextController,
        onSearchChanged: (value) => controller.searchQuery.value = value,
        onFilterPressed: () => Get.to(() => MediaLibraryScreen()),
        onSortPressed: controller.openSort,
        tabController: controller.tabController,
        onTabChanged: controller.changeTab,
        showSearch: true,
        showTabs: true,
      ),
    );
  }

  Widget _buildBody(ProductController controller, bool isRTL, MyAppController myAppController) {
    if (!myAppController.isLoggedIn.value) {
      return _buildLoginRequiredView();
    }

    return Column(
      children: [
        controller.getInitializationStatus(),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: controller.tabsList.map((tab) => _buildTabContent(tab, controller, isRTL)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(TabData tab, ProductController controller, bool isRTL) {
    final myAppController = Get.find<MyAppController>();
    
    if (!myAppController.isLoggedIn.value) {
      return _buildEmptyTabContent(tab);
    }

    if (!controller.sectionsLoaded && controller.initializationStep < 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('جاري تحميل الأقسام...'),
          ],
        ),
      );
    }

    if (controller.isLoadingProducts.value) {
      return _buildLoadingView();
    }

    if (controller.productsErrorMessage.isNotEmpty) {
      return _buildErrorView(controller);
    }

    final tabIndex = controller.tabsList.indexOf(tab);
    final products = controller.getProductsForTab(tabIndex);
    
    if (products.isEmpty) {
      return _buildEmptyProductsView(controller, isRTL, sectionName: tab.viewName);
    }

    if (tabIndex == 0) {
      return _buildAllProductsView(controller, isRTL);
    } else {
      return _buildProductsListView(products, controller, isRTL, sectionName: tab.viewName);
    }
  }

  Widget _buildAllProductsView(ProductController controller, bool isRTL) {
    final displaySections = controller.getDisplaySections();
    
    if (controller.totalProductsCount == 0) {
      return _buildEmptyProductsView(controller, isRTL);
    }
    
    if (displaySections.isEmpty) {
      return _buildProductsListView(controller.filteredProducts, controller, isRTL);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'إجمالي المنتجات: ${controller.totalProductsCount}',
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
            itemCount: displaySections.length,
            itemBuilder: (context, index) {
              final section = displaySections[index];
              final sectionName = section['name'] as String;
              final products = section['products'] as List<Product>;
              final isUncategorized = section['isUncategorized'] as bool;
              
              if (products.isEmpty) return const SizedBox.shrink();
              
              return _buildSectionWithProducts(
                sectionName,
                products,
                controller,
                isRTL,
                isUncategorized: isUncategorized,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWithProducts(String sectionName, List<Product> products, ProductController controller, bool isRTL, {bool isUncategorized = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUncategorized ? Colors.grey[100] : AppColors.primary50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sectionName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isUncategorized ? Colors.grey[600] : AppColors.primary500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${products.length} منتج',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUncategorized ? Colors.grey[600] : AppColors.primary500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductItem(product, controller, isRTL, showSection: false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsListView(List<Product> products, ProductController controller, bool isRTL, {String? sectionName}) {
    return Column(
      children: [
        if (sectionName != null)
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              sectionName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductItem(product, controller, isRTL, showSection: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Product product, ProductController controller, bool isRTL, {bool showSection = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: product.coverUrl != null && product.coverUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, color: Colors.grey[300]);
                          },
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
                      )
                    : Icon(Icons.image_outlined, color: Colors.grey[300], size: 30),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (showSection && product.sectionId != null && product.sectionId != '0')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.category_outlined, color: Colors.grey[500], size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                controller.getSectionName(product.sectionId!),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (product.shortDescription != null && product.shortDescription!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          product.shortDescription!,
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
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${product.price ?? '0'} ريال',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: product.shown ? Colors.green[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: product.shown ? Colors.green[100]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      product.shown ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        fontSize: 10,
                        color: product.shown ? Colors.green[700] : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editProduct(product),
                    icon: Icon(Icons.more_vert, color: Colors.grey[500], size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyProductsView(ProductController controller, bool isRTL, {String? sectionName}) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/png/empty_store.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Text(
                sectionName != null ? 'لا يوجد منتجات في قسم $sectionName' : 'لا يوجد لديك أي منتجات',
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w700
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 280,
                child: Text(
                  sectionName != null 
                    ? 'يمكنك البدء بإضافة منتجات جديدة إلى هذا القسم'
                    : 'يمكنك البدء بإضافة منتجات جديدة إلى الأقسام التي قمت بإنشائها',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFAAAAAA),
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              AateneButton(
                buttonText: isRTL ? 'إضافة منتج جديد' : 'Add New Product',
                textColor: Colors.white,
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                raduis: 10,
                onTap: controller.navigateToAddProduct,
              ),
              const SizedBox(height: 40),
              if (sectionName == null)
                _buildQuickStats(controller, isRTL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(ProductController controller, bool isRTL) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            'إحصائيات سريعة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الأقسام', '${controller.tabs.length - 3}'),
              _buildStatItem('المنتجات', '${controller.totalProductsCount}'),
              _buildStatItem('النشطة', '${controller.allProducts.where((p) => p.shown).length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary400,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary400),
          const SizedBox(height: 20),
          Text(
            'جاري تحميل المنتجات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(ProductController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
            const SizedBox(height: 20),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                controller.productsErrorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.reloadProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('العودة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              onPressed: () => Get.toNamed('/login'),
              icon: const Icon(Icons.login_rounded),
              label: const Text('تسجيل الدخول'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: AppColors.primary400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              tab.label,
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
    Get.defaultDialog(
      title: 'تحرير المنتج',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${product.name}'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'تحرير',
                    'سيتم فتح شاشة تحرير ${product.name}',
                    backgroundColor: AppColors.primary400,
                    colorText: Colors.white,
                  );
                },
                child: const Text('تحرير'),
              ),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}