import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../widgets/circuler_button.dart';

class UserScreenBackground extends StatelessWidget {
  final Widget body;
  final Widget topLeftButton;
   const UserScreenBackground({Key? key,required this.body,this.topLeftButton=const Text("")}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.mainColorRed,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      555.r,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.mainColorRed,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      555.r,
                    ),
                  ),
                ),
              ),
            ),
            body,
            Positioned(
              bottom: 10,
              right: 10,
              child: Card(
                color: AppColors.mainColorRed.withOpacity(.9),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.h),
                  child: HeaderText(
                    text: "NEED HELP?",
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: CircularButton(
                  bgColor:AppColors.mainColorRed,
                    child: const Icon(Icons.arrow_back),),
              ),
            ),
            Positioned(
              top: 10.h,
                right: 10.w,
                child: topLeftButton),
          ],
        ),
      ),
    );
  }
}
