import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../models/user_models/user_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';

class ResetPasswordController extends GetxController{

  var token="".obs;
  var user=UserModel().obs;
  var isLoading=false.obs;
  var email="".obs;

  final emailController=TextEditingController();
  @override
  void onInit() async{
    // TODO: implement onInit
    getToken();
    getUser();
    super.onInit();
  }

  void resetPassword()async{
    isLoading.value=true;
    const String endPoint=AppStrings.resetPasswordEndPoint;
   var body={"email":emailController.text};
   var header={'Authorization': 'Bearer $token'};

    try{
     var response=await RemoteServices.postRequest(endPoint, body, header);
     if(response!=null){
       isLoading.value=false;
       Get.back();
       ShowSnackBar(msg: response["msg"],isSuccess: true).showSnackBar();

     }else{
       ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
     }
    }finally{
      isLoading.value=false;
    }

  }

  void getToken() async{
     token.value=await LocalServices.getToken()??"";
  }

  void getUser() async{
     user.value=await LocalServices.getUser()??UserModel();
     email.value=user.value.email??"";
     if(email.value.isNotEmpty){
       emailController.text=email.value;
     }
  }
}