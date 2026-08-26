import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import '../constraints/app_strings.dart';
import '../models/area_list_model.dart';
import '../models/district_list_model.dart';
import '../models/my_cart_model.dart';
import '../models/shipping_method_model.dart';
import '../models/user_models/delivery_address_model.dart';
import '../models/user_models/user_details_model.dart';
import '../services/app_review_service.dart';
import '../services/local_services.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';
import '../views/pages/bkash_payment.dart';
import 'bottom_navigation_bar_controller.dart';
import 'my_cart_controller.dart';



class CheckOutController extends GetxController {
  final InAppReview inAppReview = InAppReview.instance;
  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  var myCartList = MyCartModel().obs;
  var isLoading = true.obs;
  var shippingMethods = <ShippingMethodModel>[].obs;
  var shippingMethodId = "".obs;
  var shippingCharge = "".obs;
  var isDeliveryAddress = false.obs;

  var cartOfferProductsModule = <CartRule>[].obs;
  var otherModule = <CartRule>[].obs;
  var allModule = <CartRule>[].obs;

  var radioAddressValue = 0.obs;

  var paymentMethodRadio = 0.obs;
  var selectedPaymentMethod = 0.obs;

  var termsANDConditionCB = true.obs;
  var isLoadingDistrict = true.obs;
  var isLoadingArea = true.obs;

  // var isLoadingArea = false.obs;
  var isUpdating = false.obs;
  var couponId = "".obs;

  //var isLoadingDistrict = false.obs;
  var isLoadingAddress = false.obs;
  var userData = UserDetailsModel().obs;
  var areaList = <AreaListModel>[].obs;
  var districtList = <DistrictListModel>[].obs;
  var addressList = <DeliveryAddressModel>[].obs;
  var valueChooseArea = AreaListModel().obs;
  var valueChooseDistrict = DistrictListModel().obs;

