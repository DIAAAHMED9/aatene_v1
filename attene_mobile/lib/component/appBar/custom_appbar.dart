

import '../../general_index.dart';


class CustomAppBarWithTabs extends StatelessWidget
    implements PreferredSizeWidget {
  final AppBarConfig config;
  final bool isRTL;

  const CustomAppBarWithTabs({
    Key? key,
    required this.config,
    required this.isRTL,
  }) : super(key: key);

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
          MediaQuery.of(context).size.width < 1024;

  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Size get preferredSize => Size.fromHeight(_calculateHeight(Get.context!));

  double _calculateHeight(BuildContext context) {
    double baseHeight;

    if (_isMobile(context)) {
      baseHeight = 140;
    } else if (_isTablet(context)) {
      baseHeight = 160;
    } else {
      baseHeight = 180;
    }

    if (config.showTabs && (config.tabs?.isNotEmpty ?? false)) {
      baseHeight += _getTabBarHeight(context);
    }

    if (config.showSearch) {
      baseHeight += _getSearchFieldHeight(context) + 16;
    }

    return baseHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: _isMobile(context) ? 0 : 8,
        bottom: _isMobile(context) ? 8 : 12,
      ),
      padding: EdgeInsets.zero,
      decoration: _buildBoxDecoration(context),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildAppBarContent(context),
        ),
      ),
    );
  }

  List<Widget> _buildAppBarContent(BuildContext context) {
    final List<Widget> children = [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _isMobile(context)
              ? 12
              : _isTablet(context)
              ? 20
              : 28,
        ),
        child: _buildTopBar(context),
      ),
      const SizedBox(height: 12),
    ];

    if (config.showTabs &&
        (config.tabs?.isNotEmpty ?? false) &&
        config.tabController != null) {
      children.add(_buildTabBar(context));
      children.add(const SizedBox(height: 12));
    }

    if (config.showSearch) {
      children.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _isMobile(context)
                ? 12
                : _isTablet(context)
                ? 20
                : 28,
          ),
          child: _buildSearchBox(context),
        ),
      );
    }

    return children;
  }

  BoxDecoration _buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          offset: const Offset(0, 2),
          blurRadius: _isMobile(context) ? 4 : 8,
          spreadRadius: 0,
        ),
      ],
      borderRadius: _isMobile(context)
          ? BorderRadius.circular(0)
          : BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_isMobile(context) && Navigator.of(context).canPop())
          IconButton(
            icon: Icon(
              isRTL ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.grey[700],
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile(context) ? 8 : 0,
            ),
            child: Text(
              config.title,
              style: TextStyle(
                fontSize: _getTitleFontSize(context),
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: "PingAR",
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        if (config.actionText.isNotEmpty && config.onActionPressed != null)
          _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final isSmallMobile = MediaQuery.of(context).size.width < 400;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: config.onActionPressed,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              config.actionText,
              style: TextStyle(
                color: AppColors.primary400,
                fontSize: _isMobile(context) ? 17 : 19,
                fontWeight: FontWeight.w600,
                fontFamily: "PingAR",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    if (config.tabController == null ||
        config.tabs == null ||
        config.tabs!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: _getTabBarHeight(context),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: _TabBarWithFullLabels(
        controller: config.tabController!,
        tabs: config.tabs!,
        onTap: config.onTabChanged,
        isRTL: isRTL,
        isMobile: _isMobile(context),
        isTablet: _isTablet(context),
        isDesktop: _isDesktop(context),
      ),
    );
  }

  double _getTabBarHeight(BuildContext context) {
    if (_isMobile(context)) return 44;
    if (_isTablet(context)) return 48;
    return 52;
  }

  double _getTitleFontSize(BuildContext context) {
    if (_isMobile(context)) return 20;
    if (_isTablet(context)) return 22;
    return 24;
  }

  Widget _buildSearchBox(BuildContext context) {
    return Row(
      children: [
        if (config.onFilterPressed != null)
          Padding(
            padding: EdgeInsets.only(right: _isMobile(context) ? 8 : 12),
            child: _buildIconButton(
              icon: Icons.filter_list_rounded,
              onTap: config.onFilterPressed!,
              context: context,
              tooltip: 'تصفية',
            ),
          ),
        SizedBox(width: 5),

        Expanded(
          child: Container(
            height: _getSearchFieldHeight(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_isMobile(context) ? 25 : 25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: config.searchController,
                    onChanged: config.onSearchChanged,

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: _isMobile(context) ? 20 : 22,
                      ),
                      border: InputBorder.none,
                      hintText: isRTL
                          ? 'بحث'
                          : 'Search products...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: _isMobile(context) ? 14 : 15,
                        fontFamily: "PingAR",
                      ),
                    ),
                    style: TextStyle(
                      fontSize: _isMobile(context) ? 14 : 15,
                      color: Colors.black87,
                      fontFamily: "PingAR",
                    ),
                  ),
                ),
                if (config.searchController?.text.isNotEmpty ?? false)
                  Padding(
                    padding: EdgeInsets.only(
                      right: _isMobile(context) ? 8 : 12,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        config.searchController?.clear();
                        config.onSearchChanged?.call('');
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[500],
                        size: _isMobile(context) ? 18 : 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5),
        if (config.onSortPressed != null)
          Padding(
            padding: EdgeInsets.only(left: _isMobile(context) ? 8 : 12),
            child: _buildIconButton(
              icon: Icons.sort_rounded,
              onTap: config.onSortPressed!,
              context: context,
              tooltip: 'ترتيب',
            ),
          ),
      ],
    );
  }

  double _getSearchFieldHeight(BuildContext context) {
    if (_isMobile(context)) return 48;
    if (_isTablet(context)) return 52;
    return 56;
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
    String? tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: _isMobile(context) ? 44 : 48,
          height: _isMobile(context) ? 44 : 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: _isMobile(context) ? 20 : 22,
            color: Colors.grey[700],
          ),
        ),
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
      return Icon(Icons.error_outline, size: size, color: Colors.red);
    }
  }
}

