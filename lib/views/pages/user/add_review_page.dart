import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/add_review_controller.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../screens/add_review.dart';

class AddReviewPage extends StatelessWidget {

   AddReviewPage({super.key});
   final AddReviewController addReviewController =Get.put(AddReviewController());

   var proId=Get.arguments[0];

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
          title: HeaderText(text: "Add Review",color: Colors.white,),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 50.h),
                child: Card(
                  elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 50,
                          color:AppColors.mainColorRed,
                            child: Center(child: HeaderText(text: "Add Your Review Here",align: TextAlign.center,color: Colors.white,size: 20,)),),
                        SizedBox(height: 30.h,),
                        AddReview(page:"ReviewPage",proId: proId,),
                      ],
                    ),
                ),
              ),
            ),
            if(addReviewController.isLoading.value)Container(color: Colors.grey.withOpacity(.5),
              child: const Center(child: CircularProgressIndicator(),),)
          ],
        ),
      ),
    );
  }
}
