import 'package:flutter/foundation.dart';

@immutable
class HomeBanner {
  final String imageUrl;

  const HomeBanner({required this.imageUrl});

  static List<HomeBanner> fromAny(dynamic raw) {
    final out = <HomeBanner>[];
    if (raw is List) {
      for (final it in raw) {
        final url = _pickUrl(it);
        if (url != null) out.add(HomeBanner(imageUrl: url));
      }
    }
    return out;
  }

  static String? _pickUrl(dynamic it) {
    if (it is String) return it.trim().isEmpty ? null : it.trim();
    if (it is Map) {
      for (final k in const [
        'image_url',
        'image',
        'cover_url',
        'cover',
        'url',
        'path',
      ]) {
        final v = it[k];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
    }
    return null;
  }
}

@immutable
class HomeStoreItem {
  final int id;
  final String name;
  final String? slug;
  final String? coverUrl;
  final double? rating;

  const HomeStoreItem({
    required this.id,
    required this.name,
    this.slug,
    this.coverUrl,
    this.rating,
  });

  static List<HomeStoreItem> fromAny(dynamic raw) {
    final out = <HomeStoreItem>[];
    if (raw is List) {
      for (final it in raw) {
        if (it is Map) {
          final id = _asInt(it['id']);
          final name = (it['name'] ?? it['title'] ?? it['slug'] ?? '')
              .toString();
          if (id == null || name.trim().isEmpty) continue;
          out.add(
            HomeStoreItem(
              id: id,
              name: name,
              slug: (it['slug'] ?? '').toString().trim().isEmpty
                  ? null
                  : it['slug'].toString(),
              coverUrl: _pickUrl(it),
              rating: _asDouble(it['rating'] ?? it['rate'] ?? it['avg_rating']),
            ),
          );
        }
      }
    }
    return out;
  }

  static String? _pickUrl(Map it) {
    for (final k in const [
      'cover_url',
      'image_url',
      'avatar_url',
      'logo_url',
      'cover',
      'image',
      'avatar',
      'logo',
    ]) {
      final v = it[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}

@immutable
class HomeProductItem {
  final int id;
  final String name;
  final String? slug;
  final double? price;
  final String? imageUrl;

  const HomeProductItem({
    required this.id,
    required this.name,
    this.slug,
    this.price,
    this.imageUrl,
  });

  static List<HomeProductItem> fromAny(dynamic raw) {
    final out = <HomeProductItem>[];
    if (raw is List) {
      for (final it in raw) {
        if (it is Map) {
          final id = _asInt(it['id']);
          final name = (it['name'] ?? it['title'] ?? it['slug'] ?? '')
              .toString();
          if (id == null || name.trim().isEmpty) continue;

          final img = _pickImage(it);
          out.add(
            HomeProductItem(
              id: id,
              name: name,
              slug: (it['slug'] ?? '').toString().trim().isEmpty
                  ? null
                  : it['slug'].toString(),
              price: _asDouble(it['price']),
              imageUrl: img,
            ),
          );
        }
      }
    }
    return out;
  }

  static String? _pickImage(Map it) {
    final imagesUrl = it['images_url'];
    if (imagesUrl is List && imagesUrl.isNotEmpty) {
      final v = imagesUrl.first;
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    final images = it['images'];
    if (images is List && images.isNotEmpty) {
      final v = images.first;
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    for (final k in const ['cover_url', 'image_url', 'cover', 'image']) {
      final v = it[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}

int? _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _asDouble(dynamic v) {
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}