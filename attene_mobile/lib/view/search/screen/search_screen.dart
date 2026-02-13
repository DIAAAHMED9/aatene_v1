import 'package:attene_mobile/component/user_card.dart';
import 'package:attene_mobile/general_index.dart' hide SearchController;
import 'package:attene_mobile/view/search/controller/search_controller.dart';
import 'package:attene_mobile/view/search/widget/search_type.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _history = ['ملابس أطفال', 'براند', 'ديكور منزلي'];
  String? _removedItem;
  int? _removedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final controller = Get.find<SearchController>();
      if (controller.hasMore.value && !controller.isLoading.value) {
        controller.loadMore();
      }
    }
  }

  void _addSearch() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;
    setState(() => _history.insert(0, text));

    final controller = Get.find<SearchController>();
    controller.updateSearchQuery(text);
  }

  void _removeItem(int index) {
    setState(() {
      _removedItem = _history[index];
      _removedIndex = index;
      _history.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'تم حذف العنصر',
          style: getBold(color: AppColors.light1000),
        ),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: AppColors.primary50,
          onPressed: () {
            if (_removedItem != null && _removedIndex != null) {
              setState(() {
                _history.insert(_removedIndex!, _removedItem!);
              });
            }
          },
        ),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مسح الكل'),
        content: const Text('هل أنت متأكد من مسح جميع عمليات البحث؟'),
        actions: [
          AateneButton(
            onTap: () {
              setState(() => _history.clear());
              Get.back();
            },
            buttonText: 'تأكيد',
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          const SizedBox(height: 10),
          AateneButton(
            onTap: () => Get.back(),
            buttonText: 'الغاء',
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return GetBuilder<SearchController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFiledAatene(
                          isRTL: isRTL,
                          hintText: "ابحث عن اي شيء في اعطيني",
                          textInputAction: TextInputAction.done,
                          controller: _searchController,
                          onChanged: controller.updateSearchQuery,
                          onSubmitted: (_) => _addSearch(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 85,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          icon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.search, color: Colors.white),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const SearchTypeBottomSheet(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('البحث الأخير', style: getBold(fontSize: 18)),
                      TextButton(
                        onPressed: _history.isEmpty ? null : _clearAll,
                        child: Text(
                          'امسح الكل',
                          style: getMedium(
                            fontSize: 12,
                            color: AppColors.error200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _history.length,
                      (index) => Chip(
                        backgroundColor: AppColors.primary50,
                        label: Text(_history[index]),
                        deleteIcon: const Icon(Icons.close, size: 15),
                        onDeleted: () => _removeItem(index),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _getSectionTitle(controller.selectedType.value),
                      style: getBold(fontSize: 16),
                    ),
                  ),

                  Expanded(child: _buildResultsGrid(controller)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSectionTitle(SearchType type) {
    switch (type) {
      case SearchType.products:
        return 'المنتجات';
      case SearchType.services:
        return 'الخدمات';
      case SearchType.stores:
        return 'المتاجر';
      case SearchType.users:
        return 'المستخدمين';
    }
  }

  Widget _buildResultsGrid(SearchController controller) {
    if (controller.isLoading.value && controller.currentResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError.value && controller.currentResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.loadInitialData(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (controller.currentResults.isEmpty) {
      return Center(
        child: Column(
          spacing: 5,
          children: [
            Image.asset(
              "assets/images/png/No_Search.png",
              width: 340,
              height: 250,
              fit: BoxFit.cover,
            ),
            Text(
              controller.searchQuery.value.isEmpty
                  ? 'لم يتم العثور عليها'
                  : 'لم يتم العثور عليها',
              style: getBold(fontSize: 24),
            ),
            Text(
              controller.searchQuery.value.isEmpty
                  ? 'عذرًا ، لا يمكن العثور على الكلمة الرئيسية التي أدخلتها ، يرجى التحقق مرة أخرى أو البحث بكلمة رئيسية أخرى .'
                  : 'عذرًا ، لا يمكن العثور على الكلمة الرئيسية التي أدخلتها ، يرجى التحقق مرة أخرى أو البحث بكلمة رئيسية أخرى .',
              style: getMedium(color: AppColors.neutral200),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadInitialData(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount:
            controller.currentResults.length +
            (controller.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.currentResults.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final item = controller.currentResults[index];
          return _buildResultCard(controller.selectedType.value, item);
        },
      ),
    );
  }

  Widget _buildResultCard(SearchType type, Map<String, dynamic> data) {
    print('dataProduct = $data');
    switch (type) {
      case SearchType.products:
        return ProductCard(product: data);
      case SearchType.services:
        return ServicesCard(service: data);
      case SearchType.stores:
        return VendorCard(store: data);
      case SearchType.users:
        return UserCard(user: data);
    }
  }
}
