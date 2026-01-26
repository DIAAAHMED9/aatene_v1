import 'package:cached_network_image/cached_network_image.dart';

import '../../../general_index.dart';

class ManageAccountStoreHeader extends StatelessWidget {
  const ManageAccountStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [Text('إدارة الحسابات', style: getRegular(fontSize: 20))],
      ),
    );
  }
}

class ManageAccountStoreBody extends StatelessWidget {
  final ManageAccountStoreController controller;
  final MyAppController myAppController;

  const ManageAccountStoreBody({
    super.key,
    required this.controller,
    required this.myAppController,
  });

  @override
  Widget build(BuildContext context) {
    if (!myAppController.isLoggedIn.value) {
      return const _LoginRequiredView();
    }

    if (controller.isLoading.value) {
      return const _LoadingView();
    }

    if (controller.errorMessage.isNotEmpty) {
      return _ErrorView(controller: controller);
    }

    if (controller.stores.isEmpty) {
      return _EmptyAccountsView(controller: controller);
    }

    return _AccountsListView(controller: controller);
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل المتاجر...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _ErrorView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('حدث خطأ', style: getBold(fontSize: 18, color: Colors.red)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: getRegular(color: Colors.grey),
                  ),
        ),
              
              const SizedBox(height: 16),
              AateneButton(
                buttonText: 'إعادة المحاولة',
                textColor: Colors.white,
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                raduis: 10,
                onTap: controller.loadStores,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAccountsView extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _EmptyAccountsView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/png/empty_store.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 24),
              Text(
                'لا يوجد لديك أي متاجر',
                style: getBold(fontSize: 22, color: AppColors.neutral400),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 280,
                child: Text(
                  'يمكنك البدء بإضافة متاجر جديدة لإدارتها بشكل منفصل',
                  style: getRegular(fontSize: 14, color: AppColors.neutral700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              AateneButton(
                buttonText: 'إضافة متجر جديد',
                textColor: Colors.white,
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                raduis: 30,
                onTap: controller.addNewStore,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountsListView extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _AccountsListView({required this.controller});

  List<Store> _filteredStores() {
    return controller.stores.where((store) {
      if (controller.searchQuery.value.isNotEmpty) {
        final query = controller.searchQuery.value.toLowerCase();
        return store.name.toLowerCase().contains(query) ||
            store.address.toLowerCase().contains(query) ||
            (store.email?.toLowerCase() ?? '').contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = _filteredStores();

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _SearchBar(controller: controller),
              _InfoBanner(controller: controller),
              ListView.builder(
                itemCount: filteredStores.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final store = filteredStores[index];
                  return _StoreCard(
                    store: store,
                    onEdit: () => controller.editStore(store),
                    onDelete: () => controller.deleteStore(store),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ✅ زر إضافة متجر جديد
              _AddNewStoreButton(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddNewStoreButton extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _AddNewStoreButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.add),
          onPressed: controller.addNewStore,
          label: const Text('إضافة متجر جديد'),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.colorManageAccountStore,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          color: Colors.transparent,
          child: TextField(
          controller: controller.searchController,
          onChanged: controller.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'ابحث عن متجر...',
            hintStyle: getRegular(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    ));
  }
}

class _InfoBanner extends StatelessWidget {
  final ManageAccountStoreController controller;

  const _InfoBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color(0XFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "الحساب/المتجر",
            style: getBold(fontSize: 14, color: AppColors.primary400),
          ),
          Spacer(),
          Text(
            "الاجراءات",
            style: getMedium(fontSize: 14, color: AppColors.primary400),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StoreCard({
    required this.store,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(10),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary400,
            backgroundImage:
                (store.logoUrl != null && store.logoUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(store.logoUrl!)
                : null,
            child: (store.logoUrl == null || store.logoUrl!.isEmpty)
                ? const Icon(Icons.store, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.name, style: getBold(fontSize: 15)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.addresContainer,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ⭐ المفتاح
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.addresBackground,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.backgroundColor,
                          size: 13,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        store.address,
                        style: getRegular(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: EdgeInsets.all(7),

              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/images/svg_images/edit_1.svg',
                semanticsLabel: 'My SVG Image',
                height: 16,
                width: 16,
              ),
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () => Get.dialog(
              StoreDeleteDialog(store: store, onConfirm: onDelete),
            ),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.error100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/images/svg_images/delete_2.svg',
                semanticsLabel: 'My SVG Image',
                height: 16,
                width: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginRequiredView extends StatelessWidget {
  const _LoginRequiredView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'يجب تسجيل الدخول',
              style: getBold(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تسجيل الدخول للوصول إلى إدارة المتاجر',
              style: getRegular(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: 'تسجيل الدخول',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () => Get.toNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
