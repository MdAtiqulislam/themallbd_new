import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/constraints/app_colors.dart';
import 'package:themallbd_new/constraints/header_text.dart';
import 'package:themallbd_new/controllers/related_product_controller.dart';
import 'package:themallbd_new/models/report_reasons_model.dart';
import 'package:themallbd_new/widgets/custom_report_view.dart';

import '../constraints/app_strings.dart';
import '../models/cart_model.dart';
import '../models/life_style_product_details_moddel.dart';
import '../models/product_details_model.dart';
import '../models/reviews_model.dart';
import '../models/user_models/wish_list_model.dart';
import '../services/local_services.dart';
import '../services/remote_services.dart';

import 'package:facebook_app_events/facebook_app_events.dart';

import '../utils/show_snack_bar.dart';
import 'bottom_navigation_bar_controller.dart';
import 'my_cart_controller.dart';

class ProductDetailsController extends GetxController {
  List<CartModel> cartList = [];
  var images = <String>[].obs;
  static final facebookAppEvents = FacebookAppEvents();
  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());

  //final MyCartController myCartController = Get.put(MyCartController());
  var productDetailsModel = ProductDetailsMode().obs;
  var lifeStyleProductDetailsModel = LifeStyleProductDetailsModel().obs;

  var isLoading = true.obs;
  var isUpdating = false.obs;
  var reLoading = false.obs;
  var isLoadingMore = false.obs;

//  var addingReview = false.obs;
  var token = "".obs;
  var showReviewSection = false.obs;

  //var url="https://dev.themallbd.com/api/get_category";
  var endPoint = "product-details-v2/";
  var proId = "".obs;
  var isWish = false.obs;

  //var rating = 5.obs;
