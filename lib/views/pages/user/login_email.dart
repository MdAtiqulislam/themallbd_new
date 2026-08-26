import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/social_login_controller.dart';
import '../../../controllers/user_controllers/login_email_controller.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/customDivider.dart';

class LoginEmail extends StatelessWidget {
  LoginEmail({super.key});

  final LoginEmailController loginEmailController =
      Get.put(LoginEmailController());
  final SocialLoginController socialLoginController=Get.put(SocialLoginController());
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        body: bodyContent(),
      ),
    );
    // return UserScreenBackground(body: bodyContent());
  }

  Widget emailTextField() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 10.h),
              child: const Text("Email Address"),
            ),
            TextFormField(
              controller: loginEmailController.emailController,
              validator: (value) {
                if (value!.isEmpty || !value.isEmail) {
                  return "Please enter valid Email";
                }
                return null;
              },
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.emailAddress,
              cursorColor: AppColors.mainColorRed,
              cursorWidth: .5,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, bottom: 10),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                // labelText: "login with your phone",
                hintText: "example@abc.com",
                // labelStyle: const TextStyle(color: Colors.black),
                fillColor: Colors.red,
                hoverColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0.w, top: 10.h),
              child: const Text("Password"),
            ),
            TextFormField(
              controller: loginEmailController.passwordController,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return "Password should be minimum 6 characters";
                }
                return null;
              },
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.mainColorRed,
              cursorWidth: .5,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, bottom: 10),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                // labelText: "login with your phone",
                hintText: "Your Password",
                // labelStyle: const TextStyle(color: Colors.black),
                fillColor: Colors.red,
                hoverColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Obx(
      () => Stack(
        children: [
          SingleChildScrollView(
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
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(0),
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
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.all(0),
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


                  loginForm(),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 50.h,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/login_page');
                      },
                      child: AppButton(
                        alignment: MainAxisAlignment.center,
                        text: 'LOGIN BY PHONE',
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
                    height: 20.h,
                  ),
                  InkWell(
                      onTap: () {
                        Get.toNamed("/password_reset_page");
                      },
                      child: HeaderText(
                        text: "Forgot Password?".toUpperCase(),
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        size: 18,
                      )),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                        Get.toNamed("/dynamic_page_list");
                      },
                        child: HeaderText(
                          text: "Need Help?".toUpperCase(),
                          size: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ))
                ],
              ),
            ),
          ),
          if (loginEmailController.isLoading.value)
            Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          emailTextField(),
          passwordTextField(),
          SizedBox(
            height: 5.h,
          ),
          //login Button
          SizedBox(
            height: 50.h,
            child: InkWell(
              onTap: () {
                if(_emailFormKey.currentState!.validate()) {
                  loginEmailController.submitForm();
                }
                // Get.toNamed('/otp_screen', arguments: "+8801748910502");
              },
              child: const AppButton(
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
        ],
      ),
    );
  }

}
