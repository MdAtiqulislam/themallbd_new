import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/app_strings.dart';
import '../../models/user_models/order_history_model.dart';
import '../../models/user_models/user_model.dart';
import '../../models/user_models/user_privileges_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';
import '../bottom_navigation_bar_controller.dart';

class UserInfoController extends GetxController {
  int i = 0;

  var isLoading = false.obs;
  var isLoadingPrivileges = true.obs;
  List<OrderHistoryModel>? orderHistoryModel;

  // var dynamicPageList=<DynamicPageListModel>[].obs;
 static var myMessages = <RemoteMessage>[].obs;
  var token = "".obs;
 static var user = UserModel().obs;
  var userPrivileges = UserPrivilegesModel().obs;
  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());

  var ipPrivilegesStatus=false.obs;

  void fetchData() {
    getUser();
    //upLoadCartItems();
    getVipPrivileges();
    // fetchDynamicPageList();
  }

 static void getUser() async {
    user.value = (await LocalServices.getUser().then((value) async {
          myMessages.value = (await LocalServices.getMyMessages()) ?? [];
          return null;
        })) ??
        UserModel();
  }

  void getVipPrivileges() async {
    await LocalServices.getVipPrivilege().then((value) async {
      ipPrivilegesStatus.value=value;
      if(value){
        token.value = await LocalServices.getToken() ?? "";
        const endPoint = AppStrings.userPrivilegesEndPoint;
        var header = {'Authorization': 'Bearer ${token.value}'};
        try {
          var data = await RemoteServices.getRequest(endPoint, header);
          if (data != null) {
            userPrivileges.value = userPrivilegesModelFromJson(data);
            isLoadingPrivileges.value = false;
          }
        } finally {
          isLoadingPrivileges.value = false;
        }
      }

    });
     isLoadingPrivileges.value=false;
  }

  /*void fetchDynamicPageList() async{
   // isLoading.value=true;
    var endPoint=AppStrings.dynamicPageListEndPoint;
     var data=await RemoteServices.getRequest(endPoint, {"":""});
     try {
       if(data!=null){
         dynamicPageList.value=dynamicPageListModelFromJson(data);
        // isLoading.value=false;
       }
       else{
         ShowSnackBar(msg:(AppStrings.httpResponseMSG.value).isEmpty?"Too Many Request!":AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
       }
     } finally {
       // TODO
      // isLoading.value=false;
     }
  }*/

  void upLoadCartItems() async {
    //  final MyCartController myCartController=Get.put(MyCartController());
    var cartList = await LocalServices.getCartItems() ?? [];

    if (cartList.isNotEmpty) {
      var body = {
        for (int i = 0; i < cartList.length; i++)
          'product_id[$i]': cartList[i].product_id,
        for (int i = 0; i < cartList.length; i++)
          'product_quantity[$i]': cartList[i].product_quantity,
      };
      token.value = await LocalServices.getToken() ?? "";
      const endPoint = AppStrings.addAllCartItemsEndPoint;
      var header = {'Authorization': 'Bearer ${token.value}'};
      var data = await RemoteServices.postRequest(endPoint, body, header);
      if (data != null) {
        await LocalServices.storeCartItem([]);
      }
    }
    // myCartController.fetchMyCartData();

    bottomNavigationBarController.getCartItems();
    // bottomNavigationBarController.itemsOnCart.value=int.parse(await LocalServices.getItemsOnCart()??"0");
    //storeItemsOnCartToLocal();
  }

  void logOut() async {
    await LocalServices.deleteData();
    bottomNavigationBarController.getCartItems();
    // bottomNavigationBarController.itemsOnCart.value=int.parse(await LocalServices.getItemsOnCart()??"0");
    Navigator.of(Get.context!).popUntil(ModalRoute.withName('/'));
    Get.toNamed('/login_page');
    orderHistoryModel = [];
    // dynamicPageList.value=[];
    token.value = "";
    user.value = UserModel();
    userPrivileges.value = UserPrivilegesModel();
  }

  void deleteAccount() {
    Get.defaultDialog(
      title: "Confirmation",
      middleText:
          "Do you really want to delete your account? All your purchase histories will be removed.",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: AppColors.bodyTextColor),
      textConfirm: "Yes",
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.mainColorRed,
      barrierDismissible: false,
      radius: 5,
      onConfirm: () async {
        token.value = await LocalServices.getToken() ?? "";
        const endPoint = AppStrings.deleteAccountEndPoint;
        var header = {'Authorization': 'Bearer ${token.value}'};
        try {
          var data =
              await RemoteServices.postRequest(endPoint, {"": ""}, header);
          if (data != null) {
            Get.back();
            ShowSnackBar(msg: data["msg"], isSuccess: true).showSnackBar();
            logOut();
            //userPrivileges.value=userPrivilegesModelFromJson(data);
            isLoadingPrivileges.value = false;
          }
        } finally {
          isLoadingPrivileges.value = false;
        }
      },
      // onCancel: () => Get.back(),
    );
  }

/*  void storeItemsOnCartToLocal() async{
    token.value=await LocalServices.getToken()??"";
    var header={'Authorization': 'Bearer ${token.value}'};
    var myCart=MyCartModel();

    var endPoint=AppStrings.myCartEndPoint;

    var data=await RemoteServices.getRequest(endPoint, header);

    if(data!=null){

      myCart=myCartModelFromJson(data);
      await LocalServices.storeItemsOnCart(myCart.cart!.length.toString());
      print((myCart.cart!.length.toString()));
    }


  }*/
}
