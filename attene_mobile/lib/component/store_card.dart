import '../general_index.dart';
import '../view/home/model/home_api_models.dart';
import '../view/profile/vendor_profile/screen/store_profile.dart';

class VendorCard extends StatelessWidget {
  final HomeStoreItem? item;

  const VendorCard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final name = (item?.name.isNotEmpty ?? false) ? item!.name : 'متجر';
    final image = item?.coverUrl ?? 'assets/images/png/ser1.png';
    final isAsset = image.trim().startsWith('assets/');

    return GestureDetector(
      onTap: () {
        Get.to(StoreProfilePage());
      },
      child: Container(
        width: 162,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral900, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: isAsset
                      ? Image.asset(
                          image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 100,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBold(fontSize: 13),
                    ),
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