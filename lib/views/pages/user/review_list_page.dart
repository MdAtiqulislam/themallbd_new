import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/review_list_controller.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../screens/empty_cart.dart';

class ReviewListPage extends StatelessWidget {
  ReviewListPage({super.key});
  final ReviewListController reviewListController =
      Get.put(ReviewListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            /*backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),*/
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: HeaderText(
              text: "My Reviews",
              color: Colors.white,
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
          body: reviewListController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: bodyContent(),
                ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return reviewListController.reViewListModel.isEmpty
        ? EmptyCard(
            onTap: () => Get.offAndToNamed("/home_page"),
            title: "No Review Product Found",
            bodyText: "Looks like you have not made any review yet...",
            buttonText: "Explore New Activities",
            bottomText: "Manage your All Rating & Review from here")
        : reviewList();
  }

  Widget reviewList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            color: Colors.white,
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, top: 30.h, bottom: 10.h),
              child: HeaderText(
                text: "Your Feedback",
                color: Colors.black,
                fontWeight: FontWeight.normal,
                size: 14,
                align: TextAlign.start,
              ),
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviewListController.reViewListModel.length,
            itemBuilder: (buildContext, index) {
              return listItem(index);
            }),
      ],
    );
  }

  Widget listItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: index.isOdd
              ? AppColors.scaffoldBGColor
              : AppColors.bgColorOffLight,
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: .5))),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0.r),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  reviewListController.reViewListModel[index].product?.image ??
                      ""),
            ),
          ),
          Expanded(
            child: Container(
              //color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(10.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(3.r),
                            ),
                            color: Colors.green,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            child: Row(
                              children: [
                                HeaderText(
                                  text:
                                      "${(reviewListController.reViewListModel[index].rating ?? 0).toDouble()}",
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  size: 12,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 15.sp,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        HeaderText(
                            text: reviewListController
                                    .reViewListModel[index].title ??
                                "")
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: BodyText(
                        text:
                            "${reviewListController.reViewListModel[index].review ?? 0}",
                        align: TextAlign.start,
                        maxLine: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.black26,
                      height: .5,
                    ),
                    HeaderText(
                      text: reviewListController
                              .reViewListModel[index].product?.name ??
                          "",
                      fontWeight: FontWeight.normal,
                      maxLine: 10,
                      align: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    HeaderText(
                      text: reviewListController
                              .reViewListModel[index].product?.brandName ??
                          "",
                      fontWeight: FontWeight.normal,
                      size: 12,
                      align: TextAlign.start,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
