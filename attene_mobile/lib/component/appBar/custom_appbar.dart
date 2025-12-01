// lib/component/appBar/custom_appbar.dart
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';

class CustomAppBarWithTabs extends StatelessWidget implements PreferredSizeWidget {
  final AppBarConfig config;
  final bool isRTL;

  const CustomAppBarWithTabs({
    Key? key,
    required this.config,
    required this.isRTL,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(_calculateHeight());

  double _calculateHeight() {
    double height = 70; // الارتفاع الأساسي
    if (config.showTabs && (config.tabs?.isNotEmpty ?? false)) height += 45;
    if (config.showSearch) height += 60;
    return height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration:config.tabs!=null? _buildBoxDecoration():null,
      child:config.tabs!=null?SafeArea(
        child: Column(
          children: _buildAppBarContent(),
        ),
      ):Column(
          children: _buildAppBarContent(),
        ),
    );
  }

  List<Widget> _buildAppBarContent() {
    final List<Widget> children = [
    config.tabs!=null?  _buildTopBar():SizedBox(),
    config.tabs!=null?   const SizedBox(height: 15):SizedBox(),
    ];

    if (config.showTabs && (config.tabs?.isNotEmpty ?? false) && config.tabController != null) {
    config.tabs!=null?  children.addAll([
        _buildTabBar(),
        const SizedBox(height: 15),
      ]):SizedBox();
    }

    if (config.showSearch) {
      children.add(_buildSearchBox());
    }

    return children;
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          offset: const Offset(1, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          config.title,
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        if (config.actionText?.isNotEmpty ?? false)
          GestureDetector(
            onTap: config.onActionPressed,
            child: Text(
              config.actionText ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary400,
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabBar() {
    if (config.tabController == null || config.tabs == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 45,
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        controller: config.tabController!,
        labelPadding: const EdgeInsets.all(10),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0x1A5B87B9),
        ),
        labelColor: const Color(0XFF2D496A),
        indicatorColor: Colors.transparent,
        unselectedLabelColor: const Color(0XFF868687),
        onTap: config.onTabChanged,
        tabs: config.tabs!
            .map(
              (tab) => Tab(
                iconMargin: EdgeInsets.all(0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(tab.icon, size: 16),
                      const SizedBox(width: 4),
                    ],
                    Text(tab.label),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Row(
      children: [
        // أيقونة الفلتر
        if (config.onFilterPressed != null)
          _buildFilterButton(
            assets: 'assets/images/png/filter_icon.png',
            onTap: config.onFilterPressed!,
          ),
        
        if (config.onFilterPressed != null) const SizedBox(width: 8),
        
        // صندوق البحث
        Expanded(
          child: TextFiledAatene(
            heightTextFiled: 50,
            controller: config.searchController,
            onChanged: config.onSearchChanged,
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: Transform.scale(
              scale: 0.6,
              child: _buildFilterButton(
                assets: 'assets/icons/svg/search_icon_svg.svg',
                color: Colors.white,
                colorButton: AppColors.primary300,
              ),
            ),
            isRTL: isRTL,
            hintText: isRTL ? 'بحث...' : 'Search...',
          ),
        ),
        
        if (config.onSortPressed != null) const SizedBox(width: 8),
        
        // أيقونة الترتيب
        if (config.onSortPressed != null)
          _buildFilterButton(
            assets: 'assets/images/png/sort_icon.png',
            onTap: config.onSortPressed!,
          ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String assets,
    Function()? onTap,
    Color? color,
    Color? colorButton,
    double size = 20,
    double containerSize = 36,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: containerSize,
        height: containerSize,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE3E3E3)),
          color: colorButton ?? Colors.white,
          shape: BoxShape.circle,
        ),
        child: _buildUniversalImage(assets, color: color, size: size),
      ),
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
}