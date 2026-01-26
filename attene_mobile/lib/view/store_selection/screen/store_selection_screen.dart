import '../../../general_index.dart';
import '../controller/store_selection_controller.dart';

class StoreSelectionScreen extends StatelessWidget {
  const StoreSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StoreSelectionController>();

    final width = MediaQuery.of(context).size.width;
    final maxW = width >= 900 ? 720.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة مؤقتة لتبديل المتاجر'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // لأن المتجر إلزامي لتجربة المرحلة الأولى: نرجع لصفحة تسجيل الدخول
            Get.offAllNamed('/login');
          },
        ),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => c.loadStores(force: true),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(),
                const SizedBox(height: 12),
                _SearchBar(
                  onChanged: (v) => c.searchQuery.value = v,
                  onClear: () => c.searchQuery.value = '',
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    if (c.isLoading.value && c.stores.isEmpty) {
                      return const _LoadingList();
                    }

                    final list = c.filteredStores;
                    if (list.isEmpty) {
                      return _EmptyState(
                        onRefresh: () => c.loadStores(force: true),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => c.loadStores(force: true),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final store = list[i];
                          return Obx(() {
                            final selectedId = c.selectedStore.value?['id']
                                ?.toString();
                            final id = store['id']?.toString();
                            final isSelected =
                                selectedId != null && selectedId == id;

                            return _StoreCard(
                              store: store,
                              isSelected: isSelected,
                              onTap: () => c.selectStore(store),
                            );
                          });
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final enabled = c.selectedStore.value != null;
                  return SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AateneButton(
                        onTap: enabled ? () => c.confirmSelection() : null,
                        buttonText: "متابعة",
                        color: AppColors.primary400,
                        borderColor: AppColors.primary400,
                        textColor: AppColors.light1000,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.06),
            ),
            child: const Icon(Icons.storefront_rounded),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر المتجر الذي تريد العمل عليه',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'سيتم استخدام رقم المتجر تلقائياً في جميع الطلبات.',
                  style: TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({required this.onChanged, required this.onClear});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'ابحث عن متجر...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  widget.onClear();
                  setState(() {});
                },
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final dynamic store;
  final bool isSelected;
  final VoidCallback onTap;

  const _StoreCard({
    required this.store,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = (store['name'] ?? store['title'] ?? 'متجر').toString();
    final address = (store['address'] ?? store['location'] ?? '').toString();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.black12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.06),
              ),
              child: const Icon(Icons.store_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_off_rounded,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          color: Colors.black.withOpacity(0.03),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.store_mall_directory_outlined,
          size: 56,
          color: Colors.black45,
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'لا توجد متاجر متاحة',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'اسحب للأسفل للتحديث أو تحقق من الاتصال.',
            style: TextStyle(fontSize: 12.5, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => onRefresh(),
              child: const Text('تحديث'),
            ),
          ),
        ),
      ],
    );
  }
}