  var firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dateInputController = TextEditingController();
  final orderNoteController = TextEditingController();
  final couponCodeController = TextEditingController();
  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());
  final MyCartController myCartController = Get.put(MyCartController());

  //for cart rule
  var selectedCartRuleIds = [].obs;
  var myCartRuleIds = [].obs;
  var removedCartRuleIds = [].obs;

  var paymentMethodEMI={
    "id": 2,
    "name": "EMI",
    "image": "assets/images/checkout_icons/emi.png",
  };
 var minimumEMIAmount=5000;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dateInputController.dispose();
    orderNoteController.dispose();
    couponCodeController.dispose();
    valueChooseArea.value = AreaListModel();
    valueChooseDistrict.value = DistrictListModel();
    super.dispose();
  }

  var paymentMethod = [].obs;

  var cityOrAreaId = "0".obs;

  @override
  void onInit() {
    //fetchUserData();
    // fetchAreaData();
    // fetchDistrictData();
    //fetchDeliveryAddress();
    // fetchShippingMethods();
    // fetchMyCartData();
    super.onInit();
    // valueChooseDistrict.value=null;
  }

  void fetchShippingMethods() async {
    final token = await LocalServices.getToken() ?? "";
    const endPoint = AppStrings.shippingMethodsEndPoint;
    var header = {'Authorization': 'Bearer $token'};
    var response = await RemoteServices.getRequest(endPoint, header);
    if (response != null) {
      shippingMethods.value = shippingMethodModelFromJson(response);
      fetchShippingMethodId();
      //fetchMyCartData();
      loadCartData();
    }
  }

  //for caking new cart rules in terms of payment method

  void loadCartData() async {
    getCityOrAreaId();
    if(paymentMethod.isEmpty||selectedPaymentMethod.value==0) {
      getPaymentMethods();
    }
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint =
        "${AppStrings.myCartEndPoint}?coupon_id=${couponId.value}&shipping_id=${shippingMethodId.value}&payment_method=${selectedPaymentMethod.value}&city_or_area_id=${cityOrAreaId.value}";
    try {
      var data = await RemoteServices.getRequest(endPoint, header);
      if (data != null) {
        myCartList.value = myCartModelFromJson(data);

        cartOfferProductsModule.value = [];
        otherModule.value = [];
        // allModule.value=[];
        selectedCartRuleIds.value = [];
        myCartList.value.selectedCartRules?.forEach((element) {
          if (!removedCartRuleIds.contains(element.id)) {
            selectedCartRuleIds.add(element.id);
            /* if (element.targetModule == "product") {
              cartOfferProductsModule.add(element);
            } else {
              otherModule.add(element);
            }*/
          }
        });
        fetchMyCartData();

      }
    } finally {}
  }

  //for updating cart rule and cart data
  void fetchMyCartData() async {
    isUpdating.value = true;
    getCityOrAreaId();
    var token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var endPoint = "";
    if (selectedCartRuleIds.isNotEmpty) {
      endPoint =
          "${AppStrings.myCartEndPoint}?coupon_id=${couponId.value}&shipping_id=${shippingMethodId.value}&cart_rule_ids=${selectedCartRuleIds.join(',')}&payment_method=${selectedPaymentMethod.value}&city_or_area_id=${cityOrAreaId.value}";
    } else {
      endPoint =
          "${AppStrings.myCartEndPoint}?coupon_id=${couponId.value}&shipping_id=${shippingMethodId.value}&cart_rule_ids=cart_rule_remove_all&payment_method=${selectedPaymentMethod.value}&city_or_area_id=${cityOrAreaId.value}";
    }
    try {
      var data = await RemoteServices.getRequest(endPoint, header);
      if (data != null) {
        myCartList.value = myCartModelFromJson(data);
        cartOfferProductsModule.value = [];
        otherModule.value = [];

        myCartList.value.selectedCartRules?.forEach((element) {
          if (element.targetModule == "product") {
            cartOfferProductsModule.add(element);
          } else {
            otherModule.add(element);
          }
        });
      }
    } finally {
      isLoading.value = false;
      isUpdating.value = false;
    }
  }

  void fetchUserData() async {
    // isLoading.value = true;
    const String endPoint = AppStrings.userInfoEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        userData.value = userDetailsModelFromJson(response);
        /*if (userData.value.prepayEnabled != 1) {
          selectedPaymentMethod.value = 1;
          paymentMethod.value = [
            {
              "id": 1,
              "name": "Pay By Cash On Delivery",
              "image_1": "assets/images/checkout_icons/Cash On Delivery.png",
            },
            {
              "id": 3,
              "name": "Pay By Bkash",
              "image_1": "assets/images/checkout_icons/bKash.png",
            },
            {
              "id": 2,
              "name": "Mastercard",
              "image_1": "assets/images/checkout_icons/Amex.png",
              "image_2": "assets/images/checkout_icons/mastercard.png",
              "image_3": "assets/images/checkout_icons/Visa.png",
            },
          ];
        }
        else {
          selectedPaymentMethod.value = 2;
          paymentMethod.value = [
            {
              "id": 2,
              "name": "Visa/ Master Card",
              "image_1": "assets/images/checkout_icons/Amex.png",
              "image_2": "assets/images/checkout_icons/mastercard.png",
              "image_3": "assets/images/checkout_icons/Visa.png",
            },
            {
              "id": 3,
              "name": "Pay By Bkash",
              "image_1": "assets/images/checkout_icons/bKash.png",
            }
          ];
        }*/
        // isLoading.value = false;
        fetchDistrictData();
      }
    } finally {
      //isLoading.value = false;
    }
  }

  void fetchDistrictData() async {
    isLoadingDistrict.value = true;
    const String endPoint = AppStrings.districtListEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        districtList.value = districtListModelFromJson(response);
/*        if (userData.value.cityId != null) {
          valueChooseDistrict.value = districtList.value[districtList.value
              .indexWhere((element) => element.id == userData.value.cityId)];
        }*/
        // fetchDistrictData();
        fetchAreaData();
        isLoadingDistrict.value = false;
      }
    } finally {
      isLoadingDistrict.value = false;
    }
  }

  void fetchAreaData() async {
    isLoadingArea.value = true;
    const String endPoint = AppStrings.areaListEndpoint;
    final token = await LocalServices.getToken() ?? "";
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        areaList.value = areaListModelFromJson(
            response); /*
        if (userData.value.areaId != null) {
          valueChooseArea.value = areaList.value[areaList.value
              .indexWhere((element) => element.id == userData.value.areaId)];
        }*/
        isLoadingArea.value = false;
        fetchDeliveryAddress();
      }
    } finally {
      isLoadingArea.value = false;
    }
  }

  void fetchDeliveryAddress() async {
    isLoadingArea.value = true;
    const String endPoint = AppStrings.deliveryAddressEndPoint;
    final String token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};

    try {
      var response = await RemoteServices.getRequest(endPoint, header);
      if (response != null) {
        addressList.value = deliveryAddressModelFromJson(response);
        isLoadingArea.value = false;

        if (addressList.isNotEmpty) {
          setDeliveryAddressFields(deliveryAddress: addressList.value[0]);
        }

        fetchShippingMethods();
      }
    } finally {
      isLoadingArea.value = false;
    }
  }

  void saveOrder() async {
    isUpdating.value = true;
    fetchShippingMethodId();

    final token = await LocalServices.getToken();
    const endPoint = AppStrings.placeOrderEndPoint;
    var header = {'Authorization': 'Bearer $token'};
    var body = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'mobile_number': phoneController.text,
      'address': addressController.text.toString(),
      'city': valueChooseDistrict.value.id.toString(),
      'area': (valueChooseDistrict.value.id.toString() == "1")
          ? valueChooseArea.value.id.toString()
          : "",
      'terms_and_conditions': termsANDConditionCB.value ? "1" : "0",
      'shipping_method': shippingMethodId.value,
      'payment_method': selectedPaymentMethod.toString(),
      for (int i = 0; i < (myCartList.value.cart?.length ?? 0); i++)
        'product_id[$i]': myCartList.value.cart![i].productId.toString(),
      for (int i = 0; i < (myCartList.value.cart?.length ?? 0); i++)
        'product_quantity[$i]': myCartList.value.cart![i].quantity.toString(),
      /*'order_delivery_address': isDeliveryAddress.value
          ? addressList[radioAddressValue.value].id.toString()
          : "",*/
      'order_delivery_address': "",
      for (int i = 0; i < (selectedCartRuleIds.length); i++)
        'cart_rule_ids[$i]': selectedCartRuleIds[i].toString(),
      'coupon': couponId.value,
      'comments': orderNoteController.text,
    };


    print("selectedPaymentMethod: $selectedPaymentMethod");

   // isUpdating.value = false;



