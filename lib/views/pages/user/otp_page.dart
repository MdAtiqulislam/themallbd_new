import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/otp_verification_controller.dart';
import '../../../widgets/app_button.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final String number = Get.arguments.toString();

  final OTPVerificationController otpVerificationController = Get.put(
    OTPVerificationController(),
  );
  final GlobalKey<FormState> _otpVerifyFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    otpVerificationController.phoneNumber.value = number;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: 'Enter Your Pin',
            color: Colors.white,
          ),
        ),
        body: Obx(
          () => Stack(
            children: [
              bodyContent(),
              if (otpVerificationController.isLoading.value)
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
        ),
      ),
    );

    /*UserScreenBackground(
      body: bodyContent(),
    );*/
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderText(
              text: "We've sent a 4-digit one time PIN in your"
                  " phone $number. It will expire within 3 minutes.",
              fontWeight: FontWeight.normal,
              size: 14,
              maxLine: 4,
              color: Colors.black,
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: HeaderText(
                  text: 'Enter Your 4-digit PIN Number',
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                )),
            SizedBox(
              height: 5.h,
            ),
            otpForm(),
            SizedBox(
              height: 20.h,
            ),
            /* Obx(() => Container(
              margin: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Colors.green,
                strokeWidth: 5,
                value: value.value,
              ),
            ),),*/

            InkWell(
                onTap: () {
                  otpVerificationController.reSendOTP();
                },
                child: HeaderText(text: "Request PIN Again"))
          ],
        ),
      ),
    );
  }

  Widget otpTextField() {
    return Container(
      color: Colors.white.withOpacity(.8),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty || value.length < 4) {
            return "Please enter correct OTP";
          } else {
            return null;
          }
        },
        controller: otpVerificationController.otpController,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.phone,
        cursorColor: AppColors.mainColorRed,
        cursorWidth: .5,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              left: 15.w,
            ),
            /* border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),*/
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            prefixIcon: const Icon(Icons.fingerprint),
            // labelText: "Enter Your 4-digit PIN Number",
            hintText: "Enter your pin..",
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.red,
            hoverColor: Colors.red,
            focusColor: AppColors.mainColorRed),
      ),
    );
  }

  Widget otpForm() {
    return Form(
      key: _otpVerifyFormKey,
      child: Column(
        children: [
          otpTextField(),
          SizedBox(
            height: 20.h,
          ),
          //login Button
          SizedBox(
            height: 50.h,
            child: InkWell(
              onTap: () {
                if(_otpVerifyFormKey.currentState!.validate()) {
                  otpVerificationController.verifyOTP();
                }
                // Get.toNamed('/user_info_page');
              },
              child: AppButton(
                alignment: MainAxisAlignment.center,
                text: 'Apply',
                textColor: Colors.white,
                bgColor: Colors.black.withOpacity(.8),
                align: TextAlign.center,
                textSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
