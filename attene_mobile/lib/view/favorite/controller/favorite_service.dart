import '../../../general_index.dart';

class FavoriteService {
  static Future<Map<String, dynamic>?> getFavorites({
    int page = 1,
    int perPage = 20,
  }) async {
    return await ApiHelper.get(
      path: '/favorites',
      queryParameters: {'page': page, 'per_page': perPage},
    );
  }

  static Future<Map<String, dynamic>?> getFavoritesByType(
    String type, {
    int page = 1,
    int perPage = 20,
  }) async {
    return await ApiHelper.get(
      path: '/favorites/type/$type',
      queryParameters: {'page': page, 'per_page': perPage},
    );
  }

  static Future<Map<String, dynamic>?> addFavorite(
    String type,
    String id, {
    String? listId,
  }) async {
    return await ApiHelper.post(
      path: '/favorites/add',
      body: {
        'favs_type': type,
        'favs_id': id,
        if (listId != null) 'list_id': listId,
      },
    );
  }

  static Future<Map<String, dynamic>?> removeFavorite(
    String type,
    String id,
  ) async {
    return await ApiHelper.post(
      path: '/favorites/remove',
      body: {'favs_type': type, 'favs_id': id},
    );
  }

  static Future<bool> checkFavorite(String type, String id) async {
    final res = await ApiHelper.post(
      path: '/favorites/check',
      body: {'favs_type': type, 'favs_id': id},
    );
    return res != null && res['status'] == true && res['data'] == true;
  }

  static Future<Map<String, dynamic>?> getFavoriteLists() async {
    return await ApiHelper.get(path: '/favorite-lists');
  }

  static Future<Map<String, dynamic>?> createFavoriteList(
    String name,
    String? description,
    bool isPrivate,
    String? type,
  ) async {
    return await ApiHelper.post(
      path: '/favorite-lists',
      body: {
        'name': name,
        if (description != null) 'description': description,
        'is_private': isPrivate ? 1 : 0,
        if (type != null) 'type': type,
      },
    );
  }

  static Future<Map<String, dynamic>?> updateFavoriteList(
    String id, {
    String? name,
    String? description,
    bool? isPrivate,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (isPrivate != null) body['is_private'] = isPrivate ? 1 : 0;
    return await ApiHelper.put(path: '/favorite-lists/$id', body: body);
  }

  static Future<Map<String, dynamic>?> deleteFavoriteList(String id) async {
    return await ApiHelper.delete(path: '/favorite-lists/$id');
  }

  static Future<Map<String, dynamic>?> getFavoritesInList(String listId) async {
    return await ApiHelper.get(path: '/favorite-lists/$listId/favs');
  }

  static Future<Map<String, dynamic>?> addMultipleFavoritesToList(
    String listId,
    List<Map<String, String>> items,
  ) async {
    return await ApiHelper.post(
      path: '/favorite-lists/$listId/favs',
      body: {'favs': items},
    );
  }
}