//cash on delivery
    if (selectedPaymentMethod.value == 1) {
      try {
        var response = await RemoteServices.postRequest(endPoint, body, header);
        if (response != null) {
          myCartController.removedCardRuleIds = [];

          facebookAppEvents.logPurchase(
              amount: myCartList.value.couponData?.total?.toDouble() ?? 0.0,
              currency: "BDT",
              parameters: {
                "data": myCartModelToJson(myCartController.myCartList.value),
              });

          Get.offAllNamed("/home_page");

          Get.toNamed("/order_details", arguments: [
            response["order_id"].toString(),
            "0",
            DateTime.now(),
            myCartList.value.couponData?.total?.toStringAsFixed(2),
            ((myCartList.value.couponData?.regularDiscount ?? 0))
                .toStringAsFixed(2),
            (myCartList.value.couponData?.mobileAppSpecialDiscount ?? 0)
                .toStringAsFixed(2),
            "0",
            myCartList.value.couponData!.total.toString(),
            myCartList.value.cart!.length,
          ]);
          ShowSnackBar(msg: (response)["msg"], isSuccess: true).showSnackBar();

          //await LocalServices.storeItemsOnCart("0");

          await clearCart();

          // bottomNavigationBarController.itemsOnCart.value = 0;
          //myCartController.fetchMyCartData();


        } else {
          ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
              .showSnackBar();
        }
      } finally {
        isUpdating.value = false;
      }
    }

