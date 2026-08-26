import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constraints/app_strings.dart';
import '../../models/user_models/request_otp_response_model.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';


class GetOTPController extends GetxController {
  var response = RequestOtpResponseModel().obs;
  var isLoading = false.obs;
  var endPoint = AppStrings.getOTPEndPoint;
  //GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();


  @override
  void dispose(){
    phoneController.dispose();
    super.dispose();
  }

  void fetchData(String phoneNumber) async {
  String encryptedMSG=await AppStrings.encryptedMSG();
  print("encryptedMSG: $encryptedMSG");
  AppStrings.httpResponseMSG.value="";

    var header = {'Otp-Token': encryptedMSG};
    var body = {'phone_number': phoneNumber};
    isLoading.value = true;
    try {
      var data = await RemoteServices.postRequest(endPoint, body, header);
      if (data != null) {
        response.value = RequestOtpResponseModel.fromJson(data);
        ShowSnackBar(msg:response.value.msg??"",isSuccess: true).showSnackBar();
       // AppStrings.httpResponseMSG.value = response.value.msg!;
        isLoading.value = false;
        openOTPScreen();
      }else{
        ShowSnackBar(msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    }  finally {

      isLoading.value = false;
    }
  }

  void openOTPScreen() {
    Get.toNamed('/otp_screen', arguments: "+88${phoneController.text}");
  }

  void requestOTP() {
    fetchData("+88${phoneController.text}");
  }
}
