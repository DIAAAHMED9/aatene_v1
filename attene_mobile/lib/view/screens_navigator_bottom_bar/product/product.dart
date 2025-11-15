import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';



class ProductScreen extends GetView<ProductController> {
  
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final ProductController controller = Get.put(ProductController());

        final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isRTL: isRTL,controller: controller),
      body: _buildBody(isRTL),
    );
  }

  PreferredSizeWidget _buildAppBar({required bool isRTL,required ProductController controller }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _buildBoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 10),
                 _buildTabBar(),
              const SizedBox(height: 5),

              _buildSearchBox(isRTL: isRTL,controller: controller),
           
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(

      color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        offset: Offset(1, 1),
        blurRadius: 1,
        spreadRadius: 1
      )
    ]
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'المنتجات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () => controller.openManageSections(),
          child: Text(
            ' + اضافة منتج جديد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF3F52B4),
              fontSize: ResponsiveDimensions.f(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

Widget _buildSearchBox({required bool isRTL, required ProductController controller}) {
  return Row(
    children: [
      // أيقونة الفلتر على اليسار
      filterButton(
        assets: 'assets/images/png/filter_icon.png',
        onTap: () {
          controller.openFilter(); 
        },
      ),
      
      SizedBox(width: 8),
      
      // صندوق البحث (يأخذ المساحة المتبقية)
      Expanded(
        child: TextFiledAatene(
          heightTextFiled: 50,
          controller: controller.searchTextController,
          onChanged: (value) => controller.searchQuery.value = value,
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
suffixIcon: Transform.scale(
  scale: 0.6, 
  child: filterButton(
    assets: 'assets/icons/svg/search_icon_svg.svg',
    color: Colors.white,
    colorButton: AppColors.primary300


  ),
),          // Obx(
          //     () => controller.searchQuery.isNotEmpty
          //         ? InkWell(
          //             onTap: controller.clearSearch,
          //             child: Icon(Icons.close, color: Colors.grey[600]),
          //           )
          //         : SizedBox()) ,
           isRTL: isRTL, hintText: isRTL ? 'البحث في المنتجات...' : 'Search products...',
           
        ),
      ),
      
      SizedBox(width: 8),
      
      // أيقونة الترتيب على اليمين
      filterButton(
        assets: 'assets/images/png/sort_icon.png',
        onTap: () {
          controller.openSort(); 
        },
      ),
    ],
  );
}
Widget _buildUniversalImage(
  String assetPath, {
  Color? color,
  double size = 20,
}) {
  try {
    Widget imageWidget;
    
    if (assetPath.toLowerCase().endsWith('.svg')) {
      imageWidget = SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else {
      imageWidget = Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, size: size, color: Colors.grey);
        },
      );
    }

    // تطبيق اللون إذا كان مطلوباً
    if (color != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: imageWidget,
      );
    }
    
    return imageWidget;
    
  } catch (e) {
    debugPrint('Image loading failed: $assetPath, Error: $e');
    return Icon(
      Icons.error_outline, 
      size: size, 
      color: Colors.red,
    );
  }
}
Widget filterButton({
  required String assets, 
  Function()? onTap,
  Color? color,
  Color? colorButton,
  double size = 20,
  double containerSize = 36, // حجم الحاوية
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: containerSize, // تحديد عرض ثابت
      height: containerSize, // تحديد ارتفاع ثابت
      padding: EdgeInsets.all(6), // تقليل الـ padding
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE3E3E3)),
        color: colorButton??Colors.white,
        shape: BoxShape.circle,
      ),
      child: _buildUniversalImage(assets, color: color, size: size),
    ),
  );
}
Widget _buildTabBar() {
  return SizedBox(
    height: 45,
    child: TabBar(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: controller.tabController,
      labelPadding: const EdgeInsets.all(10),
      indicator: BoxDecoration(
      
        borderRadius: BorderRadius.circular(20), // حواف دائرية
        color: Color(0x1A5B87B9), // خلفية زرقاء فاتحة للتب المختار
      ),
      labelColor: Color(0XFF2D496A), // لون النص عند الاختيار
      indicatorColor: Colors.transparent, // إخفاء الخط السفلي الافتراضي
      unselectedLabelColor: Color(0XFF868687),
      onTap: controller.changeTab,
      tabs: controller.tabs
          .map(
            (tab) => Tab(
              iconMargin: EdgeInsets.all(0),
              // icon: Icon(tab.icon),
              text: tab.label,
            ),
          )
          .toList(),
    ),
  );
}

  Widget _buildBody(bool isRTL) {
    return TabBarView(
      controller: controller.tabController,
      children:
      
       controller.tabs.map((tab) => _buildTabContent(tab,true,isRTL)).toList(),
    );
  }

  Widget _buildTabContent(TabData tab,bool isEmptyScreen,bool isRTL) {
    return isEmptyScreen?
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    _buildUniversalImage('assets/images/png/empty_store.png',size: 150),
    Text('لا يوجد لديك أي منتجات ',style: TextStyle(
      fontSize: ResponsiveDimensions.f(22),fontWeight: FontWeight.w700,color: Color(0xFF555555),
    ),),
    Text('إبدأ بإضافة أقسام متجرك لتتمكن من إضافة المنتجات',style:TextStyle(
      fontSize: ResponsiveDimensions.f(14),fontWeight: FontWeight.w500,color: Color(0xFF555555),),),
    SizedBox(height: 10,),
AateneButton(
  buttonText: isRTL? 'إضافة قسم جديد للمتجر':'',
          textColor: Colors.white,
                  color: AppColors.primary400,
                  borderColor: AppColors.primary400,
  raduis: 10
  ,
  onTap: () => controller.openManageSections(),
),
SizedBox(height: 130,)
  ],

    ) :Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tab.viewName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Text(
            'Current Tab: ${controller.currentTabIndex.value + 1}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 20),
        if (controller.searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Searching for: "${controller.searchQuery.value}"',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.teal.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