class _TabBarWithFullLabels extends StatefulWidget {
  final TabController controller;
  final List<TabData> tabs;
  final ValueChanged<int>? onTap;
  final bool isRTL;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const _TabBarWithFullLabels({
    required this.controller,
    required this.tabs,
    this.onTap,
    required this.isRTL,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  __TabBarWithFullLabelsState createState() => __TabBarWithFullLabelsState();
}

class __TabBarWithFullLabelsState extends State<_TabBarWithFullLabels> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.controller,
      isScrollable: true,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.primary400,
      ),
      indicatorColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey[600],
      labelPadding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 12 : 16),
      padding: EdgeInsets.only(
        left: widget.isRTL ? 0 : (widget.isMobile ? 12 : 20),
        right: widget.isRTL ? (widget.isMobile ? 12 : 20) : 0,
      ),
      labelStyle: TextStyle(
        fontSize: widget.isMobile
            ? 13
            : widget.isTablet
            ? 14
            : 15,
        fontWeight: FontWeight.w600,
        fontFamily: "PingAR",
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: widget.isMobile
            ? 13
            : widget.isTablet
            ? 14
            : 15,
        fontWeight: FontWeight.w500,
        fontFamily: "PingAR",
      ),
      tabs: widget.tabs.map((tab) {
        return _buildTabItem(tab);
      }).toList(),
      onTap: widget.onTap,
    );
  }

  Widget _buildTabItem(TabData tab) {
    return Tab(
      child: Container(
        constraints: BoxConstraints(
          minWidth: widget.isMobile
              ? 80
              : widget.isTablet
              ? 100
              : 120,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null && !widget.isMobile) ...[
              Icon(
                tab.icon,
                size: widget.isMobile
                    ? 14
                    : widget.isTablet
                    ? 16
                    : 18,
              ),
              SizedBox(width: widget.isMobile ? 4 : 6),
            ],
            Flexible(
              child: Text(
                _getTabLabel(tab.label),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: widget.isMobile
                      ? 13
                      : widget.isTablet
                      ? 14
                      : 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: "PingAR",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabLabel(String label) {
    if (widget.isMobile && label.length > 15) {
      return '${label.substring(0, 12)}...';
    }
    return label;
  }
}