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

class RegistrationController extends GetxController{
  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  final emailController=TextEditingController();
  final phoneController=TextEditingController();
  final passwordController=TextEditingController();
  final reTypePasswordController=TextEditingController();
  //GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var endPoint = AppStrings.getSignUpEndPoint;

  var response=SignUpResponseModel().obs;


  @override
  void dispose(){
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    reTypePasswordController.dispose();
    super.dispose();
  }






  void fetchData() async{
    isLoading.value = true;
    AppStrings.httpResponseMSG.value="";
    String firstName=firstNameController.text;
    String lastName=lastNameController.text;
    String email=emailController.text;
    String phone=phoneController.text;
    String password=passwordController.text;
    String rePassword=reTypePasswordController.text;

    var header={"":""};
    var body={
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'phone':phone,
      'password':password,
      'password_confirmation':rePassword
    };
    try {
      var data = await RemoteServices.postRequest(endPoint, body, header);
      if (data != null) {
        response.value = SignUpResponseModel.fromJson(data);
        //AppStrings.httpResponseMSG.value = response.value.msg!;
        isLoading.value = false;
        await LocalServices.storeToken(response.value.data?.token??"");
        await LocalServices.storeUser(response.value.data!.user!);
        ShowSnackBar( msg:response.value.msg!,isSuccess: true).showSnackBar();
        openUserInfoScreen();
      }else{
        ShowSnackBar( msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }

  }

  void submitForm() {
      fetchData();
  }

  void openUserInfoScreen(){
    upLoadCartItems();
    Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute(builder: (BuildContext context) => UserInfoPage()),
        ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
    );

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
    //storeItemsOnCartToLocal();
  }
}