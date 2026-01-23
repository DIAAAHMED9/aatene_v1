import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../../../general_index.dart';
import '../../../utlis/responsive/responsive_dimensions.dart';
import '../index.dart';

class AddImageStorySheet extends StatelessWidget {
  AddImageStorySheet({super.key});

  final AddImageStorySheetController controller =
      Get.put(AddImageStorySheetController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        padding: EdgeInsets.only(
          top: ResponsiveDimensions.h(10),
          left: ResponsiveDimensions.w(12),
          right: ResponsiveDimensions.w(12),
          bottom: ResponsiveDimensions.h(12) + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.bottomSheetBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ResponsiveDimensions.w(18)),
          ),
        ),
        child: Column(
          children: [
            _handle(),
            SizedBox(height: ResponsiveDimensions.h(8)),
            _titleRow(),
            SizedBox(height: ResponsiveDimensions.h(10)),
            _preview(),
            SizedBox(height: ResponsiveDimensions.h(10)),
            _grid(),
            SizedBox(height: ResponsiveDimensions.h(10)),
            _tabs(),
            SizedBox(height: ResponsiveDimensions.h(10)),
            _publishButton(),
          ],
        ),
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: ResponsiveDimensions.w(42),
      height: ResponsiveDimensions.h(5),
      decoration: BoxDecoration(
        color: AppColors.neutral900,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _titleRow() {
    return Center(
      child: Text(
        'صور',
        style: TextStyle(
          fontSize: ResponsiveDimensions.f(15),
          fontWeight: FontWeight.bold,
          color: AppColors.neutral200,
        ),
      ),
    );
  }

  Widget _preview() {
    final double h = ResponsiveDimensions.h(220);

    return Obx(() {
      final File? file = controller.selectedFile.value;

      return Container(
        height: h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.neutral1000,
          borderRadius: BorderRadius.circular(ResponsiveDimensions.w(14)),
          border: Border.all(color: AppColors.neutral900, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveDimensions.w(14)),
          child: file == null
              ? Center(
                  child: Text(
                    'اختر صورة لعرضها هنا',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral600,
                    ),
                  ),
                )
              : Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
        ),
      );
    });
  }

  Widget _grid() {
    return Expanded(
      child: Obx(() {
        final bool loading = controller.isLoading.value;
        final int tab = controller.currentTabIndex.value;
        final assets = tab == 2 ? controller.videoAssets : controller.studioAssets;

        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (assets.isEmpty) {
          return Center(
            child: Text(
              'لا يوجد ملفات',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(13),
                fontWeight: FontWeight.w600,
                color: AppColors.neutral600,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: ResponsiveDimensions.w(6),
            crossAxisSpacing: ResponsiveDimensions.w(6),
          ),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];

            return InkWell(
              onTap: () => controller.selectAsset(asset),
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(10)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                 FutureBuilder<Uint8List?>(
  future: asset.thumbnailDataWithSize(
    const ThumbnailSize(300, 300),
    quality: 90,
  ),
  builder: (context, snap) {
    final data = snap.data;

    if (data == null) {
      return Container(
        color: AppColors.neutral900,
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: AppColors.neutral600,
            size: ResponsiveDimensions.w(22),
          ),
        ),
      );
    }

    return Image.memory(
      data,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  },
),

                    if (tab == 2)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveDimensions.w(6)),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveDimensions.w(6),
                              vertical: ResponsiveDimensions.h(3),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius:
                                  BorderRadius.circular(ResponsiveDimensions.w(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: ResponsiveDimensions.w(16),
                                ),
                                SizedBox(width: ResponsiveDimensions.w(2)),
                                Text(
                                  _formatDuration(asset.videoDuration),
                                  style: TextStyle(
                                    fontSize: ResponsiveDimensions.f(10),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _tabs() {
    return Obx(() {
      return StoryMediaTabBar(
        index: controller.currentTabIndex.value,
        onChange: (i) async {
          controller.tabController.animateTo(i);
        },
      );
    });
  }

  Widget _publishButton() {
    return Obx(() {
      final bool enabled = controller.selectedFile.value != null;

      return SizedBox(
        width: double.infinity,
        height: ResponsiveDimensions.h(48),
        child: ElevatedButton(
          onPressed: enabled ? controller.onPublish : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? AppColors.primary400 : AppColors.neutral900,
            disabledBackgroundColor: AppColors.neutral900,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
            ),
          ),
          child: Text(
            'نشر',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              fontWeight: FontWeight.bold,
              color: enabled ? AppColors.neutral1000 : AppColors.neutral600,
            ),
          ),
        ),
      );
    });
  }

  String _formatDuration(Duration d) {
    final int m = d.inMinutes;
    final int s = d.inSeconds % 60;
    final String mm = m.toString().padLeft(2, '0');
    final String ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