//SSL Commerz
    else if (selectedPaymentMethod.value == 2||selectedPaymentMethod.value == 5) {
      isUpdating.value = true;
      var orderId;
      try {
        var response = await RemoteServices.postRequest(endPoint, body, header);

        if (response != null) {
          orderId = ((response)["order"]["id"]);
          String cardPaymentEndPoint = couponId.value!=""
              ?"process-ssl-payment/$orderId/$couponId"
              :"process-ssl-payment/$orderId";
          var response2 =
              await RemoteServices.postRequestCardPayment(cardPaymentEndPoint);
          if (response2 != null && ((response2)["status"] == "success")) {
            Get.toNamed("/ssl_commerz_page", arguments: [
              (response2)["data"],
              {
                "data": myCartModelToJson(myCartController.myCartList.value),
              },
              myCartList.value.couponData?.total?.toDouble() ?? 0.0
            ]);
          }
        } else {
          ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
              .showSnackBar();
        }
      } finally {
        isUpdating.value = false;
      }
    }


/*    //Bkash
    else if (selectedPaymentMethod.value == 3||selectedPaymentMethod.value == 6) {
      isUpdating.value = true;
      try {
        var response = await RemoteServices.postRequest(endPoint, body, header);
        if (response != null) {
          // const oldTokenEndpoint=AppStrings.oldTokenEndPoint;
          var getOldToken = await RemoteServices.postRequest(
              "auth/old-auth-token", {"": ""}, header);
          if (getOldToken != null) {
            Navigator.of(Get.context!).push(MaterialPageRoute(
                builder: (context) => BkashPayment(
                      token: getOldToken["token"],
                      orderId: response["order_id"].toString(),
                      body: {
                        "data": myCartModelToJson(
                            myCartController.myCartList.value),
                      },
                    ),),
            );
          }
        } else {
          ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
              .showSnackBar();
        }
      } finally {
        isUpdating.value = false;
      }
    }*/

    // ================================================================
