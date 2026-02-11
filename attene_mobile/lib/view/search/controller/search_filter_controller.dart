import 'package:attene_mobile/view/search/controller/search_controller.dart';

import '../../../../general_index.dart';
import '../widget/big_search_filter.dart';
import 'search_controller.dart' as app;

class SearchFilterController extends GetxController {
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
        query['new'] = newProducts ? 1 : 0;
        query['for_sale'] = forSale ? 1 : 0;
        query['min_price'] = priceRange.start.toInt();
        query['max_price'] = priceRange.end.toInt();
        break;
      case SearchType.stores:
        query['active'] = activeStores ? 1 : 0;
        query['featured'] = featuredStores ? 1 : 0;
        break;
      case SearchType.services:
        query['available'] = availableServices ? 1 : 0;
        query['on_demand'] = onDemandServices ? 1 : 0;
        query['min_price'] = servicePriceRange.start.toInt();
        query['max_price'] = servicePriceRange.end.toInt();
        break;
      case SearchType.users:
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
        newProducts = true;
        forSale = true;
        priceRange = const RangeValues(0, 150);
        break;
      case SearchType.stores:
        activeStores = true;
        featuredStores = false;
        break;
      case SearchType.services:
        availableServices = true;
        onDemandServices = false;
        servicePriceRange = const RangeValues(100, 300);
        break;
      case SearchType.users:
        activeUsers = true;
        featuredUsers = false;
        onlineUsers = false;
        ageRange = const RangeValues(20, 40);
        break;
    }
    update();
  }
}