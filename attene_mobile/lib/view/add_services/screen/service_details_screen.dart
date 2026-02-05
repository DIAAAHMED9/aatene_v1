import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';
import '../models/models.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String? serviceId;
  final Service? service;

  const ServiceDetailsScreen({super.key, this.serviceId, this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final ServiceController _serviceController = Get.find<ServiceController>();
  late Future<Service?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Service?> _load() async {
    if (widget.service != null) return widget.service;

    final args = Get.arguments;
    if (args is Map) {
      final maybeService = args['service'];
      if (maybeService is Service) return maybeService;
      final sid = (args['serviceId'] ?? '').toString().trim();
      if (sid.isNotEmpty) return await _fetchServiceById(sid);
    }

    final sid = (widget.serviceId ?? '').trim();
    if (sid.isNotEmpty) return await _fetchServiceById(sid);

    return null;
  }

  Future<Service?> _fetchServiceById(String serviceId) async {
    final response = await ApiHelper.get(
      path: '/merchants/services/$serviceId',
      withLoading: false,
      shouldShowMessage: false,
    );

    if (response == null || response['status'] != true) {
      throw Exception(response?['message'] ?? 'فشل في جلب تفاصيل الخدمة');
    }

    final data = response['data'];
    Map<String, dynamic>? serviceJson;

    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      if (m['service'] is Map) {
        serviceJson = Map<String, dynamic>.from(m['service'] as Map);
      } else if (m['data'] is Map) {
        serviceJson = Map<String, dynamic>.from(m['data'] as Map);
      } else {
        serviceJson = m;
      }
    } else if (data is List) {
      final found = data.cast<dynamic>().firstWhere(
            (e) => (e is Map) && e['id']?.toString() == serviceId,
            orElse: () => null,
          );
      if (found is Map) serviceJson = Map<String, dynamic>.from(found);
    }

    if (serviceJson == null) {
      throw Exception('Invalid service payload');
    }

    final normalized = <String, dynamic>{};
    serviceJson.forEach((k, v) {
      if (v is String && {'id', 'price', 'execute_count', 'section_id', 'category_id', 'store_id'}.contains(k)) {
        final n = num.tryParse(v);
        normalized[k] = n ?? v;
      } else {
        normalized[k] = v;
      }
    });

    return Service.fromApiJson(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isRTL ? 'تفاصيل الخدمة' : 'Service details',
          style: getBold(fontSize: ResponsiveDimensions.f(16)),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Service?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary400),
                  SizedBox(height: ResponsiveDimensions.f(12)),
                  Text(
                    isRTL ? 'جاري تحميل التفاصيل...' : 'Loading details...',
                    style: getMedium(fontSize: ResponsiveDimensions.f(13), color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return _errorView(isRTL, isSmallScreen, '${snapshot.error}');
          }

          final service = snapshot.data;
          if (service == null) {
            return _errorView(isRTL, isSmallScreen, isRTL ? 'تعذر العثور على الخدمة' : 'Service not found');
          }

          return _detailsView(service, isRTL, isSmallScreen);
        },
      ),
    );
  }

  Widget _errorView(bool isRTL, bool isSmallScreen, String message) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(isSmallScreen ? ResponsiveDimensions.f(20) : ResponsiveDimensions.f(28)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: ResponsiveDimensions.f(80), color: Colors.red),
          SizedBox(height: ResponsiveDimensions.f(12)),
          Text(
            isRTL ? 'حدث خطأ' : 'Error',
            style: getBold(fontSize: ResponsiveDimensions.f(18), color: Colors.red),
          ),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: getMedium(fontSize: ResponsiveDimensions.f(12), color: Colors.grey),
          ),
          SizedBox(height: ResponsiveDimensions.f(16)),
          ElevatedButton(
            onPressed: () => setState(() => _future = _load()),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary400, foregroundColor: Colors.white),
            child: Text(isRTL ? 'إعادة المحاولة' : 'Retry'),
          ),
        ],
      ),
    );
  }

  Widget _detailsView(Service service, bool isRTL, bool isSmallScreen) {
    final images = service.images;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? ResponsiveDimensions.f(16) : ResponsiveDimensions.f(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service.title, style: getBold(fontSize: ResponsiveDimensions.f(18))),
          SizedBox(height: ResponsiveDimensions.f(10)),

          if (images.isNotEmpty) ...[
            _ImagesCarousel(
              images: images,
              toUrl: (p) => _serviceController.getFullImageUrl(p),
            ),
            SizedBox(height: ResponsiveDimensions.f(16)),
          ],

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${service.price} ₪', style: getBold(fontSize: ResponsiveDimensions.f(14))),
              ),
              const SizedBox(width: 10),
              _StatusChip(status: service.status),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.f(14)),

          _InfoRow(
            title: isRTL ? 'مدة التنفيذ' : 'Execution time',
            value: '${service.executeCount} ${_convertTimeUnit(service.executeType, isRTL)}',
          ),
          SizedBox(height: ResponsiveDimensions.f(10)),

          if (service.specialties.isNotEmpty) ...[
            Text(isRTL ? 'التخصصات' : 'Specialties', style: getBold(fontSize: ResponsiveDimensions.f(14))),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: service.specialties.map((s) {
                return Chip(label: Text(s), backgroundColor: AppColors.primary50);
              }).toList(),
            ),
            SizedBox(height: ResponsiveDimensions.f(14)),
          ],

          if (service.tags.isNotEmpty) ...[
            Text(isRTL ? 'الكلمات المفتاحية' : 'Tags', style: getBold(fontSize: ResponsiveDimensions.f(14))),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: service.tags.map((t) {
                return Chip(label: Text(t), backgroundColor: Colors.grey[200]);
              }).toList(),
            ),
            SizedBox(height: ResponsiveDimensions.f(14)),
          ],

          Text(isRTL ? 'الوصف' : 'Description', style: getBold(fontSize: ResponsiveDimensions.f(14))),
          SizedBox(height: ResponsiveDimensions.f(6)),
          Text(service.description, style: getMedium(fontSize: ResponsiveDimensions.f(13))),
          SizedBox(height: ResponsiveDimensions.f(14)),

          if (service.extras.isNotEmpty) ...[
            Text(isRTL ? 'التطويرات الإضافية' : 'Extras', style: getBold(fontSize: ResponsiveDimensions.f(14))),
            SizedBox(height: ResponsiveDimensions.f(8)),
            ...service.extras.map((e) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.title, style: getMedium(fontSize: ResponsiveDimensions.f(13)))),
                    Text('${e.price} ₪', style: getBold(fontSize: ResponsiveDimensions.f(12))),
                  ],
                ),
              );
            }),
            SizedBox(height: ResponsiveDimensions.f(14)),
          ],

          if (service.questions.isNotEmpty) ...[
            Text(isRTL ? 'الأسئلة الشائعة' : 'FAQs', style: getBold(fontSize: ResponsiveDimensions.f(14))),
            SizedBox(height: ResponsiveDimensions.f(8)),
            ...service.questions.map((q) {
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(q.question, style: getMedium(fontSize: ResponsiveDimensions.f(13))),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(q.answer, style: getMedium(fontSize: ResponsiveDimensions.f(13))),
                    ),
                  )
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  String _convertTimeUnit(String apiTimeUnit, bool isRTL) {
    final Map<String, String> mappingAr = {
      'min': 'دقيقة',
      'hour': 'ساعة',
      'day': 'يوم',
      'week': 'أسبوع',
      'month': 'شهر',
      'year': 'سنة',
    };
    final Map<String, String> mappingEn = {
      'min': 'minute',
      'hour': 'hour',
      'day': 'day',
      'week': 'week',
      'month': 'month',
      'year': 'year',
    };
    return (isRTL ? mappingAr : mappingEn)[apiTimeUnit] ?? (isRTL ? 'ساعة' : 'hour');
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveDimensions.f(110),
            child: Text(title, style: getMedium(fontSize: ResponsiveDimensions.f(12), color: Colors.grey[600]!)),
          ),
          Expanded(child: Text(value, style: getMedium(fontSize: ResponsiveDimensions.f(13)))),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(text, style: getMedium(fontSize: ResponsiveDimensions.f(12), color: color)),
    );
  }
}

class _ImagesCarousel extends StatefulWidget {
  final List<String> images;
  final String Function(String path) toUrl;

  const _ImagesCarousel({required this.images, required this.toUrl});

  @override
  State<_ImagesCarousel> createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<_ImagesCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = ResponsiveDimensions.f(220);

    return Column(
      children: [
        SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) {
                final url = widget.toUrl(widget.images[i]);
                return Container(
                  color: Colors.grey[100],
                  child: url.isEmpty
                      ? const Center(child: Icon(Icons.image_not_supported))
                      : Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                        ),
                );
              },
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          SizedBox(height: ResponsiveDimensions.f(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: active ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary400 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ]
      ],
    );
  }
}