import 'package:get/get.dart';

import '../models/area_list_model.dart';
import '../models/cart_model.dart';
import '../models/district_list_model.dart';
import '../services/local_services.dart';
import '../utils/show_snack_bar.dart';
import 'check_out_controller.dart';
import 'my_cart_controller.dart';


class BottomNavigationBarController extends GetxController {
  var cartItems = <CartModel>[].obs;
  var itemsOnCart = 0.obs;
  @override
  void onInit() async {
    getCartItems();
    super.onInit();
  }



 Future <void> getCartItems() async {
    /*var token = await LocalServices.getToken() ?? "";
    if (token.isEmpty||token==null) {
      cartItems.value = (await LocalServices.getCartItems()) ?? [];
     // itemsOnCart.value = cartItems.value.length;
      cartItems.map((element) {
        print("Cart Items: ${element.product_quantity}");
         itemsOnCart.value+=int.parse(element.product_quantity??"0");
      });
    }
    else {
      itemsOnCart.value =
          int.parse((await LocalServices.getItemsOnCart() ?? "0"),);
    }*/

   // cartItems.value = (await LocalServices.getCartItems()) ?? [];
    await LocalServices.getCartItems().then((value) {
      itemsOnCart.value=0;
     // partialPaymentStatus=value.
     if((value??[]).isNotEmpty){
       for (var element in value!) {
         itemsOnCart.value+=int.parse(element.product_quantity??"0");
       }
     }
    });
    // itemsOnCart.value = cartItems.value.length;

  }



  void openCheckoutPage() async{
    bool problemInCart = false;
    MyCartController myCartController = Get.put(
      MyCartController(),
    );
    //myCartController.fetchMyCartData();



   await getCartItems().then((value) {
     if (itemsOnCart.value >= 1 && !myCartController.isLoading.value && (myCartController.myCartList.value.cart?.length??0)>0) {
       myCartController.myCartList.value.cart?.forEach((element) {
         if (element.status == 0 ||
             element.available == 0 ||
             (element.available ?? 0) < (element.quantity ?? 0)) {
           problemInCart = true;
         }
       });

       if (problemInCart) {
         ShowSnackBar(
             msg:
             'You have to remove or update some products from your cart to continue.',
             isSuccess: false)
             .showSnackBar();
       } else {
         if (!myCartController.isLoading.value &&
             !myCartController.isUpdating.value &&
             !myCartController.isReloading.value &&
             (myCartController.myCartList.value.cart?.length ?? 0) > 0) {




           final checkoutController =Get.put(CheckOutController());
           checkoutController.resetFields();
           checkoutController.removedCartRuleIds.value=myCartController.removedCardRuleIds;
           // checkoutController.preLoadCartData();
           checkoutController.fetchUserData();
           checkoutController.valueChooseDistrict.value=DistrictListModel();
           checkoutController.valueChooseArea.value=AreaListModel();
           //checkoutController.val
           Get.toNamed("/check_out_page");
         }
       }
     } else {
       Get.closeAllSnackbars();
       if(myCartController.myCartList.value.cart?.length==itemsOnCart.value){
         ShowSnackBar(
             isWarning: true,
             title: "Oops!",
             msg:
             "Your Cart is Empty! Please add some product to cart and continue.")
             .showSnackBar();
       }
     }
   });
  }
}
