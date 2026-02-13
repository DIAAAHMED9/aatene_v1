import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../general_index.dart';
import '../controller/favorite_controller.dart';
import 'add_group_bottom_sheet.dart';
import 'favorite_list_screen.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'المجموعات المضافة',
                  style: getBold(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              Obx(() {
                if (controller.favoriteLists.isEmpty) {
                  return _buildEmptyState();
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: controller.favoriteLists.length+1,
                  itemBuilder: (context, index) {
                        if (index == 0) {
      return AddNewCollectionCard();
                        }
                    final list = controller.favoriteLists[index-1];
                    return CollectionPreviewCard(onTap: () => Get.to(() => FavoriteListScreen(listId:list['id'].toString())));
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.folder_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'لا توجد مجموعات بعد',
            style: getMedium(fontSize: 14, color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, Map<String, dynamic> list) {
    final List<String> previewImages =
        (list['preview_images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    return GestureDetector(
      onTap: () {
        Get.to(() => FavoriteListScreen(listId: list['id'].toString()));
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DetailsGroupBottomSheet(group: list),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFC5D3E8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 100,
                  color: Colors.white.withOpacity(0.2),
                  child: previewImages.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.folder,
                            size: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: previewImages.take(4).map((url) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                list['name'] ?? 'بدون اسم',
                style: getBold(fontSize: 14, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    list['is_private'] == 1 ? Icons.lock : Icons.public,
                    size: 12,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${int.tryParse(list['favs_count']?.toString() ?? '0') ?? 0} عناصر',
                      style: getMedium(fontSize: 11, color: Colors.grey[800]!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CollectionPreviewCard extends StatelessWidget {
  final VoidCallback? onTap;
  const CollectionPreviewCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
    return Obx(() {
      final previewLists = controller.favoriteLists.take(4).toList();
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFC5D3E8),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: previewLists.isEmpty
                  ? List.generate(4, (_) => _buildPlaceholder())
                  : previewLists
                      .expand((list) {
                        final images = list['preview_images'] as List<dynamic>? ?? [];
                        return images.take(2).map((url) => url.toString());
                      })
                      .take(4)
                      .map((url) => _buildImageItem(url))
                      .toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildImageItem(String url) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      );

  Widget _buildPlaceholder() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.5),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(child: Icon(Icons.folder, color: Colors.white, size: 30)),
      );
}

class AddNewCollectionCard extends StatefulWidget {
  const AddNewCollectionCard({super.key});
  @override
  State<AddNewCollectionCard> createState() => _AddNewCollectionCardState();
}

class _AddNewCollectionCardState extends State<AddNewCollectionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddGroupBottomSheet(),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 15, color: AppColors.primary400),
              Text(
                'إضافة مجموعة جديدة',
                style: getBold(fontSize: 14, color: AppColors.primary400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum GroupType {
  product,
  service,
  blog,
  store,
}

extension GroupTypeExtension on GroupType {
  String get displayName {
    switch (this) {
      case GroupType.product:
        return 'منتجات';
      case GroupType.service:
        return 'خدمات';
      case GroupType.blog:
        return 'بلوقز';
      case GroupType.store:
        return 'متاجر';
    }
  }

  String get apiValue {
    switch (this) {
      case GroupType.product:
        return 'product';
      case GroupType.service:
        return 'service';
      case GroupType.blog:
        return 'blog';
      case GroupType.store:
        return 'store';
    }
  }
}

class AddGroupBottomSheet extends StatefulWidget {
  const AddGroupBottomSheet({super.key});

  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPrivate = false;
  GroupType _selectedType = GroupType.product;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
    final isRTL = LanguageUtils.isRTL;

    return Container(
      height: 680,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Text('إضافة مجموعة جديدة', style: getBold(fontSize: 20)),
              ),
              Text('اسم المجموعة', style: getBold(fontSize: 18)),
              TextFiledAatene(
                isRTL: isRTL,
                controller: _nameController,
                hintText: 'عنوان المجموعة',
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم المجموعة';
                  }
                  return null;
                },
              ),
              Text('الخصوصية', style: getBold(fontSize: 18)),
              _buildPrivacyOption(
                title: 'عامة',
                subtitle: 'أي شخص يمكنه رؤية هذه المجموعة',
                icon: Icons.public,
                isSelected: !_isPrivate,
                onTap: () => setState(() => _isPrivate = false),
              ),
              _buildPrivacyOption(
                title: 'خاصة',
                subtitle: 'أنت فقط من يمكنه رؤية هذه المجموعة',
                icon: Icons.lock_outline,
                isSelected: _isPrivate,
                onTap: () => setState(() => _isPrivate = true),
              ),
              Text('نوع المجموعة', style: getBold(fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: GroupType.values.map((type) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == type
                                ? AppColors.primary400
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedType == type
                                  ? AppColors.primary400
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            type.displayName,
                            textAlign: TextAlign.center,
                            style: getMedium(
                              fontSize: 14,
                              color: _selectedType == type
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              AateneButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.createFavoriteList(
                      name: _nameController.text.trim(),
                      isPrivate: _isPrivate,
                      type: _selectedType.apiValue,
                    );
                    Navigator.pop(context);
                    Get.snackbar(
                      'تم',
                      'تم إنشاء المجموعة بنجاح',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary400,
                      colorText: Colors.white,
                    );
                  }
                },
                buttonText: "التالي",
                textColor: AppColors.light1000,
                borderColor: AppColors.primary400,
                color: AppColors.primary400,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary400 : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? AppColors.primary400 : Colors.black,
                      ),
                      Text(
                        title,
                        style: getBold(
                          color: isSelected ? AppColors.primary400 : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: getMedium(fontSize: 14, color: AppColors.neutral600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RenameGroupBottomSheet extends StatelessWidget {
  final String listId;
  final String currentName;

  const RenameGroupBottomSheet({
    super.key,
    required this.listId,
    required this.currentName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();
    final TextEditingController nameController =
        TextEditingController(text: currentName);
    final isRTL = LanguageUtils.isRTL;

    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 20),
          Text("إعادة تسمية المجموعة", style: getBold(fontSize: 20)),
          TextFiledAatene(
            isRTL: isRTL,
            controller: nameController,
            hintText: "اسم المجموعة الجديد",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.name,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: AateneButton(
                  onTap: () {
                    final newName = nameController.text.trim();
                    if (newName.isNotEmpty) {
                      controller.updateFavoriteList(
                        listId: listId,
                        name: newName,
                      );
                      Navigator.pop(context);
                    }
                  },
                  buttonText: "تم",
                  textColor: AppColors.light1000,
                  borderColor: AppColors.primary400,
                  color: AppColors.primary400,
                ),
              ),
              Expanded(
                child: AateneButton(
                  onTap: () => Navigator.pop(context),
                  buttonText: "إلغاء",
                  textColor: AppColors.primary400,
                  borderColor: AppColors.primary400,
                  color: AppColors.light1000,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeleteGroupBottomSheet extends StatelessWidget {
  final String listId;

  const DeleteGroupBottomSheet({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 180,
        child: Center(
          child: Column(
            spacing: 10,
            children: [
              Text("حذف المجموعة", style: getBold(fontSize: 20)),
              Text(
                "هل أنت متأكد من حذف المجموعة؟ سيؤدي ذلك لحذف جميع العناصر الموجودة بداخلها",
                textAlign: TextAlign.center,
                style: getMedium(fontSize: 14),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: AateneButton(
                      onTap: () {
                        controller.deleteFavoriteList(listId);
                        Navigator.pop(context);
                      },
                      buttonText: "حذف",
                      textColor: AppColors.light1000,
                      borderColor: AppColors.error200,
                      color: AppColors.error200,
                    ),
                  ),
                  Expanded(
                    child: AateneButton(
                      onTap: () => Navigator.pop(context),
                      buttonText: "إلغاء",
                      textColor: AppColors.primary400,
                      borderColor: AppColors.primary400,
                      color: AppColors.light1000,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsGroupBottomSheet extends StatelessWidget {
  final Map<String, dynamic> group;

  const DetailsGroupBottomSheet({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final listId = group['id'].toString();
    final isPrivate = group['is_private'] == 1;

    return Container(
      height: 550,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSmallThumbnail(
                'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=100',
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group['name'] ?? 'بدون اسم',
                    style: getBold(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(
                    isPrivate ? 'خاصة' : 'عامة',
                    isPrivate ? Icons.lock : Icons.public,
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'rename') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => RenameGroupBottomSheet(
                        listId: listId,
                        currentName: group['name'] ?? '',
                      ),
                    );
                  } else if (value == 'delete') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => DeleteGroupBottomSheet(listId: listId),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('إعادة تسمية'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('حذف', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          AateneButton(
            onTap: () => Navigator.pop(context),
            buttonText: "تم",
            color: AppColors.primary400,
            borderColor: AppColors.primary400,
            textColor: AppColors.light1000,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary400),
          Text(
            text,
            style: getMedium(fontSize: 12, color: AppColors.primary400),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallThumbnail(String url) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('المجموعات', style: getBold(fontSize: 20)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddGroupBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.favoriteLists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لا توجد مجموعات بعد'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddGroupBottomSheet(),
                    );
                  },
                  child: const Text('إنشاء مجموعة جديدة'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: controller.favoriteLists.length,
            itemBuilder: (context, index) {
              final list = controller.favoriteLists[index];
              return _buildGroupCard(context, list);
            },
          ),
        );
      }),
    );
  }

  Widget _buildGroupCard(BuildContext context, Map<String, dynamic> list) {
    final List<String> previewImages =
        (list['preview_images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    return GestureDetector(
      onTap: () {
        Get.to(() => FavoriteListScreen(listId: list['id'].toString()));
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DetailsGroupBottomSheet(group: list),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFC5D3E8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 100,
                  color: Colors.white.withOpacity(0.2),
                  child: previewImages.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.folder,
                            size: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: previewImages.take(4).map((url) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                list['name'] ?? 'بدون اسم',
                style: getBold(fontSize: 14, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    list['is_private'] == 1 ? Icons.lock : Icons.public,
                    size: 12,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${int.tryParse(list['favs_count']?.toString() ?? '0') ?? 0} عناصر',
                      style: getMedium(fontSize: 11, color: Colors.grey[800]!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class FavoriteListScreen extends StatefulWidget {
  final String listId;

  const FavoriteListScreen({super.key, required this.listId});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<FavoriteController>();
      controller.fetchFavoritesInList(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final list = controller.favoriteLists.firstWhere(
            (item) => item['id'].toString() == widget.listId,
            orElse: () => {},
          );
          return Text(list['name'] ?? 'المجموعة');
        }),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              final list = controller.favoriteLists.firstWhere(
                (item) => item['id'].toString() == widget.listId,
                orElse: () => {},
              );
              if (list.isNotEmpty) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DetailsGroupBottomSheet(group: list),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedList = controller.selectedList;
        final listId = selectedList['id']?.toString();

        if (listId != widget.listId) {
          return const Center(child: Text('جاري تحميل المجموعة...'));
        }

        final groupType = selectedList['type']?.toString() ?? 'product';
        final List<dynamic> items = selectedList['items'] ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'لا توجد عناصر في هذه المجموعة',
                  style: getMedium(fontSize: 16, color: AppColors.neutral500),
                ),
                const SizedBox(height: 8),
                Text(
                  'أضف عناصر إلى المجموعة بالضغط على زر المفضلة',
                  style: getMedium(fontSize: 14, color: AppColors.neutral400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
            print('عرض عنصر في المجموعة: $item');
              switch (groupType) {
                case 'product':
                  return ProductCard(
                    product: item,
                    showFavoriteButton: false,
                    isFavorite: true,
                  );
                case 'service':
                  return ServicesCard(
                    service: item,
                    showFavoriteButton: false,
                    isFavorite: true,
                  );
                case 'blog':
                  return BlogCard(
                    blog: item,
                    showFavoriteButton: false,
                    isFavorite: true,
                  );
                case 'store':
                  return VendorCard(
                    store: item,
                    showFavoriteButton: false,
                    initialFollowed: true,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        );
      }),
    );
  }
}

class BlogCard extends StatelessWidget {
  final Map<String, dynamic> blog;
  final bool showFavoriteButton;
  final bool isFavorite;

  const BlogCard({
    super.key,
    required this.blog,
    this.showFavoriteButton = true,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              blog['cover'] ?? 'https://via.placeholder.com/150',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              blog['title'] ?? blog['name'] ?? 'مقال',
              style: getBold(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}