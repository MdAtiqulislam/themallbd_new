import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/body_text.dart';
import '../../../views/screens/empty_cart.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/my_notifications_controller.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../../widgets/custom_network_image.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final controller = Get.put(MyNotificationsController());

  @override
  Widget build(BuildContext context) {
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
              text: "Notifications",
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
          body: MyNotificationsController.isLoading.value
              ?const Center(child: CircularProgressIndicator(),)
              :SingleChildScrollView(
            child:MyNotificationsController.myNotifications.isNotEmpty? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MyNotificationsController.myNotifications.length,
                itemBuilder: (buildContext, index) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: (){
                        controller.viewNotification(message:MyNotificationsController.myNotifications[index]);
                      },
                      child: Row(
                        children: [
                        if(MyNotificationsController.myNotifications[index].notification
                            ?.android?.imageUrl!=null)CustomNetworkImage(
                        height: 120.h,
                        width: 100,
                        image: MyNotificationsController.myNotifications[index].notification
                            ?.android?.imageUrl ??
                            "",
                      ),
                          SizedBox(width:10.w,),
                          Expanded(child: Padding(
                            padding:  EdgeInsets.all(5.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText(text:MyNotificationsController
                                    .myNotifications[index].notification?.title ??
                                    "",maxLine: 3,align: TextAlign.start,),
                                BodyText(text:MyNotificationsController
                                    .myNotifications[index].notification?.body ??
                                    "",maxLine: 4,
                                  align: TextAlign.start,),
        
                              ],
                            ),
                          ),),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  );
                })
                :const EmptyCard(
                title: "No new message",
                bodyText: "Your message list is empty!",
              showButton: false,
              image: "assets/images/empty_wishlist.png",
            ),
          ),
        ),
      ),
    );
  }
}
