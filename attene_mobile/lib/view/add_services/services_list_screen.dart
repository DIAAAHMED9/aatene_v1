import 'package:attene_mobile/five_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/add_services/service_controller.dart';
import 'package:attene_mobile/view/add_services/responsive_dimensions.dart';

import 'models/models.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final ServiceController _controller = Get.find<ServiceController>();
  final ScrollController _scrollController = ScrollController();
  List<Service> _services = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadServices({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _services.clear();
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _controller.getAllServices(
        page: _currentPage,
        limit: _limit,
      );

      if (refresh) {
        _services = services;
      } else {
        _services.addAll(services);
      }

      _hasMore = services.length == _limit;
      _currentPage++;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحميل الخدمات: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadServices();
    }
  }

  Future<void> _refreshServices() async {
    await _loadServices(refresh: true);
  }

  void _navigateToAddService() {
    _controller.setCreateMode();
    Get.to(() => const ServiceStepperScreen());
  }

  void _navigateToEditService(Service service) {
    _controller.setEditMode(service.id!, service.title);
    Get.to(() => ServiceStepperScreen(isEditMode: true, serviceId: service.id));
  }

  Future<void> _deleteService(Service service) async {
    final confirm = await Get.defaultDialog<bool>(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من حذف الخدمة "${service.title}"؟',
      textConfirm: 'نعم، احذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final result = await _controller.deleteService(service.id!);
        if (result?['success'] == true) {
          Get.back(result: true);
          _refreshServices();
        }
      },
      onCancel: () => Get.back(result: false),
    );
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
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(service.images[index]),
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
                          child: Text(
                            '${service.price} ₪',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip(service.status),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'مدة التنفيذ: ${service.executeCount} ${_convertTimeUnit(service.executeType)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    if (service.specialties.isNotEmpty) ...[
                      const Text(
                        'التخصصات:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      const Text(
                        'الكلمات المفتاحية:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

                    const Text(
                      'الوصف:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      service.description,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    if (service.extras.isNotEmpty) ...[
                      const Text(
                        'التطويرات الإضافية:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      const Text(
                        'الأسئلة الشائعة:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('خدماتي'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshServices,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshServices,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToAddService,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة خدمة جديدة'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary400,
                  ),
                ),
              ),
            ),

            Expanded(
              child: _services.isEmpty && !_isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد خدمات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'انقر على زر "إضافة خدمة جديدة" لبدء إنشاء خدمتك الأولى',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveDimensions.responsiveWidth(16),
                      ),
                      itemCount: _services.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _services.length) {
                          return _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox();
                        }

                        final service = _services[index];
                        return _buildServiceItem(service);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Service service) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveDimensions.responsiveHeight(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(
          ResponsiveDimensions.responsiveWidth(16),
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: service.images.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.work_outline, color: AppColors.primary500),
                  ),
                )
              : Icon(Icons.work_outline, color: AppColors.primary500),
        ),
        title: Text(
          service.title,
          style: TextStyle(
            fontSize: ResponsiveDimensions.responsiveFontSize(16),
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'السعر: ${service.price} ₪',
              style: TextStyle(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            _buildStatusChip(service.status),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _navigateToEditService(service);
                break;
              case 'delete':
                _deleteService(service);
                break;
              case 'view':
                _showServiceDetails(service);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('عرض التفاصيل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showServiceDetails(service),
      ),
    );
  }
}
