import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';

class MediaSelector extends StatelessWidget {
  final Function(List<String>) onMediaSelected;

  const MediaSelector({super.key, required this.onMediaSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMediaLibrary,
      child: Container(
        width: ResponsiveDimensions.w(80),
        height: ResponsiveDimensions.h(80),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.grey[400],
              size: ResponsiveDimensions.w(24),
            ),
            SizedBox(height: ResponsiveDimensions.h(4)),
            Text(
              'إضافة صورة',
              style: getRegular(
                color: Colors.grey,
                fontSize: ResponsiveDimensions.f(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMediaLibrary() async {
    final List<MediaItem>? selectedMedia = await Get.to(
      () => MediaLibraryScreen(isSelectionMode: true),
    );

    if (selectedMedia != null && selectedMedia.isNotEmpty) {
      final imageUrls = selectedMedia.map((media) => media.path).toList();
      onMediaSelected(imageUrls);
    }
  }
}