/*  final titleController = TextEditingController();
  final reviewController = TextEditingController();*/

  var lifeStyleSelectedColorIndex = 0.obs;
  var lifeStyleSelectedSizeIndex = 0.obs;
  var reportReasonList = <ReportReasonModel>[].obs;

  //var token="".obs;

  @override
  void onInit() async {
    //token.value=(await LocalServices.getToken())!;
    // fetchData();

    cartList = (await LocalServices.getCartItems()) ?? [];
    token.value = await LocalServices.getToken() ?? "";
    //checkWishList();
    getReportReasons();
    super.onInit();
  }

  void fetchData({String? reloadKey}) async {

   // var test="nivea-shea-smooth-48h-body-milk-for-dry-skin-400ml";
    try {
      var data = await RemoteServices.fetchProductDetailsData(
          //"${reloadKey ?? endPoint}${test}");
          "${reloadKey ?? endPoint}${proId.value}");
      if (data != null) {
        productDetailsModel.value = data;

        images.value = productDetailsModel.value.regularImages!;
        proId.value = productDetailsModel.value.productId.toString();
        checkWishList();
        isLoading.value = false;
        reLoading.value = false;
      }
    } finally {
      isLoading.value = false;
      reLoading.value = false;
    }
  }

  void checkWishList() async {
    List<WishListModel>? wishLists;
    const endPoint = AppStrings.wishListEndpoint;
    if (token.value.isNotEmpty) {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        wishLists = wishListModelFromJson(response);
        for (var element in wishLists) {
          if (element.productId?.toInt() == int.parse(proId.value)) {
            isWish.value = true;
            return;
          } else {
            isWish.value = false;
          }
        }
      }
    }
  }

  void addToWishList() async {
    facebookAppEvents.logAddToWishlist(
        id: proId.value,
        type: "product",
        currency: "BDT",
        price: (productDetailsModel.value.appPrice?.toDouble() ?? 0.0) > 0
            ? (productDetailsModel.value.appPrice?.toDouble() ?? 0.0)
            : (productDetailsModel.value.regularPrice?.toDouble() ?? 0.0));

    if (token.value.isNotEmpty) {
      const endPoint = AppStrings.addWishListEndpoint;
      var response = await RemoteServices.postRequest(endPoint,
          {"product_id": proId.value}, {'Authorization': 'Bearer $token'});

      if (response != null) {
        isWish.value = true;
        ShowSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
      }
    } else {
      Get.closeAllSnackbars();
      ShowSnackBar(
          title: "Login Required!",
          msg: "Please Login first to add Wish List",
          showButton: true,
          buttonText: "GO TO LOGIN",
          isWarning: true,
          callback: () {
            Get.toNamed("/login_page");
          }).showSnackBar();
    }
    // print(response);
  }

  void controlWishList() async {
    if (isWish.value) {
      deleteFromWishList();
    } else {
      addToWishList();
    }
  }

  void deleteFromWishList() async {
    if (token.value.isNotEmpty) {
      const endPoint = AppStrings.deleteWishListEndpoint;
      var response = await RemoteServices.getRequest(
          endPoint + proId.value, {'Authorization': 'Bearer $token'});

      if (response != null) {
        isWish.value = false;
        // print(response);
        ShowSnackBar(msg: json.decode(response)["msg"], isSuccess: true)
            .showSnackBar();
      }
    } else {
      ShowSnackBar(
          isWarning: true,
          title: "Login Required!",
          msg: "Please Login first to add Wish List",
          showButton: true,
          callback: () {
            Get.toNamed("/login_page");
          }).showSnackBar();
    }
    // print(response);
  }

  void controlReviewSection() async {
    if (token.value.isNotEmpty) {
      showReviewSection.value = !showReviewSection.value;
    } else {
      Get.closeAllSnackbars();
      ShowSnackBar(
          isWarning: true,
          title: ("Login Required!"),
          msg: "Please Login first to write a review...",
          showButton: true,
          buttonText: "GO TO LOGIN?",
          callback: () {
            Get.toNamed("/login_page");
            // Get.back();
          }).showSnackBar();
    }
  }

  /* void addReview({String? page}) async {
    addingReview.value = true;
    const endPoint = AppStrings.addReviewEndpoint;
    var header = {'Authorization': 'Bearer ${token.value}'};

    var body = {
      'product_id': proId.value.toString(),
      'title': titleController.text,
      'review': reviewController.text,
      'rating': rating.value.toString(),
    };

    try {
      var response = await RemoteServices.postRequest(endPoint, body, header);
      if (response != null) {
        //print(response);
        addingReview.value = false;
        if(page=="ReviewPage"){
          Get.back();
        }
        ShowSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
      }
    } finally {
      addingReview.value = false;
    }
  }*/

  void addToCart(CartModel cartModel, bool isLifeStyle) async {
    isUpdating.value = true;

    facebookAppEvents.logAddToCart(
        id: cartModel.product_id.toString(),
        type: "product",
        currency: "BDT",
        price: (productDetailsModel.value.regularPrice ?? 0).toDouble());

    try {
      if (token.value.isEmpty) {
        /*cartList.removeWhere((element) =>
            cartModel.product_id!.contains(element.product_id.toString()));*/
        if (!updateCart(cartModel, isLifeStyle)) {
          cartList.add(cartModel);
          Get.closeAllSnackbars();
          ShowSnackBar(
              isSuccess: true,
              msg: "Product added Successfully!",
              showButton: true,
              buttonText: "View Cart",
              callback: () {
                ShowSnackBar(
                    isWarning: true,
                    msg:
                        "You are not Logged in yet. Please Login first to continue",
                    title: "Login Required",
                    showButton: true,
                    buttonText: "GO TO LOGIN?",
                    callback: () {
                      Get.back();
                      Get.toNamed("/login_page");
                    }).showSnackBar();
              }).showSnackBar();
        }
        await LocalServices.storeCartItem(cartList);
        bottomNavigationBarController.getCartItems();
        //  bottomNavigationBarController.itemsOnCart.value = cartList.length;
        isUpdating.value = false;
      } else {
        /* String endPoint =
            "${AppStrings.addSingleCartItemEndPoint}${cartModel
            .product_id}/${cartModel.product_quantity}";
        var header = {'Authorization': 'Bearer ${token.value}'};

        var data = await RemoteServices.getRequest(endPoint, header);
        if (data != null) {
          final MyCartController myCartController = Get.put(MyCartController());
          myCartController.fetchMyCartData();
          //print(await LocalServices.getItemsOnCart());
          bottomNavigationBarController.itemsOnCart.value =
              int.parse(await LocalServices.getItemsOnCart() ?? "0");*/

        String endPoint =
            "${AppStrings.addSingleCartItemEndPoint}${cartModel.product_id}/${cartModel.product_quantity}";
        var header = {'Authorization': 'Bearer ${token.value}'};

        var data = await RemoteServices.getRequest(endPoint, header);
        if (data != null) {
          MyCartController myCartController = Get.put(MyCartController());
          myCartController.fetchMyCartData();
          //print(await LocalServices.getItemsOnCart());
          /* bottomNavigationBarController.itemsOnCart.value =
              int.parse(await LocalServices.getItemsOnCart() ?? "0");*/

          Get.closeAllSnackbars();
          ShowSnackBar(
              isSuccess: true,
              msg: json.decode(data)["msg"],
              showButton: true,
              buttonText: "View Cart",
              callback: () {
                //Get.back();
                Get.toNamed("/my_cart");

                /*Navigator.pushReplacement(
                    Get.context!,
                    MaterialPageRoute(
                      builder: (context) => MyCartPage(),
                    ),
                  );*/
              }).showSnackBar();
          isUpdating.value = false;
        } else {
          Get.closeAllSnackbars();
          ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
              .showSnackBar();
        }
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void fetchLifeStyleProductData({String? refreshProId}) async {


    final endPoint = refreshProId != null
        ? AppStrings.lifeStyleProductDetailsEndPointWithID + proId.toString()
        : AppStrings.lifeStyleProductDetailsEndPoint + proId.toString();


    try {
      var data = await RemoteServices.getRequest(endPoint, {"": ""});
      if (data != null) {
        lifeStyleProductDetailsModel.value =
            lifeStyleProductDetailsModelFromJson(data);

        proId.value = lifeStyleProductDetailsModel
            .value.productDetails!.productId
            .toString();
        if ((lifeStyleProductDetailsModel.value.colorGroup?.length ?? 0) > 0) {
          images.value = lifeStyleProductDetailsModel
              .value.colorGroup![lifeStyleSelectedColorIndex.value].images!;

          for (int i = 0;
              i < (lifeStyleProductDetailsModel.value.colorGroup?.length ?? 0);
              i++) {
            for (int j = 0;
                j <
                    (lifeStyleProductDetailsModel
                            .value.colorGroup?[i].data?.length ??
                        0);
                j++) {
              if (lifeStyleProductDetailsModel
                      .value.colorGroup?[i].data?[j].productIn >
                  0) {
                lifeStyleSelectedColorIndex.value = i;
                lifeStyleSelectedSizeIndex.value = j;

                //i=(lifeStyleProductDetailsModel.value.colorGroup?.length ?? 0);
                // j=(lifeStyleProductDetailsModel.value.colorGroup?[i].data?.length??0);
                return;
              }
            }
          }
        } else {
          images.value =
              lifeStyleProductDetailsModel.value.productDetails!.regularImages!;
        }
        checkWishList();
        isLoading.value = false;
        reLoading.value = false;
      }
    } finally {
      isLoading.value = false;
      reLoading.value = false;
    }
  }

  bool updateCart(CartModel cartModel, bool isLifeStyle) {
    int reqQuantity = int.parse(cartModel.product_quantity ?? "0");
    int proQuantity = isLifeStyle
        ? (lifeStyleProductDetailsModel
                .value
                .colorGroup?[lifeStyleSelectedColorIndex.value]
                .data?[lifeStyleSelectedSizeIndex.value]
                .productIn) ??
            0
        : productDetailsModel.value.productIn ?? 0;

    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i].product_id == cartModel.product_id) {
        int inCartQuantity = int.parse(cartList[i].product_quantity ?? "0");
        if (inCartQuantity + reqQuantity <= (proQuantity)) {
          cartList[i].product_quantity =
              (inCartQuantity + reqQuantity).toString();
          Get.closeAllSnackbars();
          ShowSnackBar(
              isSuccess: true,
              msg: "Quantity Update Successfully!",
              showButton: true,
              buttonText: "View Cart",
              callback: () {
                ShowSnackBar(
                    isWarning: true,
                    msg:
                        "You are not Logged in yet. Please Login first to continue",
                    title: "Login Required",
                    showButton: true,
                    buttonText: "GO TO LOGIN?",
                    callback: () {
                      Get.back();
                      Get.toNamed("/login_page");
                    }).showSnackBar();
              }).showSnackBar();
        } else {
          Get.closeAllSnackbars();
          ShowSnackBar(
                  msg: "Requested product quantity is not available.",
                  isSuccess: false)
              .showSnackBar();
        }
        return true;
      }
    }
    return false;
  }

  handelRefresh() {
    // var endPoint="product-details/";
    reLoading.value = true;
    //productDetailsModel.value = ProductDetailsMode();
    images.value = [];
    fetchData(reloadKey: "product-details/");
    RelatedProductController relatedProductController =
        Get.put(RelatedProductController());
    relatedProductController.key.value = proId.value;
    relatedProductController.fetchData(endPointForProId: "related-products/");
  }

  handelRefreshLifeStyle() {
    // var endPoint="product-details/";
    reLoading.value = true;
    //productDetailsModel.value = ProductDetailsMode();
    images.value = [];
    fetchLifeStyleProductData(refreshProId: proId.value);
    RelatedProductController relatedProductController =
        Get.put(RelatedProductController());
    relatedProductController.key.value = proId.value;
    relatedProductController.fetchData(endPointForProId: "related-products/");
  }

  Future<void> getReportReasons() async {
    if (await LocalServices.getToken() != null && reportReasonList.isEmpty) {
      isLoading.value = true;
      var endPoint = AppStrings.getReportReasonEndpoint;
      try {
        var response = await RemoteServices.getRequest(
            endPoint, {'Authorization': 'Bearer $token'});
        reportReasonList.value = reportReasonModelFromJson(response);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void openReportPage({required ReviewsModel review }) async {
    if (await LocalServices.getToken() != null) {
      await getReportReasons().then((value) {
        Get.bottomSheet(
          CustomReportView(reportReason: reportReasonList,review: review,),
          backgroundColor: Colors.white,
          // Add background color if needed
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
        );
      });
    } else {
      ShowSnackBar(
          msg: "You are not Logged in yet. Please Login first to continue",
          title: "Login Required",
          showButton: true,
          buttonText: "GO TO LOGIN?",
          isWarning: true,
          callback: () {
            Get.back();
            Get.toNamed("/login_page");
          }).showSnackBar();
    }
  }
}
