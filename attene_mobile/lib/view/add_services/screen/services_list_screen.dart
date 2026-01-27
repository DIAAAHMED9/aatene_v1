import '../../../general_index.dart';
import '../../auth/screen/login_required_screen.dart';
import '../../../utils/responsive/index.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen>
    with TickerProviderStateMixin {
  final ServiceController _serviceController = Get.find<ServiceController>();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  final RxString _viewMode = 'list'.obs;
  final RxList<String> _selectedServiceIds = <String>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;

  List<Service> _allServices = [];
  List<TabData> _tabs = [];

  @override
  void initState() {
    super.initState();
    _initializeTabs();
    _loadServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeTabs() {
    _tabs = [
      TabData(label: 'جميع الخدمات', viewName: 'all'),
      TabData(label: 'نشط', viewName: 'active'),
      TabData(label: 'معتمد', viewName: 'approved'),
      TabData(label: 'قيد المراجعة', viewName: 'pending'),
      TabData(label: 'مسودة', viewName: 'draft'),
      TabData(label: 'مرفوض', viewName: 'rejected'),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _updateTabServices();
    }
  }

  Future<void> _loadServices() async {
    try {
      _isLoading.value = true;
      _allServices = await _serviceController.getAllServices();
      _errorMessage.value = '';
    } catch (e) {
      _errorMessage.value = 'فشل في تحميل الخدمات: $e';
      Get.snackbar(
        'خطأ',
        'فشل في تحميل الخدمات: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _refreshServices() async {
    await _loadServices();
  }

  void _updateTabServices() {
    setState(() {});
  }

  List<Service> _getServicesForTab(int tabIndex) {
    if (_allServices.isEmpty) return [];

    final tab = _tabs[tabIndex];
    final status = tab.viewName;

    List<Service> filteredServices = _allServices;

    if (status != 'all') {
      filteredServices = _allServices
          .where((service) => service.status == status)
          .toList();
    }

    if (_searchQuery.value.isNotEmpty) {
      filteredServices = filteredServices
          .where(
            (service) =>
                service.title.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ) ||
                (service.description ?? '').toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    return filteredServices;
  }

  void _navigateToAddService() {
    _serviceController.setCreateMode();
    Get.to(() => const AddServiceStepperScreen())?.then((result) {
      if (result == true) {
        _refreshServices();
      }
    });
  }

  void _navigateToEditService(Service service) {
    if (service.id == null) {
      Get.snackbar(
        'خطأ',
        'لا يمكن تعديل الخدمة بدون معرف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String serviceId = service.id.toString();
    _serviceController.setEditMode(serviceId, service.title);
    Get.to(() => EditServiceStepperScreen(serviceId: serviceId))?.then((result) {
      if (result == true) {
        _refreshServices();
      }
    });
  }

  Future<void> _deleteService(Service service) async {
    if (service.id == null) {
      Get.snackbar(
        'خطأ',
        'لا يمكن حذف الخدمة بدون معرف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String serviceId = service.id.toString();

    final confirm = await Get.defaultDialog<bool>(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من حذف الخدمة "${service.title}"؟',
      // textConfirm: 'نعم، احذف',
      // textCancel: 'إلغاء',
      actions: [
        AateneButton(
          onTap: () async {
            final result = await _serviceController.deleteService(serviceId);
            if (result?['success'] == true) {
              Get.back(result: true);
              await _refreshServices();
            }
          },
          buttonText: 'نعم، احذف',
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(result: false),
          buttonText: "إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
      //
      // confirmTextColor: Colors.white,
      // onConfirm: () async {
      //   final result = await _serviceController.deleteService(serviceId);
      //   if (result?['success'] == true) {
      //     Get.back(result: true);
      //     await _refreshServices();
      //   }
      // },
    );
  }

  void _toggleServiceSelection(String serviceId) {
    if (_selectedServiceIds.contains(serviceId)) {
      _selectedServiceIds.remove(serviceId);
    } else {
      _selectedServiceIds.add(serviceId);
    }
  }

  void _clearSelection() {
    _selectedServiceIds.clear();
  }

  void _showServiceDetails(Service service) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(service.title, style: getBold(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (service.images.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: service.images.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 200,
                              margin: EdgeInsets.only(
                                right: index < service.images.length - 1
                                    ? 8
                                    : 0,
                                left: index < service.images.length - 1 ? 8 : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _serviceController.getFullImageUrl(
                                      service.images[index],
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('${service.price} ₪', style: getBold()),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip(service.status),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'مدة التنفيذ: ${service.executeCount} ${_convertTimeUnit(service.executeType)}',
                      style: getRegular(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    if (service.specialties.isNotEmpty) ...[
                      Text('التخصصات:', style: getBold()),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: service.specialties
                            .map(
                              (specialty) => Chip(
                                label: Text(specialty),
                                backgroundColor: AppColors.primary50,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (service.tags.isNotEmpty) ...[
                      Text('الكلمات المفتاحية:', style: getBold()),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: service.tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                backgroundColor: Colors.grey[200],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text('الوصف:', style: getBold()),
                    Text(
                      service.description ?? '',
                      style: getRegular(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    if (service.extras.isNotEmpty) ...[
                      Text('التطويرات الإضافية:', style: getBold()),
                      ...service.extras.map(
                        (extra) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.add, size: 20),
                          title: Text(extra.title),
                          subtitle: Text(
                            '${extra.price} ₪ - ${extra.executionTime} ${extra.timeUnit}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (service.questions.isNotEmpty) ...[
                      Text('الأسئلة الشائعة:', style: getBold()),
                      ...service.questions.map(
                        (faq) => ExpansionTile(
                          title: Text(faq.question),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(faq.answer),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'قيد المراجعة';
        break;
      case 'draft':
        color = Colors.grey;
        text = 'مسودة';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'مرفوض';
        break;
      case 'approved':
        color = Colors.green;
        text = 'معتمد';
        break;
      case 'active':
        color = Colors.green;
        text = 'نشط';
        break;
      default:
        color = Colors.blue;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text, style: getRegular(fontSize: 12, color: color)),
    );
  }

  String _convertTimeUnit(String apiTimeUnit) {
    final Map<String, String> mapping = {
      'min': 'دقيقة',
      'hour': 'ساعة',
      'day': 'يوم',
      'week': 'أسبوع',
      'month': 'شهر',
      'year': 'سنة',
    };
    return mapping[apiTimeUnit] ?? 'ساعة';
  }

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
      child: Obx(() {
        final shouldShowTabs = _tabs.isNotEmpty && !_isLoading.value;

        return CustomAppBarWithTabs(
          isRTL: isRTL,
          config: AppBarConfig(
            title: 'خدماتي',
            actionText: ' + اضافة خدمة جديدة',
            onActionPressed: _navigateToAddService,
            tabs: _tabs,
            searchController: _searchController,
            onSearchChanged: (value) {
              _searchQuery.value = value;
              setState(() {});
            },
            onFilterPressed: () => Get.toNamed('/media-library'),
            onSortPressed: _openSort,
            tabController: shouldShowTabs ? _tabController : null,
            onTabChanged: (index) {
              if (shouldShowTabs) {
                _tabController.animateTo(index);
                setState(() {});
              }
            },
            showSearch: true,
            showTabs: shouldShowTabs,
          ),
        );
      }),
    );
  }

  double _calculateAppBarHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    double height = ResponsiveDimensions.f(175);

    final shouldShowTabs = _tabs.isNotEmpty && !_isLoading.value;

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

        return Obx(() {
          if (_isLoading.value && _allServices.isEmpty) {
            return _buildLoadingView(context);
          }

          if (_errorMessage.value.isNotEmpty) {
            return _buildErrorView(context);
          }

          return Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(_tabs.length, (index) {
                    return _buildTabContent(_tabs[index], index, context);
                  }),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          );
        });
      },
    );
  }

  Widget _buildTabContent(TabData tab, int tabIndex, BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshServices,
      child: _buildTabContentInternal(tab, tabIndex, context),
    );
  }

  Widget _buildTabContentInternal(
    TabData tab,
    int tabIndex,
    BuildContext context,
  ) {
    final services = _getServicesForTab(tabIndex);

    if (services.isEmpty) {
      return _buildEmptyView(tab.viewName, tabIndex, context);
    }

    return _buildServicesView(services, context);
  }

  Widget _buildServicesView(List<Service> services, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Obx(() {
      final isGridMode = _viewMode.value == 'grid' && screenWidth > 768;

      if (isGridMode) {
        return _buildGridLayout(services, context);
      } else {
        return _buildListLayout(services, context);
      }
    });
  }

  Widget _buildGridLayout(List<Service> services, BuildContext context) {
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
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final serviceId = service.id?.toString() ?? '';

          return ServiceGridItem(
            service: service,
            onTap: () => _showServiceDetails(service),
            onEdit: () => _navigateToEditService(service),
            onDelete: () => _deleteService(service),
            isSelected: _selectedServiceIds.contains(serviceId),
            onSelectionChanged: (isSelected) {
              if (serviceId.isNotEmpty) {
                _toggleServiceSelection(serviceId);
              }
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

  Widget _buildListLayout(List<Service> services, BuildContext context) {
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
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final serviceId = service.id?.toString() ?? '';

          return ServiceListItem(
            service: service,
            controller: _serviceController,
            isSelected: _serviceController.selectedServiceIds.contains(
              serviceId,
            ),
            onSelectionChanged: (isSelected) {
              _serviceController.toggleServiceSelection(serviceId);
            },
            onTap: () => _showServiceDetails(service),
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
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(16)),
          Text(
            'يرجى تسجيل الدخول للوصول إلى إدارة الخدمات',
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
            Icons.work_outline,
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
              color: Color(0xFF555555),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.f(12)),
          Text(
            _getEmptyDescription(sectionName, tabIndex),
            style: getRegular(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(12)
                  : ResponsiveDimensions.f(14),
              color: Color(0xFFAAAAAA),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.f(32)),
          if (tabIndex == 0)
            SizedBox(
              width: ResponsiveDimensions.f(200),
              child: AateneButton(
                onTap: _navigateToAddService,
                buttonText: "إضافة خدمة جديدة",
                textColor: AppColors.light1000,
                borderColor: AppColors.primary400,
                color: AppColors.primary400,
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
        return 'لا يوجد لديك أي خدمات';
      case 1:
        return 'لا توجد خدمات نشطة';
      case 2:
        return 'لا توجد خدمات معتمدة';
      case 3:
        return 'لا توجد خدمات قيد المراجعة';
      case 4:
        return 'لا توجد مسودات خدمات';
      case 5:
        return 'لا توجد خدمات مرفوضة';
      default:
        return 'لا توجد خدمات في قسم $sectionName';
    }
  }

  String _getEmptyDescription(String sectionName, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'يمكنك البدء بإضافة خدمات جديدة لعرضها هنا';
      case 1:
        return 'الخدمات النشطة ستظهر هنا بعد تفعيلها';
      case 2:
        return 'الخدمات المعتمدة ستظهر هنا بعد الموافقة عليها';
      case 3:
        return 'الخدمات قيد المراجعة ستظهر هنا بعد إضافتها';
      case 4:
        return 'يمكنك حفظ الخدمات كمسودات والعودة لإكمالها لاحقاً';
      case 5:
        return 'الخدمات المرفوضة ستظهر هنا مع إمكانية تعديلها وإعادة إرسالها';
      default:
        return 'يمكنك إضافة خدمات إلى هذا القسم';
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
          SizedBox(height: ResponsiveDimensions.f(16)),
          Text(
            'جاري تحميل الخدمات...',
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
          Text(
            'حدث خطأ',
            style: getBold(
              fontSize: isSmallScreen
                  ? ResponsiveDimensions.f(16)
                  : ResponsiveDimensions.f(18),
              color: Colors.red,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Obx(
            () => Text(
              _errorMessage.value,
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
            onPressed: _refreshServices,
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
              style: getRegular(fontSize: ResponsiveDimensions.f(14)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 80),
        ],
      ),
    );
  }

  void _openSort() {}
}
