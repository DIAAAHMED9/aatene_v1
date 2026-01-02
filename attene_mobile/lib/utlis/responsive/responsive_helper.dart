

import '../../general_index.dart';
import 'index.dart';


class VariationResponsive {
  static bool get isMobile => Get.width < 600;

  static bool get isTablet => Get.width >= 600 && Get.width < 1200;

  static bool get isDesktop => Get.width >= 1200;

  static bool get isLandscape => Get.context != null
      ? MediaQuery.of(Get.context!).orientation == Orientation.landscape
      : false;

  static double get cardPadding {
    if (isMobile) return ResponsiveDimensions.w(12);
    if (isTablet) return ResponsiveDimensions.w(16);
    return ResponsiveDimensions.w(24);
  }

  static int get gridCrossAxisCount {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  static double get bottomSheetHeight {
    if (isLandscape) return Get.height * 0.75;
    if (isTablet) return Get.height * 0.7;
    return Get.height * 0.6;
  }

  static double get unifiedBottomSheetHeight {
    if (isLandscape) return Get.height * 0.85;
    if (isTablet) return Get.height * 0.8;
    return Get.height * 0.75;
  }

  static double get imageThumbnailSize {
    if (isMobile) return ResponsiveDimensions.w(70);
    if (isTablet) return ResponsiveDimensions.w(90);
    return ResponsiveDimensions.w(110);
  }
}