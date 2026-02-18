import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../general_index.dart';

enum FavoriteType { product, service, store, blog, user }

class FavoriteController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  String errorMessage = '';

  final RxList<Map<String, dynamic>> allFavorites =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> services = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> blogs = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recentFavorites =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> favoriteLists =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> selectedList = <String, dynamic>{}.obs;

  final Map<String, List<Map<String, dynamic>>> _pendingListItems = {};

  @override
  void onInit() {
    super.onInit();
    fetchAllFavorites();
    fetchFavoriteLists();
    loadPreviewImagesForAllGroups();
  }

  Future<void> fetchAllFavorites({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      allFavorites.clear();
      products.clear();
      services.clear();
      stores.clear();
      users.clear();
      blogs.clear();
      recentFavorites.clear();
    }

    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await ApiHelper.get(
        path: '/favorites',
        queryParameters: {'page': currentPage.value, 'per_page': 20},
      );

      if (res != null && res['status'] == true) {
        final List<dynamic> items = res['data'] ?? res['favorites'] ?? [];
        _processFavorites(items);
        _updatePagination(res);
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'فشل تحميل المفضلة';
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'خطأ في الشبكة: ${e.toString()}';
      print('🔥 [Favorite] fetchAllFavorites error: $e\n$stack');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFavoritesByType(
    FavoriteType type, {
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage.value = 1;
      _clearTypeList(type);
    }

    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await ApiHelper.get(
        path: '/favorites/type/${type.name}',
        queryParameters: {'page': currentPage.value, 'per_page': 20},
      );

      if (res != null && res['status'] == true) {
        final List<dynamic> items = res['data'] ?? res['favorites'] ?? [];
        _addToTypeList(type, items);
        _updatePagination(res);
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'خطأ في الشبكة: ${e.toString()}';
      print('🔥 [Favorite] fetchFavoritesByType error: $e\n$stack');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    currentPage.value++;
    await fetchAllFavorites();
  }

  Future<bool> addToFavorites({
    required FavoriteType type,
    required String itemId,
    String? listId,
  }) async {
    try {
      final body = {
        'favs_type': type.name,
        'favs_id': itemId,
        if (listId != null) 'list_id': listId,
      };

      final res = await ApiHelper.post(path: '/favorites/add', body: body);

      if (res != null && res['status'] == true) {
        final favoriteData = res['favorite'] as Map<String, dynamic>?;

        if (listId != null) {
          _addFavoriteToListLocally(listId, favoriteData);
        } else {
          if (favoriteData != null) {
            _addFavoriteToLocalLists(favoriteData);
          }
        }

        Get.snackbar(
          'تم',
          res['message'] ?? 'تمت الإضافة إلى المفضلة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'خطأ',
          res?['message'] ?? 'فشلت الإضافة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('🔥 [Favorite] addToFavorites error: $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites({
    required FavoriteType type,
    required String itemId,
  }) async {
    try {
      final res = await ApiHelper.post(
        path: '/favorites/remove',
        body: {'favs_type': type.name, 'favs_id': itemId},
      );

      if (res != null && res['status'] == true) {
        _removeFavoriteFromLocalLists(type, itemId);
        Get.snackbar(
          'تم',
          'تمت الإزالة من المفضلة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'خطأ',
          res?['message'] ?? 'فشلت الإزالة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('🔥 [Favorite] removeFromFavorites error: $e');
      return false;
    }
  }

  Future<bool> checkIsFavorite({
    required FavoriteType type,
    required String itemId,
  }) async {
    try {
      final res = await ApiHelper.post(
        path: '/favorites/check',
        body: {'favs_type': type.name, 'favs_id': itemId},
      );
      return res != null && res['status'] == true && res['data'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchFavoriteLists() async {
    try {
      final res = await ApiHelper.get(path: '/favorite-lists');
      if (res != null && res['status'] == true) {
        final List<dynamic> listsData = res['lists'] ?? [];
        final List<Map<String, dynamic>> parsedLists = listsData.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
        favoriteLists.assignAll(parsedLists);
      }
    } catch (e) {
      print('🔥 [Favorite] fetchFavoriteLists error: $e');
    }
  }

  Future<void> createFavoriteList({
    required String name,
    String? description,
    bool isPrivate = true,
    required String type,
  }) async {
    try {
      final res = await ApiHelper.post(
        path: '/favorite-lists',
        body: {
          'name': name,
          if (description != null) 'description': description,
          'is_private': isPrivate ? 1 : 0,
          'type': type,
        },
      );

      if (res != null && res['status'] == true) {
        await fetchFavoriteLists();
        Get.back();
        Get.snackbar('تم', 'تم إنشاء المجموعة بنجاح');
      } else {
        Get.snackbar('خطأ', res?['message'] ?? 'فشل إنشاء المجموعة');
      }
    } catch (e) {
      print('🔥 [Favorite] createFavoriteList error: $e');
    }
  }

  Future<void> updateFavoriteList({
    required String listId,
    String? name,
    String? description,
    bool? isPrivate,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (isPrivate != null) body['is_private'] = isPrivate ? 1 : 0;

      final res = await ApiHelper.put(
        path: '/favorite-lists/$listId',
        body: body,
      );

      if (res != null && res['status'] == true) {
        await fetchFavoriteLists();
        Get.back();
        Get.snackbar('تم', 'تم تحديث المجموعة');
      } else {
        Get.snackbar('خطأ', res?['message'] ?? 'فشل التحديث');
      }
    } catch (e) {
      print('🔥 [Favorite] updateFavoriteList error: $e');
    }
  }

  Future<void> deleteFavoriteList(String listId) async {
    try {
      final res = await ApiHelper.delete(path: '/favorite-lists/$listId');
      if (res != null && res['status'] == true) {
        await fetchFavoriteLists();
        Get.back();
        Get.snackbar('تم', 'تم حذف المجموعة');
      } else {
        Get.snackbar('خطأ', res?['message'] ?? 'فشل الحذف');
      }
    } catch (e) {
      print('🔥 [Favorite] deleteFavoriteList error: $e');
    }
  }

  Future<void> fetchFavoritesInList(String listId) async {
    try {
      isLoading.value = true;
      final res = await ApiHelper.get(path: '/favorite-lists/$listId/favs');

      if (res != null && res['status'] == true) {
        final List<dynamic> items =
            res['data'] ?? res['favorites'] ?? res['items'] ?? [];

        final List<Map<String, dynamic>> actualItems = items.map((e) {
          final Map<String, dynamic> item = Map<String, dynamic>.from(e);
          return item.containsKey('favs')
              ? Map<String, dynamic>.from(item['favs'])
              : item;
        }).toList();

        final pending = _pendingListItems[listId] ?? [];
        if (pending.isNotEmpty) {
          actualItems.addAll(pending);
          _pendingListItems[listId] = [];
        }

        selectedList.value = {
          'id': listId,
          'items': actualItems,
          ...Map<String, dynamic>.from(res['list'] ?? {}),
        };

        _updateGroupPreviewImages(listId, actualItems);
      } else {
        print('❌ [fetchFavoritesInList] Error: ${res?['message']}');
      }
    } catch (e) {
      print('🔥 [fetchFavoritesInList] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<String> _extractPreviewImages(List<Map<String, dynamic>> items) {
    final List<String> previewImages = [];
    for (var item in items) {
      String? imageUrl;
      if (item['cover'] != null) {
        imageUrl = item['cover'].toString();
      } else if (item['image'] != null) {
        imageUrl = item['image'].toString();
      } else if (item['logo'] != null) {
        imageUrl = item['logo'].toString();
      } else if (item['images'] != null && item['images'] is List) {
        final images = item['images'] as List;
        if (images.isNotEmpty) {
          imageUrl = images.first.toString();
        }
      }
      if (imageUrl != null && imageUrl.isNotEmpty) {
        previewImages.add(imageUrl);
        if (previewImages.length >= 4) break;
      }
    }
    return previewImages;
  }

  void _updateGroupPreviewImages(
    String listId,
    List<Map<String, dynamic>> items,
  ) {
    final previewImages = _extractPreviewImages(items);
    final index = favoriteLists.indexWhere((l) => l['id'].toString() == listId);
    if (index != -1) {
      favoriteLists[index]['preview_images'] = previewImages;
      favoriteLists.refresh();
    }
  }

  Future<void> loadPreviewImagesForAllGroups() async {
    for (var group in favoriteLists) {
      final listId = group['id'].toString();
      if (group['preview_images'] != null &&
          (group['preview_images'] as List).isNotEmpty)
        continue;
      try {
        final res = await ApiHelper.get(
          path: '/favorite-lists/$listId/favs',
          queryParameters: {'per_page': 4},
        );
        if (res != null && res['status'] == true) {
          final List<dynamic> items =
              res['data'] ?? res['favorites'] ?? res['items'] ?? [];
          final List<Map<String, dynamic>> actualItems = items.map((e) {
            final item = Map<String, dynamic>.from(e);
            return item.containsKey('favs')
                ? Map<String, dynamic>.from(item['favs'])
                : item;
          }).toList();
          _updateGroupPreviewImages(listId, actualItems);
        }
      } catch (e) {
        print('⚠️ [Favorite] Failed to load preview for group $listId: $e');
      }
    }
  }

  void _addFavoriteToLocalLists(Map<String, dynamic> favoriteItem) {
    final String favsType = favoriteItem['favs_type'] ?? '';
    final dynamic favsData = favoriteItem['favs'] ?? {};

    allFavorites.add(favoriteItem);

    switch (favsType) {
      case 'product':
        products.add(Map<String, dynamic>.from(favsData));
        break;
      case 'service':
        services.add(Map<String, dynamic>.from(favsData));
        break;
      case 'store':
        stores.add(Map<String, dynamic>.from(favsData));
        break;
      case 'blog':
        blogs.add(Map<String, dynamic>.from(favsData));
        break;
      case 'user':
        users.add(Map<String, dynamic>.from(favsData));
        break;
    }

    recentFavorites.insert(0, favoriteItem);
    if (recentFavorites.length > 10) {
      recentFavorites.removeLast();
    }

    update();
  }

  void _addFavoriteToListLocally(
    String listId,
    Map<String, dynamic>? favoriteData,
  ) {
    if (favoriteData == null) return;

    final listIndex = favoriteLists.indexWhere(
      (l) => l['id'].toString() == listId,
    );
    if (listIndex != -1) {
      final currentCount =
          int.tryParse(
            favoriteLists[listIndex]['favs_count']?.toString() ?? '0',
          ) ??
          0;
      favoriteLists[listIndex]['favs_count'] = (currentCount + 1).toString();

      final currentPreview = List<String>.from(
        favoriteLists[listIndex]['preview_images'] ?? [],
      );
      final newImage = _extractPreviewImages([favoriteData]).firstOrNull;
      if (newImage != null && !currentPreview.contains(newImage)) {
        currentPreview.insert(0, newImage);
        if (currentPreview.length > 4) currentPreview.removeLast();
        favoriteLists[listIndex]['preview_images'] = currentPreview;
      }
      favoriteLists.refresh();
    }

    if (selectedList['id'] == listId) {
      final currentItems = List<Map<String, dynamic>>.from(
        selectedList['items'] ?? [],
      );
      currentItems.add(favoriteData);
      selectedList['items'] = currentItems;
    } else {
      _pendingListItems.putIfAbsent(listId, () => []).add(favoriteData);
    }

    update();
  }

  void _removeFavoriteFromLocalLists(FavoriteType type, String itemId) {
    allFavorites.removeWhere(
      (e) => e['favs_type'] == type.name && e['favs_id'].toString() == itemId,
    );

    final list = _getTypeList(type);
    list.removeWhere((e) => e['id'].toString() == itemId);

    recentFavorites.removeWhere(
      (e) => e['favs_type'] == type.name && e['favs_id'].toString() == itemId,
    );

    if (selectedList.isNotEmpty) {
      final items = List<Map<String, dynamic>>.from(
        selectedList['items'] ?? [],
      );
      items.removeWhere((e) => e['id'].toString() == itemId);
      selectedList['items'] = items;
    }

    final listId = selectedList['id']?.toString();
    if (listId != null) {
      final listIndex = favoriteLists.indexWhere(
        (l) => l['id'].toString() == listId,
      );
      if (listIndex != -1) {
        final currentCount =
            int.tryParse(
              favoriteLists[listIndex]['favs_count']?.toString() ?? '0',
            ) ??
            0;
        favoriteLists[listIndex]['favs_count'] = (currentCount - 1)
            .clamp(0, double.infinity)
            .toString();

        final currentItems = List<Map<String, dynamic>>.from(
          selectedList['items'] ?? [],
        );
        final updatedPreview = _extractPreviewImages(currentItems);
        favoriteLists[listIndex]['preview_images'] = updatedPreview;
        favoriteLists.refresh();
      }
    }

    update();
  }

  void _processFavorites(List<dynamic> items) {
    for (var item in items) {
      final map = Map<String, dynamic>.from(item);
      final String favsType = map['favs_type'] ?? '';
      final dynamic favsData = map['favs'] ?? {};

      switch (favsType) {
        case 'product':
          products.add(Map<String, dynamic>.from(favsData));
          break;
        case 'service':
          services.add(Map<String, dynamic>.from(favsData));
          break;
        case 'store':
          stores.add(Map<String, dynamic>.from(favsData));
          break;
        case 'blog':
          blogs.add(Map<String, dynamic>.from(favsData));
          break;
        case 'user':
          users.add(Map<String, dynamic>.from(favsData));
          break;
      }
      allFavorites.add(map);

      if (recentFavorites.length < 10) {
        recentFavorites.add(map);
      }
    }
  }

  void _addToTypeList(FavoriteType type, List<dynamic> items) {
    final list = _getTypeList(type);
    for (var item in items) {
      list.add(Map<String, dynamic>.from(item));
    }
  }

  RxList<Map<String, dynamic>> _getTypeList(FavoriteType type) {
    switch (type) {
      case FavoriteType.product:
        return products;
      case FavoriteType.service:
        return services;
      case FavoriteType.store:
        return stores;
      case FavoriteType.blog:
        return blogs;
      case FavoriteType.user:
        return users;
    }
  }

  void _clearTypeList(FavoriteType type) {
    _getTypeList(type).clear();
  }

  void _updatePagination(Map<String, dynamic> response) {
    final pagination = response['pagination'] ?? response['meta'] ?? {};
    final current = pagination['current_page'] ?? 1;
    final last = pagination['last_page'] ?? 1;
    hasMore.value = current < last;
  }

  List<Map<String, dynamic>> get currentResults => allFavorites;
}