// bKash
// ================================================================

    else if (
    selectedPaymentMethod.value == 3 ||
        selectedPaymentMethod.value == 6
    ) {
      isUpdating.value = true;

      try {
        final response = await RemoteServices.postRequest(
          endPoint,
          body,
          header,
        );

        if (response != null) {
          final getOldToken =
          await RemoteServices.postRequest(
            "auth/old-auth-token",
            {"": ""},
            header,
          );

          if (getOldToken != null) {
            Navigator.of(
              Get.context!,
            ).push(
              MaterialPageRoute(
                builder: (context) {
                  return BkashPayment(
                    token: getOldToken["token"],
                    orderId: response["order_id"].toString(),
                    body: {
                      "data": myCartModelToJson(
                        myCartController.myCartList.value,
                      ),
                    },
                  );
                },
              ),
            );
          }
        } else {
          ShowSnackBar(
            msg: AppStrings.httpResponseMSG.value,
            isSuccess: false,
          ).showSnackBar();
        }
      } finally {
        isUpdating.value = false;
      }
    }


    else{
      isUpdating.value=false;
    }



  }

  void applyCoupon() async {
    const endPoint = AppStrings.applyCouponEndPoint;
    var couponCode = couponCodeController.text;
    isUpdating.value = true;
    final token = await LocalServices.getToken() ?? "";
    var header = {'Authorization': 'Bearer $token'};
    var body = {
      "coupon_code": couponCode,
      "shipping_method": shippingMethodId.value,
      "sub_total": myCartList.value.couponData?.couponTotal.toString(),
    };

    try {
      var response = await RemoteServices.postRequest(endPoint, body, header);
      if (response != null) {
        couponId.value = response["coupon_id"].toString();
        ShowSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
        //isUpdating.value=false;
        // fetchMyCartData();
        loadCartData();
      } else {
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
            .showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void fetchShippingMethodId() {
    var selectedDistrict = "";
    // isLoading.value = false;
    if (isDeliveryAddress.value) {
      selectedDistrict =
          addressList[(radioAddressValue.value)].district.toString();
    }

    if (selectedDistrict.isNotEmpty) {
      if (selectedDistrict == "1") {
        shippingMethodId.value = "1";

        valueChooseDistrict.value = districtList
            .value[districtList.value.indexWhere((element) => element.id == 1)];
        valueChooseArea.value = areaList.value[areaList.value.indexWhere(
            (element) =>
                element.id == addressList[(radioAddressValue.value)].area)];

        cityOrAreaId.value =
            addressList[(radioAddressValue.value)].area.toString();
      } else {
        shippingMethodId.value = "2";
        cityOrAreaId.value =
            addressList[(radioAddressValue.value)].district.toString();

        valueChooseDistrict.value = districtList.value[districtList.value
            .indexWhere((element) =>
                element.id == addressList[(radioAddressValue.value)].district)];
        //  valueChooseArea.value=areaList.value[areaList.value.indexWhere((element) => element.id==addressList[(radioAddressValue.value)].area)];
      }
    } else {
      if (valueChooseDistrict.value.id != null) {
        valueChooseDistrict.value.id.toString() == "1"
            ? shippingMethodId.value = "1"
            : shippingMethodId.value = "2";
      } else {
        shippingMethodId.value = "";
      }
    }

    /// fetchMyCartData();
    // getDeliveryCharge();
  }

  /* void getDeliveryCharge() {
    var charge = shippingMethods
            .value[shippingMethods.value.indexWhere(
                (element) => shippingMethodId == element.id.toString())]
            .amount ??
        0;

    if (charge == 0) {
      shippingCharge.value = "Free Shipping";
    } else {
      shippingCharge.value = "+ ৳${charge.toStringAsFixed(2)}";
    }

    print(shippingCharge.value);
  }*/

  void removeCoupon() async {
    isUpdating.value = true;
    couponId.value = "";
    // ShowSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
    loadCartData();
    // fetchMyCartData();
  }

  void getCityOrAreaId() {
    if (valueChooseDistrict.value.id.toString() == "1") {
      cityOrAreaId.value = valueChooseArea.value.id.toString();
    } else {
      cityOrAreaId.value = valueChooseDistrict.value.id.toString();
    }
  }

  void resetAreaOrCityId() {
    if (userData.value.cityId != null) {
      valueChooseDistrict.value = districtList.value[districtList.value
          .indexWhere((element) => element.id == userData.value.cityId)];
    }
    if (userData.value.areaId != null) {
      valueChooseArea.value = areaList.value[areaList.value
          .indexWhere((element) => element.id == userData.value.areaId)];
    }

    getCityOrAreaId();
  }

  void setDeliveryAddressFields(
      {required DeliveryAddressModel deliveryAddress}) {
    firstNameController.text = deliveryAddress.firstName ?? "";
    lastNameController.text = deliveryAddress.lastName ?? "";
    phoneController.text = deliveryAddress.phone ?? "";
    addressController.text = deliveryAddress.address ?? "";

    valueChooseDistrict.value = districtList.value[districtList
        .indexWhere((element) => element.id == deliveryAddress.district)];


    if (deliveryAddress.district == 1) {
      valueChooseArea.value = areaList.value[
          areaList.indexWhere((element) => element.id == deliveryAddress.area)];
    }
    fetchShippingMethodId();
    fetchMyCartData();
  }


  void resetFields(){
     myCartList.value = MyCartModel();
     shippingMethods.value =[];

     shippingMethodId.value = "";
     shippingCharge.value = "";
     isDeliveryAddress.value = false;

     cartOfferProductsModule.value = [];
     otherModule.value = [];
     allModule.value = [];

     radioAddressValue.value = 0;

     paymentMethodRadio.value = 0;
     selectedPaymentMethod.value = 0;

     termsANDConditionCB.value = true;
     isLoadingDistrict.value = true;
     isLoadingArea.value = true;

    // var isLoadingArea = false.obs;
     isUpdating.value = false;
     couponId.value = "";

    //var isLoadingDistrict = false.obs;
     isLoadingAddress.value = false;
     userData.value = UserDetailsModel();
     areaList.value = [];
     districtList.value =[];
     addressList.value = [];
     valueChooseArea.value = AreaListModel();
     valueChooseDistrict.value = DistrictListModel();

     firstNameController.text = "";
     lastNameController.text = "";
     emailController.text = "";
     phoneController.text = "";
     addressController.text = "";
     dateInputController.text = "";
     orderNoteController.text = "";
     couponCodeController.text = "";
    //for cart rule
     selectedCartRuleIds.value = [];
     myCartRuleIds.value = [];
     removedCartRuleIds.value = [];
  }




  void getPaymentMethods(){
    print("Paymentmethod is calling.......");

    if ((myCartList.value.partialPaymentStatus??0)!=1) {
      if (userData.value.prepayEnabled != 1) {
        selectedPaymentMethod.value = 1;
        paymentMethod.value = [
          {
            "id": 1,
            "name": "Cash On Delivery",
            "image_1": "assets/images/checkout_icons/money-hand.png",
          },
          {
            "id": 3,
            "name": "Pay By bKash",
            "image_1": "assets/images/checkout_icons/bKash.png",
          },
          {
            "id": 2,
            "name": "Pay By Card",
            "image_1": "assets/images/checkout_icons/atm-card.png",
            "image_2": "assets/images/checkout_icons/mastercard.png",
            "image_3": "assets/images/checkout_icons/Visa.png",
          },
        ];
      }
      else {
        selectedPaymentMethod.value = 2;
        paymentMethod.value = [
          {
            "id": 2,
            "name": "Pay By Card",
            "image_1": "assets/images/checkout_icons/atm-card.png",
            "image_2": "assets/images/checkout_icons/mastercard.png",
            "image_3": "assets/images/checkout_icons/Visa.png",
          },
          {
            "id": 3,
            "name": "Pay By bKash",
            "image_1": "assets/images/checkout_icons/bKash.png",
          }
        ];
      }
    }
    else{
      selectedPaymentMethod.value = 3;
      paymentMethod.value = [

        {
          "id": 3,
          "name": "Pay By bKash (Full)",
          "image_1": "assets/images/checkout_icons/bKash.png",
        },
        {
          "id": 6,
          "name": "Partial Pay By bKash (${myCartList.value.partialPaymentAmount??0} BDT)",
          "image_1": "assets/images/checkout_icons/bKash.png",
        },
        {
          "id": 2,
          "name": "Mastercard (Full)",
          "image_1": "assets/images/checkout_icons/atm-card.png",
          "image_2": "assets/images/checkout_icons/mastercard.png",
          "image_3": "assets/images/checkout_icons/Visa.png",
        },
        {
          "id": 5,
          "name": "Partial Mastercard (${myCartList.value.partialPaymentAmount??0} BDT)",
          "image_1": "assets/images/checkout_icons/atm-card.png",
          "image_2": "assets/images/checkout_icons/mastercard.png",
          "image_3": "assets/images/checkout_icons/Visa.png",
        },
      ];
    }
  }

  Future<void> clearCart() async {
    await LocalServices.storeCartItem([]).then((value) async {
      fetchMyCartData();
      myCartList.value = MyCartModel();
      myCartController.myCartList.value=MyCartModel();
      AppReviewService.openRatingDialog();
      resetFields();
      Get.put(BottomNavigationBarController()).getCartItems();
    });
  }
}
