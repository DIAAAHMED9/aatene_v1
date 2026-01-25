class StoryVendorDemoModel {
  final String storeId;
  final String storeName;
  final String avatarUrl;
  final List<StoryVendorGroupModel> groups;

  StoryVendorDemoModel({
    required this.storeId,
    required this.storeName,
    required this.avatarUrl,
    required this.groups,
  });
}

class StoryVendorGroupModel {
  final String title;
  final List<StoryMediaItem> items;

  StoryVendorGroupModel({
    required this.title,
    required this.items,
  });

  /// Backward-compatible getter for old code.
  List<String> get mediaUrls => items.map((e) => e.url).toList(growable: false);

  /// Convenience for creating a group from simple URLs.
  factory StoryVendorGroupModel.fromUrls({
    required String title,
    required List<String> mediaUrls,
  }) {
    return StoryVendorGroupModel(
      title: title,
      items: mediaUrls.map((u) => StoryMediaItem(url: u)).toList(),
    );
  }
}

/// A single story media item (image/video) with optional overlay data.
class StoryMediaItem {
  final String url;
  final int? id;
  final String? text;
  final int? color;
  final String? createdAt;

  const StoryMediaItem({
    required this.url,
    this.id,
    this.text,
    this.color,
    this.createdAt,
  });
}

class DemoProduct {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final double? oldPrice;

  DemoProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
  });
}

final demoVendors = <StoryVendorDemoModel>[
  StoryVendorDemoModel(
    storeId: '66',
    storeName: 'متخر خدمات',
    avatarUrl: 'https://aatene.dev/main/user.png',
    groups: [
      StoryVendorGroupModel.fromUrls(title: 'عروض', mediaUrls: [
        'https://aatene.dev/storage/images/WxfRb83JUft2Xatgfo4X12eDmAfns9CvE7luImR7.jpg',
        'https://aatene.dev/storage/images/9L8axgSXbPlZDrXxjbiiWvOtGQR4ctunaNbCxWWx.jpg',
        'https://aatene.dev/storage/images/22LPvwM8BPzC5CfE6Xv5519baHR6UbeA2u7n82Dt.jpg',
      ]),
    ],
  ),
  StoryVendorDemoModel(
    storeId: '55',
    storeName: 'متجر أعطيني 2',
    avatarUrl: 'https://aatene.dev/main/user.png',
    groups: [
      StoryVendorGroupModel.fromUrls(title: 'قصص', mediaUrls: [
        'https://aatene.dev/storage/images/4PBSWhmXUugRbt3ZlDt2182WXW8ZQiZX6TTzGwDC.jpg',
        'https://aatene.dev/storage/images/WxfRb83JUft2Xatgfo4X12eDmAfns9CvE7luImR7.jpg',
      ]),
    ],
  ),
];

final demoProducts = <DemoProduct>[
  DemoProduct(
    id: '1',
    title: 'T-Shirt Sailing',
    imageUrl: 'https://aatene.dev/main/user.png',
    price: 10.0,
    oldPrice: 21.0,
  ),
  DemoProduct(
    id: '2',
    title: 'T-Shirt Sailing',
    imageUrl: 'https://aatene.dev/main/user.png',
    price: 14.0,
    oldPrice: 21.0,
  ),
  DemoProduct(
    id: '3',
    title: 'T-Shirt Sailing',
    imageUrl: 'https://aatene.dev/main/user.png',
    price: 10.0,
  ),
  DemoProduct(
    id: '4',
    title: 'T-Shirt Sailing',
    imageUrl: 'https://aatene.dev/main/user.png',
    price: 14.0,
    oldPrice: 21.0,
  ),
];
