import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/social_login_controller.dart';
import '../../../controllers/user_controllers/get_otp_controller.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/customDivider.dart';


class LoginPhonePage extends StatelessWidget {
  LoginPhonePage({super.key});

  final GetOTPController getOTPController = Get.put(
    GetOTPController(),
  );
  final SocialLoginController socialLoginController=Get.put(SocialLoginController());
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // return UserScreenBackground(body: bodyContent());
    return SafeArea(
      child: Scaffold(
        // backgroundColor:const Color(0xffeeeeee) ,
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "LOGIN",
            color: Colors.white,
          ),
        ),
        body: Obx(() => Stack(
          children: [
            bodyContent(),
            if(getOTPController.isLoading.value||socialLoginController.isLoading.value)Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(),),),
          ],
        )),

      ),
    );
  }

  Widget phoneTextField() {
    return Container(
      color: Colors.white,
      child: Center(
        child: TextFormField(
          onChanged:(s){
            _otpFormKey.currentState!.validate();
          },
          controller: getOTPController.phoneController,
          validator: (value) {
            if(value!.length>2&&
                (value.isEmpty||
                !value.startsWith("0")||
                value[1]!="1"||
                value[2]=="1"||
                value[2]=="2"||
                !value.isNumericOnly||
                value.length<11) ) {
              return 'Please enter valid phone number';
            }
            return null;
          },
          maxLength: 11,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.phone,
          cursorColor: AppColors.mainColorRed,
          cursorWidth: .5,
          decoration: InputDecoration(
            /* border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),*/
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                      height: 24.h,
                      image: const AssetImage("assets/icon/flag.png")),
                  SizedBox(
                    width: 20.w,
                  ),
                  HeaderText(
                    text: "+88 ",
                    align: TextAlign.start,
                    size: 18,
                  )
                ],
              ),
            ),
            // labelText: "login with your phone",
            hintText: "login with your phone",
            // labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.red,
            hoverColor: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
            ),
            HeaderText(
              text: 'Sign in with',
              fontWeight: FontWeight.w500,
              size: 18,
              color: Colors.black,
            ),
            SizedBox(
              height: 20.h,
            ),


            //Social login start
            Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: (){
                  socialLoginController.googleLogin();
                },
                leading: Image.asset("assets/icon/google_2.png"),
                title: HeaderText(
                  text: "Sign In With Google",
                  fontWeight: FontWeight.bold,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),

            const CustomDivider(
              text: "OR",
            ),
            //facebook login
            Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: (){
                  socialLoginController.facebookLogin();
                },
                leading: Image.asset("assets/icon/facebook.png"),
                title: HeaderText(
                  text: "Sign In With Facebook",
                  fontWeight: FontWeight.bold,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),

            // apple login
            if(Platform.isIOS)...[const CustomDivider(
              text: "OR",
            ),
              Card(
                elevation: 2,
                margin: const EdgeInsets.all(0),
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  onTap: (){
                    socialLoginController.appleLogin();
                  },
                  leading: Image.asset("assets/icon/apple-logo.png",height: 36,),
                  title: HeaderText(
                    text: "Sign In With Apple",
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),],

            const CustomDivider(
              text: "OR",
            ),
            SizedBox(
              height: 10.h,
            ),
            //Social login end


            Align(
              alignment: Alignment.centerLeft,
              child: HeaderText(
                text: "PHONE NUMBER",
              ),
            ),
            loginForm(),
            //Login By Email Button
            SizedBox(
              height: 50.h,
              child: InkWell(
                onTap: () {
                  Get.toNamed('/login_email_page');
                },
                child: AppButton(
                  alignment: MainAxisAlignment.center,
                  text: 'LOGIN BY EMAIL',
                  textColor: Colors.black,
                  bgColor: Colors.white,
                  align: TextAlign.center,
                  textSize: 18,
                  fontWeight: FontWeight.normal,
                  border: Border.all(width: 1, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 50.h,
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    '/registration_page',
                  );
                },
                child: AppButton(
                  alignment: MainAxisAlignment.center,
                  text: 'NEW? REGISTER HERE!',
                  textColor: Colors.white,
                  bgColor: AppColors.mainColorRed,
                  align: TextAlign.center,
                  textSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: (){
                    Get.toNamed("/dynamic_page_list");
                  },
                  child: SizedBox(
                    child: HeaderText(
                      text: "Need Help?".toUpperCase(),
                      size: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          phoneTextField(),
          SizedBox(
            height: 5.h,
          ),

          //login Button
          SizedBox(
            height: 50.h,
            child: InkWell(
              onTap: () {

                if(_otpFormKey.currentState!.validate()) {
                  getOTPController.requestOTP();
                }
                /*  if (_formKey.currentState!.validate()) {
                  print(_phoneController.text);
                  getOTPController.fetchData("+880${_phoneController.text}");
                 if(!getOTPController.isLoading.value) Get.toNamed('/otp_screen', arguments: "+880${_phoneController.text}");
                }*/
              },
              child: AppButton(
                alignment: MainAxisAlignment.center,
                text: 'LOGIN',
                textColor: Colors.white,
                bgColor: Colors.black,
                align: TextAlign.center,
                textSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

/*  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Card(
              elevation: 5,
              child: Image(
                  height: 50.h,
                  image: const AssetImage("assets/logo/logo.jpg")),
            ),
            SizedBox(
              height: 20.h,
            ),
            phoneTextField(),
            SizedBox(
              height: 20.h,
            ),

            //login Button
            SizedBox(
              height: 50.h,
              child: InkWell(
                onTap: (){
                  Get.toNamed('/otp_screen',arguments: "+8801748910502");
                },
                child: AppButton(
                  alignment: MainAxisAlignment.center,
                  text: 'LOGIN',
                  textColor: Colors.white,
                  bgColor: Colors.black.withOpacity(.8),
                  align: TextAlign.center,
                  textSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            const CustomDivider(),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //google Button
                InkWell(
                  onTap: () {
                    Get.toNamed("/user_info_page");
                  },
                  child: CircularButton(
                    child: Image.asset("assets/icon/google_2.png"),
                    circleColor: Colors.red,
                    bgColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                //Facebook Button
                InkWell(
                  child: CircularButton(
                    child: Image.asset("assets/icon/btn-facebook.png"),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                // Button
                InkWell(
                  onTap: () {
                    Get.offAndToNamed("/login_email_page");
                  },
                  child: CircularButton(
                    child: const Icon(
                      Icons.email_outlined,
                      color: AppColors.mainColorRed,
                    ),
                    circleColor: AppColors.mainColorRed,
                    bgColor: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeaderText(
                    text: "Don't have an Account?",
                    align: TextAlign.center),
                InkWell(
                  onTap: () {
                    Get.offAndToNamed("/registration_page");
                  },
                  child: const Text(
                    "Register Here!",
                    style: TextStyle(
                        color: AppColors.mainColorRed,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }*/
}
