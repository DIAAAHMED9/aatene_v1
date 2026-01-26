import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';

class ProductScreen extends GetView<ProductController> {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isRTL, context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isRTL, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_calculateAppBarHeight(context)),
      child: GetBuilder<ProductController>(
        builder: (controller) {
          final bool shouldShowTabs =
              controller.tabs.isNotEmpty && controller.isTabControllerReady;

          return CustomAppBarWithTabs(
            isRTL: isRTL,
            config: AppBarConfig(
              title: 'المنتجات',
              actionText: ' + اضافة منتج جديد',
              onActionPressed: controller.navigateToAddProduct,
              tabs: controller.tabs,
              searchController: controller.searchTextController,
              onSearchChanged: (value) {
                controller.searchQuery.value = value;
              },
              onFilterPressed: () => Get.toNamed('/media-library'),
              onSortPressed: () {
                if (controller.isTabControllerReady) {
                  controller.openSort();
                }
              },
              tabController: shouldShowTabs ? controller.tabController : null,
              onTabChanged: (index) {
                if (shouldShowTabs) {
                  controller.changeTab(index);
                }
              },
              showSearch: true,
              showTabs: shouldShowTabs,
            ),
          );
        },
      ),
    );
  }

  double _calculateAppBarHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    double height = ResponsiveDimensions.f(175);

    final controller = Get.find<ProductController>();
    final shouldShowTabs =
        controller.tabs.isNotEmpty && controller.isTabControllerReady;

    if (shouldShowTabs) {
      height += ResponsiveDimensions.f(45);
      height += ResponsiveDimensions.f(15);
    }

    height += ResponsiveDimensions.f(60);
    height += ResponsiveDimensions.f(15);

    return height;
  }

  Widget _buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GetBuilder<MyAppController>(
      builder: (myAppController) {
        if (!myAppController.isLoggedIn.value) {
          return _buildLoginRequiredView(context);
        }

        return GetBuilder<ProductController>(
          builder: (productController) {
            if (!productController.isTabControllerReady ||
                productController.tabs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary400),
                    SizedBox(height: ResponsiveDimensions.f(16)),
                    Text(
                      'جاري تحميل التبويبات...',
                      style: getRegular(
                        fontSize: ResponsiveDimensions.f(14),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: productController.tabController,
                    children: List.generate(productController.tabs.length, (
                      index,
                    ) {
                      return _buildTabContent(
                        productController.tabs[index],
                        index,
                        context,
                      );
                    }),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTabContent(TabData tab, int tabIndex, BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshProducts();
          },
          child: _buildTabContentInternal(tab, tabIndex, context),
        );
      },
    );
  }

  Widget _buildTabContentInternal(
    TabData tab,
    int tabIndex,
    BuildContext context,
  ) {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (controller.isLoadingProducts && controller.allProducts.isEmpty) {
          return _buildLoadingView(context);
        }

        if (controller.productsErrorMessage.isNotEmpty) {
          return _buildErrorView(context);
        }

        final products = controller.getProductsForTab(tabIndex);

        if (products.isEmpty) {
          return _buildEmptyView(tab.viewName, tabIndex, context);
        }

        return _buildProductsView(products, context);
      },
    );
  }

  Widget _buildProductsView(List<Product> products, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GetBuilder<ProductController>(
      builder: (controller) {
        final isGridMode = controller.viewMode == 'grid' && screenWidth > 768;

        if (isGridMode) {
          return _buildGridLayout(products, context);
        } else {
          return _buildListLayout(products, context);
        }
      },
    );
  }

  Widget _buildGridLayout(List<Product> products, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getGridCrossAxisCount(context);
    final spacing = screenWidth < 600
        ? ResponsiveDimensions.f(8)
        : ResponsiveDimensions.f(16);

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: screenWidth < 600 ? 0.7 : 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductGridItem(
            product: products[index],
            controller: controller,
            isSelected: controller.selectedProductIds.contains(
              '${products[index].id}',
            ),
            onSelectionChanged: (isSelected) {
              controller.toggleProductSelection('${products[index].id}');
            },
          );
        },
      ),
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) return 2;
    if (screenWidth < 600) return 3;
    if (screenWidth < 900) return 3;
    if (screenWidth < 1200) return 4;
    return 5;
  }

  Widget _buildListLayout(List<Product> products, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(
          isSmallScreen
              ? ResponsiveDimensions.f(12)
              : ResponsiveDimensions.f(16),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductListItem(
            product: products[index],
            controller: controller,
            isSelected: controller.selectedProductIds.contains(
              '${products[index].id}',
            ),
            onSelectionChanged: (isSelected) {
              controller.toggleProductSelection('${products[index].id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildLoginRequiredView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        isSmallScreen ? ResponsiveDimensions.f(24) : ResponsiveDimensions.f(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login_rounded,
            size: ResponsiveDimensions.f(100),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveDimensions.f(24)),
          Text(
            'يجب تسجيل الدخول',
            style: getBold(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(20)
                  : ResponsiveDimensions.f(24),
              color: Colors.grey,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(16)),
          Text(
            'يرجى تسجيل الدخول للوصول إلى إدارة المنتجات والأقسام',
            style: getRegular(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(14)
                  : ResponsiveDimensions.f(16),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.f(32)),
          SizedBox(
            width: ResponsiveDimensions.f(200),
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed('/login'),
              icon: Icon(Icons.login_rounded, size: ResponsiveDimensions.f(20)),
              label: Text(
                'تسجيل الدخول',
                style: getRegular(fontSize: ResponsiveDimensions.f(14)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveDimensions.f(16),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 80),
        ],
      ),
    );
  }

  Widget _buildEmptyView(
    String sectionName,
    int tabIndex,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        isSmallScreen ? ResponsiveDimensions.f(24) : ResponsiveDimensions.f(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveDimensions.f(100),
            color: Colors.grey[300],
          ),
          SizedBox(height: ResponsiveDimensions.f(24)),
          Text(
            _getEmptyMessage(sectionName, tabIndex),
            style: getBold(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(18)
                  : ResponsiveDimensions.f(22),
              color: AppColors.neutral400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.f(12)),
          Text(
            _getEmptyDescription(sectionName, tabIndex),
            style: getMedium(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(12)
                  : ResponsiveDimensions.f(14),
              color: AppColors.neutral700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.f(32)),
          if (tabIndex == 0)
            SizedBox(
              width: ResponsiveDimensions.f(200),
              child: ElevatedButton(
                onPressed: controller.navigateToAddProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.f(16),
                  ),
                ),
                child: Text(
                  'إضافة منتج جديد',
                  style: getRegular(
                    color: Colors.white,
                    fontSize: ResponsiveDimensions.f(14),
                  ),
                ),
              ),
            ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 80),
        ],
      ),
    );
  }

  String _getEmptyMessage(String sectionName, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'لا يوجد لديك أي منتجات';
      case 1:
        return 'لا يوجد عروض حالية';
      case 2:
        return 'لا توجد مراجعات';
      default:
        return 'لا يوجد منتجات في قسم $sectionName';
    }
  }

  String _getEmptyDescription(String sectionName, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'يمكنك البدء بإضافة منتجات جديدة إلى الأقسام التي قمت بإنشائها';
      case 1:
        return 'يمكنك إضافة عروض خاصة على منتجاتك لجذب المزيد من العملاء';
      case 2:
        return 'مراجعات العملاء ستظهر هنا عندما يبدأ العملاء بالتفاعل مع منتجاتك';
      default:
        return 'يمكنك إضافة منتجات إلى هذا القسم من خلال زر "إضافة منتج جديد"';
    }
  }

  Widget _buildLoadingView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary400),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'جاري تحميل المنتجات...',
            style: getRegular(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(14)
                  : ResponsiveDimensions.f(16),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(
        isSmallScreen ? ResponsiveDimensions.f(24) : ResponsiveDimensions.f(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveDimensions.f(80),
            color: Colors.red,
          ),
          SizedBox(height: ResponsiveDimensions.f(16)),
          Text('حدث خطأ', style: getBold(color: Colors.red)),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Obx(
            () => Text(
              controller.productsErrorMessage,
              textAlign: TextAlign.center,
              style: getRegular(
                fontSize: isSmallScreen
                    ? ResponsiveDimensions.f(12)
                    : ResponsiveDimensions.f(14),
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(16)),
          ElevatedButton(
            onPressed: controller.reloadProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary400,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.f(24),
                vertical: ResponsiveDimensions.f(12),
              ),
            ),
            child: Text(
              'إعادة المحاولة',
              style: getRegular(color: Colors.white),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 80),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GetBuilder<MyAppController>(
      builder: (myAppController) {
        if (!myAppController.isLoggedIn.value) return const SizedBox();

        return FloatingActionButton.extended(
          onPressed: controller.navigateToAddProduct,
          icon: Icon(Icons.add, size: ResponsiveDimensions.f(20)),
          label: Text(
            'إضافة منتج',
            style: getRegular(fontSize: ResponsiveDimensions.f(14)),
          ),
          backgroundColor: AppColors.primary400,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveDimensions.f(50)),
          ),
        );
      },
    );
  }
}
