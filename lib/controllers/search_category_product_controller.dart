import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/home_page_models/home_page_product_model.dart';
import '../models/search_category_products_model.dart';
import '../services/remote_services.dart';

class SearchCategoryProductController extends GetxController {
  var productList = <ProductsModel>[].obs;
  var searchCategoryProductsModel = SearchCategoryProductsModel().obs;
  var isLoading = true.obs;
  var isRefreshing = true.obs;
  var isLoadingMore = false.obs;
  var filterKey = "".obs;
  var nameFilter = "".obs;
  var priceFilter = "".obs;
  var sliderMin = 0.obs;
  var sliderMax = 10000.obs;
  RangeValues currentRangeValues = const RangeValues(0, 10000);

/*  var type = "".obs;
  var types = ["product_type=","category_id="];*/
/*  var baseurl = "https://dev.themallbd.com/api/get_category_product/".obs;
  var baseurl_2 = "https://dev.themallbd.com/api/v3/collection/filtering?product_type=".obs;
  var endPoint = "collection/filtering?".obs;*/
  // var searchKey = "".obs;

  //var url=(baseurl.value+searchKey.value).obs;
/*  @override
  void onInit() {
    fetchData();
    super.onInit();
  }*/

  void loadMoreData(var url) async {
    isLoadingMore.value = true;

    var data = await RemoteServices.fetchLoadMoreSearchCategoryProductData(
        url.toString());
    try {
      if (data != null) {
        searchCategoryProductsModel.value = data;
        productList.value += /*productList.value + */ data.data!;
        isLoadingMore.value = false;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  void fetchData(String key) async {
    filterKey.value = key;
    var data = await RemoteServices.fetchSearchCategoryProductData(key);
    if (data != null) {
      searchCategoryProductsModel.value = data;

      productList.value = data.data!;
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void searchFilter() async {
    var data = await RemoteServices.fetchSearchCategoryProductData(
        "${filterKey.value}&sort_alphabet=${nameFilter.value}&sort_price=${priceFilter.value}&minimum_price=${sliderMin.value}&maximum_price=${sliderMax.value}");

    if (data != null) {
      searchCategoryProductsModel.value = data;

      productList.value = data.data!;
      isLoading.value = false;
    }
  }

  void handelRefresh() {
    isRefreshing.value = true;
    searchCategoryProductsModel.value = SearchCategoryProductsModel();
    fetchData(filterKey.value);
  }
}
