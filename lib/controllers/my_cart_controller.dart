import 'dart:convert';

import 'package:get/get.dart';
import '../constraints/app_strings.dart';
import '../models/cart_model.dart';
import '../models/home_page_models/home_page_product_model.dart';
import '../models/my_cart_model.dart';
import '../models/search_category_products_model.dart';
import '../services/local_services.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';
import 'bottom_navigation_bar_controller.dart';
import 'check_out_controller.dart';

class MyCartController extends GetxController {
  var myCartList = MyCartModel().obs;
  var localCart=<CartModel>[];
  var cartOfferProductsModule = <CartRule>[].obs;
  var removedCardRuleIds = [];
  var selectedCartRuleIds = [].obs;
  bool isModifiedCartRule = false;

  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var isUpdating = false.obs;
  var productList = <ProductsModel>[].obs;
  var searchCategoryProductsModel = SearchCategoryProductsModel().obs;
  var itemsOnLocal = 0.obs;
  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());

  var isReloading = false.obs;

  @override
  void onInit() {
    fetchMyCartData();
    // fetchRecommendedProduct();
    super.onInit();
  }

  void fetchMyCartData() async {
    selectedCartRuleIds.value = [];
    localCart=[];
    List<CartRule> cartOfferProductsModule2 = [];
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = AppStrings.myCartEndPoint;
    try {
      var data = await RemoteServices.getRequest(endPoint, header);
      if (data != null) {
        myCartList.value = myCartModelFromJson(data);
       controlLocalCart();
       Get.put(BottomNavigationBarController(),);
      /*
        await LocalServices.storeItemsOnCart(
            (myCartList.value.cart?.length ?? 0).toString());*/

        //final BottomNavigationBarController bottomNavigationBarController=Get.put(BottomNavigationBarController());
       /* bottomNavigationBarController.itemsOnCart.value =
            myCartList.value.cart?.length ?? 0;*/
      /*  itemsOnLocal.value =
            int.parse(await LocalServices.getItemsOnCart() ?? "0");*/
        isLoading.value = false;
        isUpdating.value = false;
        isReloading.value = false;
        myCartList.value.selectedCartRules?.forEach((element) {
          selectedCartRuleIds.add(element.id);
          if (element.targetModule == "product") {
            cartOfferProductsModule2.add(element);
          }
        });
        cartOfferProductsModule.value = cartOfferProductsModule2;

        //isChecked.value =List<bool>.filled(myCartList.value.cartRules?.length ?? 0, true);

        final checkoutController = Get.put(CheckOutController());
        checkoutController.selectedCartRuleIds = selectedCartRuleIds;
      }
    } finally {
      isLoading.value = false;
      isUpdating.value = false;
    }
  }

  void reloadCartData() async {
    List<CartRule> cartOfferProductsModule2 = [];
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = "${AppStrings.myCartEndPoint}?cart_rule_ids=";

    try {
      var data = await RemoteServices.getRequest(endPoint, header);
      if (data != null) {
        myCartList.value = myCartModelFromJson(data);

        controlLocalCart();

       /* await LocalServices.storeItemsOnCart(
            (myCartList.value.cart?.length ?? 0).toString());
        bottomNavigationBarController.itemsOnCart.value =
            myCartList.value.cart?.length ?? 0;
        itemsOnLocal.value =
            int.parse(await LocalServices.getItemsOnCart() ?? "0");*/
        isLoading.value = false;
        isUpdating.value = false;
        isReloading.value = false;

        selectedCartRuleIds.value = [];

        myCartList.value.selectedCartRules?.forEach((element) {
          if (!removedCardRuleIds.contains(element.id)) {
            selectedCartRuleIds.add(element.id);
            if (element.targetModule == "product") {
              cartOfferProductsModule2.add(element);
            }
          }
        });
        cartOfferProductsModule.value = cartOfferProductsModule2;

        final checkoutController = Get.put(CheckOutController());
        checkoutController.selectedCartRuleIds = selectedCartRuleIds;
      }
    } finally {
      isLoading.value = false;
      isUpdating.value = false;
    }
  }

  void updateCart({required int type, required int cartId}) async {
    isUpdating.value = true;
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = "${AppStrings.updateCartEndPoint}$cartId/$type";
    var data = await RemoteServices.getRequest(endPoint, header);

    if (data != null) {
      //fetchMyCartData();

/*      if(type==2 && !selectedCartRuleIds.contains(cartRuleId) ){
        selectedCartRuleIds.add(cartRuleId);
      }*/

      reloadCartData();
      Get.closeAllSnackbars();
      ShowSnackBar(msg: json.decode(data)["msg"], isSuccess: true)
          .showSnackBar();
      //myCartList.value=myCartModelFromJson(data);
      //await LocalServices.storeItemsOnCart((myCartList.value.cart?.length??0).toString());
    } else {
      Get.closeAllSnackbars();
      ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
          .showSnackBar();
      isUpdating.value = false;
    }
  }

  void updateOfferCart(/*{required List selectedCartRule}*/) async {
    isUpdating.value = true;
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = "";
    if (selectedCartRuleIds.isNotEmpty) {
      endPoint =
          "${AppStrings.myCartEndPoint}?cart_rule_ids=${selectedCartRuleIds.join(',')}";
    } else {
      endPoint =
          "${AppStrings.myCartEndPoint}?cart_rule_ids=cart_rule_remove_all";
    }

    try {
      var data = await RemoteServices.getRequest(endPoint, header);
      if (data != null) {
        List<CartRule> cartOfferProductsModule2 = [];
        selectedCartRuleIds.value = [];
        myCartList.value = myCartModelFromJson(data);
        controlLocalCart();

       /* await LocalServices.storeItemsOnCart(
            (myCartList.value.cart?.length ?? 0).toString());
        bottomNavigationBarController.itemsOnCart.value =
            myCartList.value.cart?.length ?? 0;
        itemsOnLocal.value =
            int.parse(await LocalServices.getItemsOnCart() ?? "0");*/
        isLoading.value = false;
        isUpdating.value = false;
        isReloading.value = false;

        myCartList.value.selectedCartRules?.forEach((element) {
          selectedCartRuleIds.add(element.id);
          if (element.targetModule == "product") {
            cartOfferProductsModule2.add(element);
          }
        });
        cartOfferProductsModule.value = cartOfferProductsModule2;
        final checkoutController = Get.put(CheckOutController());
        checkoutController.selectedCartRuleIds = selectedCartRuleIds;
      }
    } finally {
      isLoading.value = false;
      isUpdating.value = false;
    }
  }

  void fetchRecommendedProduct() async {
    //isLoading.value=true;
    var endPoint = "${AppStrings.filterByProductTypeEndPoint}new_products";
    var data = await RemoteServices.fetchSearchCategoryProductData(endPoint);
    if (data != null) {
      searchCategoryProductsModel.value = data;
      productList.value = data.data!;
      isLoading.value = false;
    }
  }

  void removeFromCart(int cartId) async {
    isReloading.value = true;
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = "${AppStrings.removeFromCartEndPoint}$cartId";
    try {
      var data = await RemoteServices.getRequest(endPoint, header);

      if (data != null) {
        fetchMyCartData();
        Get.closeAllSnackbars();
        ShowSnackBar(msg: json.decode(data)["msg"], isSuccess: true)
            .showSnackBar();
        // isReloading.value=false;
      } else {
        isReloading.value = false;
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
            .showSnackBar();
      }
    } finally {
      //isReloading.value=false;
    }
  }

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

  void removeMultipleItemsFromCart(int cartId, int quantity) async {
    isReloading.value = true;
    var token = await LocalServices.getToken() ?? "";
    const endPoint = AppStrings.multipleItemsRemoveFromCartEndPoint;
    var header = {'Authorization': 'Bearer $token'};
    try {
      var response =
          await RemoteServices.getRequest("$endPoint$cartId/$quantity", header);
      if (response != null) {
        fetchMyCartData();
        Get.closeAllSnackbars();
        ShowSnackBar(msg: json.decode(response)["msg"], isSuccess: true)
            .showSnackBar();
        //myCartList.value=myCartModelFromJson(data);
        //await LocalServices.storeItemsOnCart((myCartList.value.cart?.length??0).toString());
      } else {
        Get.closeAllSnackbars();
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
            .showSnackBar();
      }
    } finally {
      isReloading.value = false;
    }
  }

  void controlLocalCart() async {
    localCart=[];
    for (var element in myCartList.value.cart!) {
      CartModel cartModel=CartModel();
      cartModel.product_id=element.productId.toString();
      cartModel.product_quantity=element.quantity.toString();
      localCart.add(cartModel);
    }
    await LocalServices.storeCartItem(localCart).then((value){
      bottomNavigationBarController.getCartItems();
    });
  }

  handelRefresh() {
    isUpdating.value=true;
    fetchMyCartData();
    productList.value=[];
    fetchRecommendedProduct();
  }
}
