import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/user_info_controller.dart';
import '../../../widgets/bullet_text.dart';

class LoyaltyCardPage extends StatelessWidget {
  LoyaltyCardPage({super.key});
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
            text: "Loyalty Card",
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
            /*FadeInImage(
              placeholder: AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(userInfoController
                      .userPrivileges.value.images?.loyalty?.image1 ??
                  ""),
            ),*/
            Image.network(userInfoController.userPrivileges.value.images?.loyalty?.image1??"",

              fit: BoxFit.fill,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                }
                return image;
              },

              loadingBuilder:
                  (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover
                  );
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            /*FadeInImage(
              placeholder: AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(userInfoController
                      .userPrivileges.value.images?.loyalty?.image2 ??
                  ""),
            ),*/
            Image.network(userInfoController.userPrivileges.value.images?.loyalty?.image2??"",

              fit: BoxFit.fill,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                }
                return image;
              },

              loadingBuilder:
                  (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover
                  );
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            imgeWithTextSection(),
            SizedBox(
              height: 20.h,
            ),
            HeaderText(
              text: "Rules For The Mall's Loyalty Card",
              size: 22,
              fontWeight: FontWeight.w500,
              maxLine: 10,
            ),
            BulletText(
                textList: userInfoController.userPrivileges.value.loyaltyCard
                        ?.rulesAndRegulations ??
                    [])
            /*ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userInfoController.userPrivileges.value.loyaltyCard!
                    .rulesAndRegulations!.length,
                itemBuilder: (buildContext, index) {
                  return singleRule(index);
                })*/
          ],
        ),
      ),
    );
  }

  Widget singleRule(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: ListTile(
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Icon(
                Icons.circle_rounded,
                size: 8.sp,
                color: Colors.black,
              ),
            ),
            Flexible(
                child: HeaderText(
              text: userInfoController.userPrivileges.value.loyaltyCard!
                  .rulesAndRegulations![index],
              maxLine: 20,
              align: TextAlign.start,
              fontWeight: FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }

  Widget imgeWithTextSection() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: HeaderText(
              text: "What Is A Loyality Card?\n How To Get It?",
              color: Colors.white,
              size: 20,
              maxLine: 10,
              align: TextAlign.center,
            ),
          ),
          imageTextCard(image: userInfoController
              .userPrivileges.value.images?.loyalty?.image3 ??
              "",text: userInfoController
              .userPrivileges.value.images?.loyaltyText?.text1??""),
          imageTextCard(image: userInfoController
              .userPrivileges.value.images?.loyalty?.image4 ??
              "",text: userInfoController
              .userPrivileges.value.images?.loyaltyText?.text2??""),
          imageTextCard(image: userInfoController
              .userPrivileges.value.images?.loyalty?.image5 ??
              "",text: userInfoController
              .userPrivileges.value.images?.loyaltyText?.text3??""),

        ],
      ),
    );
  }

 Widget imageTextCard({required String image, required String text}) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.0.w,vertical: 5.h),
      child: Card(
        child: Padding(
          padding:  EdgeInsets.all(10.r),
          child: Column(
            children: [
              /*FadeInImage(placeholder: AssetImage("assets/images/no-img.jpg"),
                image: NetworkImage(image),),*/
              Image.network(image,
                fit: BoxFit.fill,
                frameBuilder: (_, image, loadingBuilder, __) {
                  if (loadingBuilder == null) {
                    return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                  }
                  return image;
                },

                loadingBuilder:
                    (context, image, loading) {
                  if (loading == null) {
                    return image;
                  } else {
                    return Image.asset(
                        "assets/images/no-img.jpg",
                        fit: BoxFit.cover
                    );
                  }
                },
              ),
              BodyText(text: text,size: 14,maxLine: 20,color: AppColors.headerTextColor,),
            ],
          ),
        ),
      ),
    );
 }
}
