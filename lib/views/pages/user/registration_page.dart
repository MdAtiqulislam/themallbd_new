import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/social_login_controller.dart';
import '../../../controllers/user_controllers/registration_controller.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/customDivider.dart';

class Registration extends StatelessWidget {
  Registration({Key? key}) : super(key: key);

  final RegistrationController registrationController =
      Get.put(RegistrationController());
  final SocialLoginController socialLoginController=Get.put(SocialLoginController());
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "Registration".toUpperCase(),
            color: Colors.white,
          ),
        ),
        body: bodyContent(),
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
                  if(!Platform.isIOS)...[const CustomDivider(
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

                  registrationForm(),
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
                          Get.toNamed('/login_email_page');
                        },
                      child: AppButton(
                        alignment: MainAxisAlignment.center,
                        text: 'login By Email'.toUpperCase(),
                        textColor: Colors.white,
                        bgColor: Colors.black,
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
                        child: HeaderText(
                          text: "Need Help?".toUpperCase(),
                          size: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),)
                ],
              ),
            ),
          ),
          if (registrationController.isLoading.value)
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

  Widget firstNameTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "First Name Field is Required";
              } else {
                return null;
              }
            },
            controller: registrationController.firstNameController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              /*  border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),*/
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColorRed),
              ),
              // prefixIcon: Icon(Icons.account_circle_rounded),
              // labelText: "Enter Your First Name",
              hintText: "First Name",
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget lastNameTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            controller: registrationController.lastNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Last Name Is Required";
              }
              return null;
            },
            keyboardType: TextInputType.name,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              /*border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),*/
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              //prefixIcon: Icon(Icons.account_circle_rounded),
              // labelText: "Enter Your Last Name",
              hintText: "Last Name",
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget phoneTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            maxLength: 11,
            controller: registrationController.phoneController,
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
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: InputDecoration(
              /*border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),*/
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
              hintText: "Phone Number",
              labelStyle: const TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget emailTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            controller: registrationController.emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              /* border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),*/
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              //prefixIcon: Icon(Icons.email_outlined),
              //labelText: "Enter Email Address",
              hintText: "Email address",
              // labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            controller: registrationController.passwordController,
            validator: (value) {
              if (value!.length < 6) {
                return "Password should be minimum 6 characters";
              }
              return null;
            },
            obscureText: true,
            //keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              //prefixIcon: Icon(Icons.lock),
              // labelText: "Enter Password",
              hintText: "Password",
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }



  Widget rePasswordTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            controller: registrationController.reTypePasswordController,
            validator: (value) {
              if (value!.length < 6) {
                return "Password should be minimum 6 characters";
              } else if (value !=
                  registrationController.passwordController.text) {
                return "Password should Match";
              }
              return null;
            },
            obscureText: true,
            //keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 10),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              //  prefixIcon: Icon(Icons.lock),
              // labelText: "Re-Type Password",
              hintText: "Re-type Password",
              //  labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.red,
              hoverColor: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  Widget registrationForm() {
    return Form(
      key: _registrationFormKey,
      child: Column(
        children: [
          firstNameTextField(),
          lastNameTextField(),
          phoneTextField(),
          emailTextField(),
          passwordTextField(),
          rePasswordTextField(),
          SizedBox(
            height: 5.h,
          ),
          //submit Button
          SizedBox(
            height: 50.h,
            child: InkWell(
              onTap: () {
                if(_registrationFormKey.currentState!.validate()) {
                  registrationController.submitForm();
                }
                //Get.toNamed('/otp_screen', arguments: "+8801748910502");
              },
              child: AppButton(
                alignment: MainAxisAlignment.center,
                text: 'Register'.toUpperCase(),
                textColor: Colors.white,
                bgColor: AppColors.mainColorRed,
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
