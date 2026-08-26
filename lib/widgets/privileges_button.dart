import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../services/local_services.dart';

import '../utils/show_snack_bar.dart';
import 'app_button.dart';

class PrivilegesButton extends StatelessWidget {
   PrivilegesButton({super.key});

   var isVisible=true.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
      visible: isVisible.value,
      child: Card(
        elevation: 5,
        color: AppColors.mainColorPink,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                var token = await LocalServices.getToken() ?? "";
                if (token.isEmpty) {
                  ShowSnackBar(
                      isWarning: true,
                      msg: "Please Login First to continue.",
                      title: "Login Required",
                      showButton: true,
                      buttonText: "GO TO LOGIN?"
                  ).showSnackBar();
                }else{
                  Get.toNamed("/vip_privileges_page");
                }
              },
              child: SizedBox(
                height: 30.h,
                //width: 60,
                child: AppButton(
                  text: 'VIP PRIVILEGES',
                  bgColor: Colors.transparent,
                  textColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5.w),
            InkWell(
              onTap: () {
                isVisible.value = false;
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 16.sp,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
