import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/reset_password_controller.dart';
import '../../../widgets/app_button.dart';

class PasswordResetPage extends StatelessWidget {
  PasswordResetPage({super.key});
  final ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            text: 'Forget Password',
            color: Colors.white,
          ),
        ),
        body: Obx(() => bodyContent()),
      ),
    );

    /*UserScreenBackground(
      body: bodyContent(),
    );*/
  }

  Widget bodyContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderText(
                  text: "Please insert your registered email address"
                      " and we will send password reset "
                      "link to your email.",
                  fontWeight: FontWeight.w500,
                  size: 15,
                  maxLine: 4,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: HeaderText(text: 'E-mail'),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      emailTextField(),
                      SizedBox(
                        height: 20.h,
                      ),
                      //login Button
                      SizedBox(
                        height: 50.h,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              resetPasswordController.resetPassword();
                            }
                          },
                          child: AppButton(
                            alignment: MainAxisAlignment.center,
                            text: 'Send',
                            textColor: Colors.white,
                            bgColor: Colors.black,
                            align: TextAlign.center,
                            textSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
        if(resetPasswordController.isLoading.value)Container(
          color: Colors.grey.withOpacity(.5),
          height: Get.height,
          width: Get.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

/*  Widget bodyContent() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderText(
                text: "Please insert your registered email address"
                    " and we will send password reset "
                    "link to your email",
                fontWeight: FontWeight.normal,
                size: 14,
                maxLine: 4,
                color: Colors.black,
              ),
              SizedBox(
                height: 20.h,
              ),
              emailTextField(),
              SizedBox(
                height: 20.h,
              ),
              //login Button
              SizedBox(
                height: 50.h,
                child: InkWell(
                  onTap: () {
                    // Get.toNamed('/otp_screen');
                  },
                  child: AppButton(
                    alignment: MainAxisAlignment.center,
                    text: 'Send',
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
            ],
          ),
        ),
      ),
    );
  }*/

  Widget emailTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            validator: (value){
              if(value!.isEmpty){
                return "E-mail Field is Required";
              }
              else if(!value.isEmail){
                return "Invalid E-mail address";
              }return null;
            },
            controller: resetPasswordController.emailController,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15.h, bottom: 15.h),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),

                // labelText: "E-mail",
                hintText: "example@abc.com",
                // labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.red,
                hoverColor: Colors.red,
                focusColor: AppColors.mainColorRed),
          ),
        )
      ],
    );
  }

/*Widget emailTextField() {
    return Column(
      children: [
        Container(
          color: Colors.white.withOpacity(.8),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            cursorColor: AppColors.mainColorRed,
            cursorWidth: .5,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.email_outlined),
                labelText: "E-mail",
                hintText: "example@abc.com",
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.red,
                hoverColor: Colors.red,
                focusColor: AppColors.mainColorRed),
          ),
        )
      ],
    );
  }*/
}
