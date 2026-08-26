import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/user_info_controller.dart';
import '../../../widgets/bullet_text.dart';

class HowToBecomeVipPage extends StatelessWidget {
  HowToBecomeVipPage({super.key});
  final UserInfoController userInfoController = Get.put(UserInfoController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "How to Be a VIP".toUpperCase(),
            color: Colors.white,
          ),
        ),
        body: Obx(() => userInfoController.isLoadingPrivileges.value
            ? const Text("")
            : bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            Container(
              //height: 200,
              width: Get.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/vip_header_banner.png"),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 30.h, bottom: 10.h, left: 50.w, right: 50.w),
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: SizedBox(
                    height: 110.h,
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeaderText(
                            text:
                                "Hi, ${userInfoController.userPrivileges.value.vipPrivilege?.customerName?.toUpperCase() ?? ""}",
                            fontWeight: FontWeight.normal,
                          ),
                          /* SizedBox(
                            height: 5.h,
                          ),*/
                          HeaderText(
                              text:
                                  "${userInfoController.userPrivileges.value.vipPrivilege?.privilegeType?.toUpperCase() ?? ""} | "
                                  "${userInfoController.userPrivileges.value.vipPrivilege?.purchasePoint ?? ""} "
                                  "POINTS"),
                          /* SizedBox(height: 5.h,),*/
                          BodyText(
                            text: userInfoController.userPrivileges.value
                                    .vipPrivilege?.instruction ??
                                "",
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            HeaderText(
              text: "VIP CARD",
              size: 22,
            ),
            SizedBox(
              height: 20.h,
            ),
            CachedNetworkImage(
                placeholder:(context,image)=> Image.asset("assets/images/no-img.jpg"),
                imageUrl: (userInfoController
                        .userPrivileges.value.images?.vip?.image2 ??
                    ""),),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(
              text: "Rules And Regulation of VIP Card".toUpperCase(),
              size: 22,
              fontWeight: FontWeight.w500,
              maxLine: 10,
            ),
            BulletText(
                textList: userInfoController.userPrivileges.value.vipPrivilege
                        ?.rulesAndRegulations ??
                    []),
            SizedBox(
              height: 30.h,
            ),
            HeaderText(
              text: "Because You're a VIP",
              size: 25,
              fontWeight: FontWeight.w500,
            ),

            //This Section should be dynamic
            Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Image.network(
                "${userInfoController.userPrivileges.value.vipPrivilege!.memberBenefits![0].icon}",
                errorBuilder: (c, i, t) {
                  return Image.asset("assets/images/no-img.jpg");
                },
              ),
            ),
            HeaderText(
              text: "You Earn 1 point for every 100 Tk. spent",
              fontWeight: FontWeight.normal,
              size: 14,
            ),
            Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Image.network(
                userInfoController.userPrivileges.value.vipPrivilege
                        ?.memberBenefits?[2].icon ??
                    "",
                errorBuilder: (c, i, t) {
                  return Image.asset("assets/images/no-img.jpg");
                },
              ),
            ),
            HeaderText(
              text:
                  "Good things happen to the Mall VIP members! Shop to start earning!",
              maxLine: 20,
              fontWeight: FontWeight.normal,
              size: 14,
            ),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(
              text: "The Mall Member Benefits",
              size: 22,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: 20.h,
            ),
            memberBenefitsSection(),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(text: "***Terms & Conditions Applied.***"),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(
              text: "More Benefits for all members:".toUpperCase(),
              size: 22,
              maxLine: 5,
            ),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(
              text:
                  "18 Hours Dedicated Customer Service The Mall Facebook Group & Many More!",
              maxLine: 5,
              size: 18,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(
              height: 30.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'This is Just the beginning. ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cabin"),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Click below to explore what we have in store.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Cabin"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  userInfoController.userPrivileges.value.images?.vip?.image4 ??
                      "",
                  errorBuilder: (c, i, t) {
                    return Image.asset("assets/images/no-img.jpg");
                  },
                ),
                Image.network(
                  userInfoController.userPrivileges.value.images?.vip?.image5 ??
                      "",
                  errorBuilder: (c, i, t) {
                    return Image.asset("assets/images/no-img.jpg");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            HeaderText(
              text: "Rewords Activity".toUpperCase(),
              size: 22,
            ),
            SizedBox(
              height: 20.h,
            ),
            Image.network(
              userInfoController.userPrivileges.value.images?.vip?.image6 ?? "",
              errorBuilder: (c, i, t) {
                return Image.asset("assets/images/no-img.jpg");
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 2),
                borderRadius:BorderRadius.all( Radius.circular(5.r),)

              ),
              child: InkWell(
                onTap: (){},
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: HeaderText(
                    text: "VIEW POINTS & SPENDS!",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,)

          ],
        ),
      ),
    );
  }

  Widget memberBenefitsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HeaderText(
                text: "",
              ),
            ),
            Expanded(
              child: HeaderText(
                text: "",
              ),
            ),
            Expanded(
              child: HeaderText(
                text: "GENERAL",
                size: 12,
                // align: TextAlign.start,
              ),
            ),
            Expanded(
              child: HeaderText(
                text: "LOYALTY",
                size: 12,
                //  align: TextAlign.start,
              ),
            ),
            Expanded(
              child: HeaderText(
                text: "VIP",
                size: 12,
                //align: TextAlign.start,
              ),
            ),
          ],
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userInfoController
                .userPrivileges.value.vipPrivilege!.memberBenefits!.length,
            itemBuilder: (buildContext, index) {
              return Container(
                color: index.isOdd
                    ? AppColors.scaffoldBGColor
                    : Colors.grey.withOpacity(.15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Icon Section
                    Expanded(
                      child: Image.network(userInfoController.userPrivileges
                          .value.vipPrivilege!.memberBenefits![index].icon
                          .toString()),
                    ),
                    //Name Section
                    Expanded(
                      child: HeaderText(
                        text:
                            "${userInfoController.userPrivileges.value.vipPrivilege!.memberBenefits![index].name}",
                        size: 12,
                        maxLine: 10,
                        fontWeight: FontWeight.normal,
                        // align: TextAlign.start,
                      ),
                    ),
                    //General Section
                    Expanded(
                      child: userInfoController
                                  .userPrivileges
                                  .value
                                  .vipPrivilege!
                                  .memberBenefits![index]
                                  .general ==
                              true
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: .5, color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(.2),
                                  child: Icon(
                                    Icons.circle_rounded,
                                    size: 6.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : userInfoController
                                      .userPrivileges
                                      .value
                                      .vipPrivilege!
                                      .memberBenefits![index]
                                      .general !=
                                  null
                              ? HeaderText(
                                  text:
                                      "${userInfoController.userPrivileges.value.vipPrivilege!.memberBenefits![index].general}",
                                  size: 12,
                                  maxLine: 10,
                                  fontWeight: FontWeight.normal,
                                  //  align: TextAlign.start,
                                )
                              : const Text(""),
                    ),
                    //Loyalty Section
                    Expanded(
                      child: userInfoController
                                  .userPrivileges
                                  .value
                                  .vipPrivilege!
                                  .memberBenefits![index]
                                  .loyalty ==
                              true
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: .5, color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(.2),
                                  child: Icon(
                                    Icons.circle_rounded,
                                    size: 6.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : userInfoController
                                      .userPrivileges
                                      .value
                                      .vipPrivilege!
                                      .memberBenefits![index]
                                      .loyalty !=
                                  null
                              ? HeaderText(
                                  text:
                                      "${userInfoController.userPrivileges.value.vipPrivilege!.memberBenefits![index].loyalty}",
                                  size: 12,
                                  maxLine: 10,
                                  fontWeight: FontWeight.normal,
                                  // align: TextAlign.start,
                                )
                              : const Text(""),
                    ),
                    //VIP Section
                    Expanded(
                      child: userInfoController.userPrivileges.value
                                  .vipPrivilege!.memberBenefits![index].vip ==
                              true
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: .5, color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(.2),
                                  child: Icon(
                                    Icons.circle_rounded,
                                    size: 6.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : userInfoController
                                      .userPrivileges
                                      .value
                                      .vipPrivilege!
                                      .memberBenefits![index]
                                      .vip !=
                                  null
                              ? HeaderText(
                                  text:
                                      "${userInfoController.userPrivileges.value.vipPrivilege!.memberBenefits![index].vip}",
                                  size: 12,
                                  maxLine: 10,
                                  fontWeight: FontWeight.normal,
                                  // align: TextAlign.start,
                                )
                              : const Text(""),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }
}
