import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constraints/app_strings.dart';
import '../../models/user_models/sign_up_response_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';

import '../../utils/show_snack_bar.dart';
import '../../views/pages/user/user_info_page.dart';
import '../bottom_navigation_bar_controller.dart';
import '../my_cart_controller.dart';


class LoginEmailController extends GetxController{
  final emailController =TextEditingController();
  final passwordController=TextEditingController();
  //GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final endPoint=AppStrings.emailLoginEndpoint;

  var isLoading=false.obs;
  var response=SignUpResponseModel().obs;


  @override
  void dispose(){
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }


  void fetchData() async{
    isLoading.value = true;
    AppStrings.httpResponseMSG.value="";
    String email=emailController.text;
    String password=passwordController.text;

    var header={"":""};
    var body={
      'email':email,
      'password':password,
    };
    try {
      var data = await RemoteServices.postRequest(endPoint, body, header);
      if (data != null) {
        response.value = SignUpResponseModel.fromJson(data);
       // AppStrings.httpResponseMSG.value = response.value.msg!;
        isLoading.value = false;
        await LocalServices.storeToken(response.value.data?.token??"");
        await LocalServices.storeUser(response.value.data!.user!);
        ShowSnackBar( msg:response.value.msg!,isSuccess: true).showSnackBar();


        upLoadCartItems();


        openUserInfoScreen();
      }else{
        ShowSnackBar( msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    } finally {
      isLoading.value = false;

    }

  }
  void openUserInfoScreen(){
    Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (BuildContext context) => UserInfoPage()),
        ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
    );
  }
  void submitForm() {
    fetchData();
  }


  void upLoadCartItems() async{
      final MyCartController myCartController=Get.put(MyCartController());
    var cartList=await LocalServices.getCartItems()??[];

    if(cartList.isNotEmpty){
      var body={
        for(int i=0;i<cartList.length;i++)'product_id[$i]':cartList[i].product_id ,
        for(int i=0;i<cartList.length;i++)'product_quantity[$i]':cartList[i].product_quantity ,
      };
      String token;
      token=await LocalServices.getToken()??"";
      const endPoint=AppStrings.addAllCartItemsEndPoint;
      var header={'Authorization': 'Bearer $token'};
      var data=await RemoteServices.postRequest(endPoint, body, header);
      if(data!=null){
        await LocalServices.storeCartItem([]);
      }
    }
     myCartController.fetchMyCartData();
    BottomNavigationBarController bottomNavigationBarController=Get.put(BottomNavigationBarController());
    bottomNavigationBarController.getCartItems();


   // bottomNavigationBarController.itemsOnCart.value=int.parse(await LocalServices.getItemsOnCart()??"0");
    // storeItemsOnCartToLocal();
  }
}