import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constraints/app_strings.dart';
import '../models/home_page_models/home_page_product_model.dart';
import '../models/search_category_products_model.dart';
import '../services/remote_services.dart';

class SearchProductController extends GetxController {
  var productList = <ProductsModel>[].obs;
  var searchProductsModel = SearchCategoryProductsModel().obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  //var baseurl = "https://dev.themallbd.com/api/product/search/".obs;
  var baseurl = "https://themallbd.com/";
  var searchKey = "new".obs;
  Timer? debouncer;
  var filterKey="".obs;
  var nameFilter="".obs;
  var priceFilter="".obs;
  var sliderMin=0.obs;
  var sliderMax=10000.obs;
  var margeData=false.obs;
  RangeValues currentRangeValues = const RangeValues(0, 10000);
  //var url=(baseurl.value+searchKey.value).obs;
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  void loadMoreData(var url) async {
    var data = await RemoteServices.fetchLoadMoreSearchCategoryProductData(url.toString());
    if (data != null) {
      searchProductsModel.value = data;
      productList.value = productList.value + data.data!;
      isLoadingMore.value = false;
    }
  }

  void fetchData() async => debounce(() async {
        {

          const endPoint=AppStrings.searchProductEndpoint;
          filterKey.value=endPoint+searchKey.value;
          var data = await RemoteServices.fetchSearchCategoryProductData(
              endPoint+searchKey.toString());
          if (data != null) {
            searchProductsModel.value = data;
            productList.value = data.data!;
            isLoading.value = false;
          }
        }
      });


  void searchFilter() async{
    var data = await RemoteServices.fetchSearchCategoryProductData("${filterKey.value}&sort_alphabet=${nameFilter.value}&sort_price=${priceFilter.value}&minimum_price=${sliderMin.value}&maximum_price=${sliderMax.value}");

    if (data != null) {
      searchProductsModel.value=data;
      productList.value = data.data!;
      isLoading.value = false;
    }
  }
}
