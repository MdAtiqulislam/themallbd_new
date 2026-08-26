
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/user_info_controller.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoPage({super.key});

  final UserInfoController userInfoController = Get.put(UserInfoController());

  @override
  Widget build(BuildContext context) {
    userInfoController.fetchData();

    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColorOffLight,
          appBar: AppBar(
            /*backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),*/
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            title: HeaderText(
              text: "My Account",
              color: Colors.white,
            ),
            actions: [
              IconButton(
                onPressed: ()async {
                  Get.toNamed("/my_notification_page");
                },
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Badge(
                    isLabelVisible: UserInfoController.myMessages.isNotEmpty?true:false,
                    label: Text("${UserInfoController.myMessages.length}",),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar:  CustomBottomNavigationBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColors.scaffoldBGColorDark,
                  // width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        HeaderText(
                          text: UserInfoController.user.value.name ?? "",
                          size: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CircleAvatar(
                          radius: 60.r,
                          backgroundImage: const AssetImage(
                              "assets/images/user-profile.png"),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Card(
                          color: AppColors.mainColorRed,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.0.w, vertical: 5.h),
                            child: HeaderText(
                              text:
                                  "${userInfoController.userPrivileges.value.vipPrivilege?.privilegeType ?? "Normal"} User",
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        if(userInfoController.ipPrivilegesStatus.value)  InkWell(
                          onTap: (){
                            Get.toNamed("/vip_privileges_page");
                          },
                          child: Card(
                            color: AppColors.mainColorPink,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: HeaderText(
                                text:
                                    "Eligible for Privileged Discounts",
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed("/user_details");
                  },
                  child: listItem(
                    "Account Details",
                    const Icon(
                      Icons.account_circle_rounded,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed("/order_history");
                  },
                  child: listItem(
                    "Order History",
                    const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                   // Get.toNamed("/review_list");
                    Get.toNamed("/user_reviews_page");
                  },
                  child: listItem(
                    "Reviews",
                    const Icon(
                      Icons.thumb_up_outlined,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed("/wish_list");
                  },
                  child: listItem(
                    "Wish List",
                    const Icon(
                      Icons.favorite,
                    ),
                  ),
                ),
               if(userInfoController.ipPrivilegesStatus.value) InkWell(
                  onTap: () {
                    Get.toNamed("/vip_privileges_page");
                  },
                  child: listItem(
                    "Privileges",
                    const Icon(
                      Icons.card_giftcard,
                    ),
                  ),
                ),
        
               // if(Platform.isIOS)
                  InkWell(
                  onTap: () {
                    userInfoController.deleteAccount();
                    },
                  child: listItem(
                    "Delete Account",
                      const Icon(
                      Icons.delete,
                    ),
                  ),
                ),
        
        
        
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.toNamed("/dynamic_page_list");
                        },
                        child: HeaderText(
                          text: "NEED HELP?",
                          size: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          userInfoController.logOut();
                        },
                        child: const SizedBox(
                          height: 30,
                          width: 120,
                          child: AppButton(
                            alignment: MainAxisAlignment.center,
                            text: "LOGOUT",
                            bgColor: AppColors.mainColorRed,
                            textColor: Colors.white,
                            radius: 10.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listItem(String text, Icon icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: AppColors.scaffoldBGColorDark,
          borderRadius: BorderRadius.all(Radius.circular(5.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            SizedBox(
              width: 20.w,
            ),
            HeaderText(
              text: text,
              fontWeight: FontWeight.normal,
            )
          ],
        ),
      ),
    );
  }
/*
  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Container(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.red,
                backgroundImage: AssetImage("assets/images/user-profile.png"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                color: AppColors.mainColorRed,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0.w, vertical: 5.h),
                  child: HeaderText(
                    text: 'NORMAL USER',
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              */ /*Container(
                height: 200,
                width: 300,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // primary: false,
                  padding: const EdgeInsets.all(16),
                  children: [
                    gridItem(
                      "Account Details",
                      Icon(
                        Icons.account_circle_rounded,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "Order History",
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "Reviews",
                      Icon(
                        Icons.thumb_up_outlined,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "Wish List",
                      Icon(
                        Icons.favorite,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "Loyalty Card",
                      Icon(
                        Icons.loyalty,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "How To Become a VIP",
                      Icon(
                        Icons.ac_unit_sharp,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                    gridItem(
                      "VIP Privileges",
                      Icon(
                        Icons.card_giftcard,
                        color: AppColors.mainColorRed,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),*/ /*
            ],
          ),
        ),
      ),
    );
  }

  Widget gridItem(String text, Icon icon) {
    return Card(
        elevation: 5,
        color: Colors.white.withOpacity(.9),
        child: Flex(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Container(
                  child: icon,
                )),
            Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                    color: AppColors.mainColorRed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Center(
                          child: HeaderText(
                        text: text,
                        maxLine: 2,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      )),
                    )))
          ],
        ));
  }*/
}
