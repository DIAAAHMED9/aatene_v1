class Store {
  final String id;
  final String name;
  final String type;
  final String? status;
  final String? logoUrl;
  final List<String>? coverUrls;
  final String address;
  final String? email;
  final String? phone;
  final String? currency;
  final String? ownerName;

  Store({
    required this.id,
    required this.name,
    required this.type,
    this.status,
    this.logoUrl,
    this.coverUrls,
    required this.address,
    this.email,
    this.phone,
    this.currency,
    this.ownerName,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    String? logoUrl;
    if (json['logo_url'] != null && json['logo_url'].toString().isNotEmpty) {
      final url = json['logo_url'].toString();
      logoUrl = url.startsWith('http')
          ? url
          : 'https://aatene.dev/storage/$url';
    }

    List<String>? coverUrls;
    if (json['cover_urls'] != null) {
      coverUrls = (json['cover_urls'] as List)
          .where((item) => item != null && item.toString().isNotEmpty)
          .map((item) {
            final url = item.toString();
            return url.startsWith('http')
                ? url
                : 'https://aatene.dev/storage/$url';
          })
          .toList();
    }

    String address = 'غير محدد';
    if (json['address'] != null && json['address'].toString().isNotEmpty) {
      address = json['address'].toString();
    } else if (json['city'] != null) {
      final city = json['city'] is Map
          ? json['city']['name']
          : json['city'].toString();
      address = 'مدينة $city';
    }

    String type = 'متجر منتجات';
    if (json['type'] != null) {
      if (json['type'] == 'services') {
        type = 'متجر خدمات';
      } else if (json['type'] == 'products') {
        type = 'متجر منتجات';
      }
    }

    return Store(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'بدون اسم',
      type: type,
      status: json['status']?.toString(),
      logoUrl: logoUrl,
      coverUrls: coverUrls,
      address: address,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      currency: json['currency'] != null
          ? json['currency']['name']?.toString()
          : json['currency_id']?.toString(),
      ownerName: json['owner'] != null
          ? '${json['owner']['first_name'] ?? ''} ${json['owner']['last_name'] ?? ''}'
          : json['owner_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status,
    'logo_url': logoUrl,
    'cover_urls': coverUrls,
    'address': address,
    'email': email,
    'phone': phone,
    'currency': currency,
    'owner_name': ownerName,
  };
}