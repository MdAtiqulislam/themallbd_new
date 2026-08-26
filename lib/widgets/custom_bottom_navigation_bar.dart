import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/widgets/responsive_helper.dart';

import '../constraints/app_colors.dart';
import '../controllers/bottom_navigation_bar_controller.dart';
import '../controllers/home_page_data_controller.dart';
import '../controllers/my_cart_controller.dart';
import '../services/local_services.dart';
import '../utils/show_snack_bar.dart';
import 'app_button.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final bool isCart;

  CustomBottomNavigationBar({super.key, this.isCart = true});

  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());
 // final HomePageDataController homePageDataController=Get.put(HomePageDataController());

  @override
  Widget build(BuildContext context) {
   // bottomNavigationBarController.getCartItems();
   // bottomNavigationBarController.cartItems.value;
    return ResponsiveHelper(
      portrait: portraitView(),
      landscape: landscapeView(),
    );
  }

  Widget portraitView() {
   // bottomNavigationBarController.getCartItems();
    return Container(
      color: Colors.white,
      height: 80.h,
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.only(top: 3.0.h, bottom: 3.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: homeButton(),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: searchButton(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Expanded(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: beautyfeedButton(),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: accountButton(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
              flex: 3,
              child: isCart ? cartButton() : chekOutButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget landscapeView() {
    return SizedBox(
      height: 40.h,
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.only(top: 3.0.h, bottom: 3.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: homeButton(),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: searchButton(),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: beautyfeedButton(),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: accountButton(),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: isCart ? cartButton() : chekOutButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeButton() {
    return InkWell(
      onTap: () {
        final HomePageDataController homePageDataController=Get.put(HomePageDataController());
        homePageDataController.isLoading.value = true;
        homePageDataController.searchKey.value="0";
        homePageDataController.fetchData();
        Get.offAllNamed('/home_page');
      },
      child: AppButton(
        icon: Icon(
          Icons.home,
          color: Colors.white,
          size: 20.spMin,
        ),
        textColor: Colors.white,
        bgColor: AppColors.headerTextColor,
        text: ' HOME',
      ),
    );
  }

  Widget searchButton() {
    return InkWell(
      onTap: () {
        Get.toNamed('/multiple_search',arguments: ["0"]);
      },
      child: AppButton(
        icon: Icon(
          Icons.widgets_rounded,
          color: Colors.white,
          size: 20.spMin,
        ),
        textColor: Colors.white,
        bgColor: AppColors.headerTextColor,
        text: ' CATEGORY',
      ),
    );
  }

  Widget beautyfeedButton() {
    return InkWell(
      onTap: () {
        Get.toNamed('/beauty_feed');
      },
      child: AppButton(
        icon: Icon(Icons.ac_unit, color: Colors.white, size: 20.spMin),
        textColor: Colors.white,
        bgColor: AppColors.headerTextColor,
        text: ' BEAUTYFEED',
      ),
    );
  }

  Widget accountButton() {
    return InkWell(
      onTap: () async {
        final token = await LocalServices.getToken() ?? '';
        if (token.isEmpty) {
          Get.toNamed('/login_page');
        } else {
          // var user=await LocalServices.getUser();
          Get.toNamed('/user_info_page');
        }
      },
      child: AppButton(
        icon: Icon(Icons.account_circle, color: Colors.white, size: 20.spMin),
        textColor: Colors.white,
        bgColor: AppColors.headerTextColor,
        fontWeight: FontWeight.bold,
        text: ' ACCOUNT',
      ),
    );
  }

  Widget cartButton() {
    return InkWell(
      onTap: () async {
        var token = await LocalServices.getToken()??"";
        token.isNotEmpty
            ? openCartPage()
            : ShowSnackBar(
                    msg:
                        "You are not Logged in yet. Please Login first to continue",
                    title: "Login Required",
                    showButton: true,
                    buttonText: "GO TO LOGIN?",
          isWarning: true,
          callback: () {
            Get.back();
            Get.toNamed("/login_page");
          }
        )
                .showSnackBar();
      },
      child: Obx(
        () => AppButton(
          icon: Icon(Icons.shopping_bag, color: Colors.white, size: 20.spMin),
          textColor: Colors.white,
          bgColor: AppColors.mainColorRed,
          text: bottomNavigationBarController.itemsOnCart.value <= 0
              ? ' BAG'
              : "BAG (${bottomNavigationBarController.itemsOnCart.value})",
        ),
      ),
    );
  }

  Widget chekOutButton() {
    return InkWell(
      onTap: () {
        bottomNavigationBarController.openCheckoutPage();

      },
      child: AppButton(
        icon: Icon(Icons.check_circle_outline_outlined,
            color: Colors.white, size: 20.sp),
        textColor: Colors.white,
        bgColor: Colors.green,
        text: "Check Out",
      ),
    );
  }

  openCartPage() {
    MyCartController myCartController=Get.put(MyCartController());
    myCartController.fetchMyCartData();
    Get.toNamed("/my_cart");
  }
}
