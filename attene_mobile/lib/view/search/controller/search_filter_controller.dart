import 'package:attene_mobile/view/search/controller/search_controller.dart';

import '../../../../general_index.dart';
import '../widget/big_search_filter.dart';
import 'search_controller.dart' as app;

class SearchFilterController extends GetxController {
  int? selectedCityId;

  int? selectedCategoryId;
  int? selectedSectionId;
  final List<int> selectedTagIds = [];
  final List<int> selectedVariationOptionIds = [];
  int? selectedReviewRate;
  String? selectedCondition;

  int? selectedServiceCategoryId;
  int? selectedStoreCategoryId;
  int? selectedReviewRateMin;
  String? selectedOrderBy;

  bool newProducts = true;
  bool forSale = true;
  RangeValues priceRange = const RangeValues(0, 150);

  bool activeStores = true;
  bool featuredStores = false;

  bool availableServices = true;
  bool onDemandServices = false;
  RangeValues servicePriceRange = const RangeValues(100, 300);

  bool activeUsers = true;
  bool featuredUsers = false;
  bool onlineUsers = false;
  RangeValues ageRange = const RangeValues(20, 40);

  @override
  void onInit() {
    super.onInit();
  }

  void toggleNew(bool value) {
    newProducts = value;
    update();
  }

  void toggleSale(bool value) {
    forSale = value;
    update();
  }

  void changePrice(RangeValues values) {
    priceRange = values;
    update();
  }

  void toggleActiveStores(bool value) {
    activeStores = value;
    update();
  }

  void toggleFeaturedStores(bool value) {
    featuredStores = value;
    update();
  }

  void toggleAvailableServices(bool value) {
    availableServices = value;
    update();
  }

  void toggleOnDemandServices(bool value) {
    onDemandServices = value;
    update();
  }

  void changeServicePrice(RangeValues values) {
    servicePriceRange = values;
    update();
  }

  void toggleActiveUsers(bool value) {
    activeUsers = value;
    update();
  }

  void toggleFeaturedUsers(bool value) {
    featuredUsers = value;
    update();
  }

  void toggleOnlineUsers(bool value) {
    onlineUsers = value;
    update();
  }

  void changeAgeRange(RangeValues values) {
    ageRange = values;
    update();
  }

  Map<String, dynamic> buildFilterQuery(SearchType type) {
    final Map<String, dynamic> query = {};

    switch (type) {
      case SearchType.products:
        if (selectedCategoryId != null) query['category_id'] = selectedCategoryId;
        if (selectedSectionId != null) query['section_id'] = selectedSectionId;
        if (selectedCityId != null) query['city_id'] = selectedCityId;
        if (selectedTagIds.isNotEmpty) query['tags[]'] = List<int>.from(selectedTagIds);
        if (selectedVariationOptionIds.isNotEmpty) {
          query['variation_options'] = '[${selectedVariationOptionIds.join(',')} ]'.replaceAll(' ', '');
        }

        query['min_price'] = priceRange.start.toInt();
        query['max_price'] = priceRange.end.toInt();

        if (newProducts) {
          query['condition'] = selectedCondition ?? 'new';
        } else if (selectedCondition != null) {
          query['condition'] = selectedCondition;
        }
        if (selectedReviewRate != null) query['review_rate'] = selectedReviewRate;
        if (forSale) query['for_sale'] = 1;
        break;
      case SearchType.stores:
        if (selectedCityId != null) query['city_id'] = selectedCityId;
        if (selectedStoreCategoryId != null) query['category_id'] = selectedStoreCategoryId;
        if (selectedTagIds.isNotEmpty) query['tags[]'] = List<int>.from(selectedTagIds);
        if (selectedReviewRateMin != null) query['review_rate_min'] = selectedReviewRateMin;
        if (selectedOrderBy != null) query['order_by'] = selectedOrderBy;

        query['active'] = activeStores ? 1 : 0;
        query['featured'] = featuredStores ? 1 : 0;
        break;
      case SearchType.services:
        if (selectedServiceCategoryId != null) query['category_id'] = selectedServiceCategoryId;
        if (selectedCityId != null) query['city_id'] = selectedCityId;
        if (selectedTagIds.isNotEmpty) query['tags[]'] = List<int>.from(selectedTagIds);
        query['min_price'] = servicePriceRange.start.toInt();
        query['max_price'] = servicePriceRange.end.toInt();
        if (selectedReviewRateMin != null) query['review_rate_min'] = selectedReviewRateMin;
        if (selectedOrderBy != null) query['order_by'] = selectedOrderBy;

        query['available'] = availableServices ? 1 : 0;
        query['on_demand'] = onDemandServices ? 1 : 0;
        break;
      case SearchType.users:
        if (selectedCityId != null) query['city_id'] = selectedCityId;
        if (selectedTagIds.isNotEmpty) query['tags[]'] = List<int>.from(selectedTagIds);
        if (selectedReviewRate != null) query['review_rate'] = selectedReviewRate;
        if (selectedOrderBy != null) query['order_by'] = selectedOrderBy;

        query['active'] = activeUsers ? 1 : 0;
        query['featured'] = featuredUsers ? 1 : 0;
        query['online'] = onlineUsers ? 1 : 0;
        query['min_age'] = ageRange.start.toInt();
        query['max_age'] = ageRange.end.toInt();
        break;
    }

    return query;
  }

  void resetFilters(SearchType type) {
    switch (type) {
      case SearchType.products:
        selectedCityId = null;
        selectedCategoryId = null;
        selectedSectionId = null;
        selectedTagIds.clear();
        selectedVariationOptionIds.clear();
        selectedReviewRate = null;
        selectedCondition = null;
        newProducts = true;
        forSale = true;
        priceRange = const RangeValues(0, 150);
        break;
      case SearchType.stores:
        selectedCityId = null;
        selectedStoreCategoryId = null;
        selectedTagIds.clear();
        selectedReviewRateMin = null;
        selectedOrderBy = null;
        activeStores = true;
        featuredStores = false;
        break;
      case SearchType.services:
        selectedCityId = null;
        selectedServiceCategoryId = null;
        selectedTagIds.clear();
        selectedReviewRateMin = null;
        selectedOrderBy = null;
        availableServices = true;
        onDemandServices = false;
        servicePriceRange = const RangeValues(100, 300);
        break;
      case SearchType.users:
        selectedCityId = null;
        selectedTagIds.clear();
        selectedReviewRate = null;
        selectedOrderBy = null;
        activeUsers = true;
        featuredUsers = false;
        onlineUsers = false;
        ageRange = const RangeValues(20, 40);
        break;
    }
    update();
  }
}