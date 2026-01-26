import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/favorite/widget/all_page.dart';
import 'package:attene_mobile/view/favorite/widget/group_name.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          spacing: 15,
          children: [
            // كارت إضافة مجموعة جديدة
            const Expanded(child: AddNewCollectionCard()),
            // كارت عرض الصور (المجموعة)
            Expanded(
              child: CollectionPreviewCard(onTap: () => Get.to(GroupName())),
            ),
          ],
        ),
      ),
    );
  }
}

/// كارت عرض الصور بتصميم شبكي (Grid)
class CollectionPreviewCard extends StatelessWidget {
  const CollectionPreviewCard({super.key, this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFC5D3E8),
          // لون الخلفية الزرقاء الباهتة خلف الصور
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
            children: [
              _buildImageItem(
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
              ),
              _buildImageItem(
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
              ),
              _buildImageItem(
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=200',
              ),
              _buildImageItem(
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
              ),
              _buildImageItem(
                'https://images.unsplash.com/photo-1526170315830-ef18a25d188a?w=200',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

/// كارت "إضافة مجموعة جديدة"
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
        showBottomSheet(
          context: context,
          builder: (context) => AddGroupButtonSheet(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 15,
                color: AppColors.primary400,
              ),
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

/// ButtonSheetPage
class AddGroupButtonSheet extends StatefulWidget {
  const AddGroupButtonSheet({super.key});

  @override
  State<AddGroupButtonSheet> createState() => _AddGroupButtonSheetState();
}

class _AddGroupButtonSheetState extends State<AddGroupButtonSheet> {
  @override
  Widget build(BuildContext context) {
    bool isPublicSelected = true;
    final isRTL = LanguageUtils.isRTL;
    return SizedBox(
      height: 550,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مقبض السحب (Drag Handle) في الأعلى
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

            // العنوان الرئيسي
            Center(
              child: Text('إضافة مجموعة جديدة', style: getBold(fontSize: 20)),
            ),

            // حقل اسم المجموعة
            Text('اسم المجموعة', style: getBold(fontSize: 18)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: 'عنوان المجموعة',
              textInputAction: TextInputAction.done, textInputType: TextInputType.name,
            ),

            // قسم الخصوصية
            Text('الخصوصية', style: getBold(fontSize: 18)),

            // خيار "عامة"
            _buildPrivacyOption(
              title: 'عامة',
              subtitle: 'أي شخص يمكنه رؤية هذه المجموعة',
              icon: Icons.public,
              isSelected: isPublicSelected,
              onTap: () => setState(() => isPublicSelected = true),
            ),

            // خيار "خاصة"
            _buildPrivacyOption(
              title: 'خاصة',
              subtitle: 'أنت فقط من يمكنه رؤية هذه المجموعة',
              icon: Icons.lock_outline,
              isSelected: !isPublicSelected,
              onTap: () => setState(() => isPublicSelected = false),
            ),

            // زر "التالي"
            AateneButton(
              buttonText: "التالي",
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
              color: AppColors.primary400,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ودجت مخصص لبناء خيارات الخصوصية (عامة/خاصة)
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? AppColors.primary400 : Colors.black,
                      ),

                      Text(
                        title,
                        style: getBold(
                          color: isSelected
                              ? AppColors.primary400
                              : Colors.black,
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

class DeleteGroupButtonSheet extends StatelessWidget {
  const DeleteGroupButtonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 180,
        child: Center(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("حذف المجموعة", style: getBold(fontSize: 20)),
              Text(
                "هل انت متاكد من حذف المجموعة، سيؤدي ذلك لحذف جميع العناصر الموجودة بداخلها",
                textAlign: TextAlign.center,
                style: getMedium(fontSize: 14),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AateneButton(
                      buttonText: "تم",
                      textColor: AppColors.light1000,
                      borderColor: AppColors.primary400,
                      color: AppColors.primary400,
                    ),
                  ),
                  Expanded(
                    child: AateneButton(
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

class RenameGroupButtonSheet extends StatelessWidget {
  const RenameGroupButtonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("إعادة تسمية المجموعة", style: getBold(fontSize: 20)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "اسم المجموعة الجديد",
                textInputAction: TextInputAction.done, textInputType: TextInputType.name,
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AateneButton(
                      buttonText: "تم",
                      textColor: AppColors.light1000,
                      borderColor: AppColors.primary400,
                      color: AppColors.primary400,
                    ),
                  ),
                  Expanded(
                    child: AateneButton(
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

class DetailsGroupButtonSheet extends StatelessWidget {
  const DetailsGroupButtonSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          // مقبض السحب العلوي

          // القسم العلوي: الصورة والعنوان وزر القلب
          Row(
            spacing: 5,
            children: [
              _buildSmallThumbnail(
                'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=100',
              ),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'محفوظة في المفضلة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge('عامة', Icons.public),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 24),
              ),
            ],
          ),
          const Divider(),

          // قسم "المجموعات" وزر الإضافة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموعات', style: getBold(fontSize: 18)),
              _buildAddButton(() {
                showBottomSheet(
                  context: context,
                  builder: (context) => AddGroupButtonSheet(),
                );
              }),
            ],
          ),
          // قائمة المجموعات
          _buildCollectionItem(
            'كل المفضلة',
            'عامة',
            Icons.public,
            true,
            'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=100',
          ),
          _buildCollectionItem(
            'هدايا',
            'خاصة',
            Icons.lock,
            true,
            'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=100',
          ),
          _buildCollectionItem(
            'منتجات بشرة',
            'خاصة',
            Icons.lock,
            true,
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=100',
          ),

          // Button
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

  // ودجت لبناء عنصر المجموعة
  Widget _buildCollectionItem(
    String title,
    String status,
    IconData icon,
    bool isSelected,
    String imageUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        children: [
          _buildSmallThumbnail(imageUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getMedium()),
              const SizedBox(height: 4),
              _buildStatusBadge(status, icon),
            ],
          ),
          const Spacer(),

          Checkbox(
            value: isSelected,
            onChanged: (val) {},
            activeColor: AppColors.primary400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت لشارة الحالة (عامة/خاصة)
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

  // ودجت للصورة المصغرة المنحنية
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

  // ودجت زر "إنشاء مجموعة جديدة"
  Widget _buildAddButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.add_box, size: 20, color: AppColors.primary400),
            SizedBox(width: 5),
            Text(
              'إنشاء مجموعة جديدة',
              style: getMedium(fontSize: 14, color: AppColors.primary400),
            ),
          ],
        ),
      ),
    );
  }
}
