import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/review_list_controller.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../screens/empty_cart.dart';

class UserReviewsPage extends StatelessWidget {
  UserReviewsPage({Key? key}) : super(key: key);

  final ReviewListController reviewListController =
      Get.put(ReviewListController());

  @override
  Widget build(BuildContext context) {
    //reviewListController.fetchReviewData();
    return Obx(
      () => DefaultTabController(
        length: 2,
        child: SafeArea(
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
                : Flex(
                    direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          elevation: 5,
                          child: TabBar(
                            indicatorColor: AppColors.mainColorRed,
                            labelColor: AppColors.mainColorRed,
                            unselectedLabelColor: Colors.grey,
                            labelStyle: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                            tabs: const [
                              Tab(
                                text: "My Reviews",
                              ),
                              Tab(
                                text: "Add Review",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: TabBarView(
                          children: [
                            myReviewScreen(),
                            addReviewScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget myReviewScreen() {
    return reviewListController.reViewListModel.isEmpty
        ? EmptyCard(
            onTap: () => Get.offAndToNamed("/home_page"),
            title: "No Review Found",
            bodyText: "Looks like you have not made any review yet...",
            buttonText: "Explore New Activities",
            bottomText: "Manage your All Rating & Review from here")
        : SingleChildScrollView(
            child: showReviewList(),
          );
  }

  addReviewScreen() {
    return reviewListController.reviewProductListModel.isEmpty
        ? EmptyCard(
            onTap: () => Get.offAndToNamed("/home_page"),
            title: "No Review Product Found",
            bodyText: "Looks like you have not made your choice yet...",
            buttonText: "Explore New Activities",
            bottomText: "Manage your All Rating & Review from here")
        : SingleChildScrollView(
            child: showReviewProductList(),
          );
  }

  Widget showReviewList() {
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
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviewListController.reViewListModel.length,
            itemBuilder: (buildContext, index) {
              return reviewListItem(index);
            }),
      ],
    );
  }

  Widget reviewListItem(int index) {
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
              backgroundColor: AppColors.mainColorRed,
              backgroundImage: NetworkImage(reviewListController
                  .reViewListModel[index].product!.image
                  .toString()),
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
                                      "${reviewListController.reViewListModel[index].rating?.toDouble()}",
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
                            text:
                                "${reviewListController.reViewListModel[index].title}")
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: BodyText(
                        text:
                            "${reviewListController.reViewListModel[index].review}",
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
                          .reViewListModel[index].product!.name
                          .toString(),
                      fontWeight: FontWeight.normal,
                      maxLine: 10,
                      align: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    HeaderText(
                      text: reviewListController
                          .reViewListModel[index].product!.brandName
                          .toString(),
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

  Widget showReviewProductList() {
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
                text: "Add your Feedback",
                color: Colors.black,
                fontWeight: FontWeight.normal,
                size: 14,
                align: TextAlign.start,
              ),
            )),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviewListController.reviewProductListModel.length,
            itemBuilder: (buildContext, index) {
              return reviewProductListItem(index);
            }),
      ],
    );
  }

  Widget reviewProductListItem(int index) {
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
              backgroundColor: AppColors.mainColorRed,
              backgroundImage: NetworkImage(reviewListController
                  .reviewProductListModel[index].image
                  .toString()),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: reviewListController
                            .reviewProductListModel[index].name ??
                        "",
                    maxLine: 5,
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 10.h,),
                  const Divider(
                    color: Colors.black26,
                    height: .5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodyText(
                          text: reviewListController
                                  .reviewProductListModel[index].brandName ??
                              ""),
                      Container(
                        margin: EdgeInsets.only(right: 10.w),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(5.r)),
                         border: Border.all(color: Colors.black),
                       ),
                        child: Padding(
                          padding: EdgeInsets.all(5.0.r),
                          child: InkWell(
                            onTap: (){
                              Get.toNamed("/add_review_page",arguments: [reviewListController.reviewProductListModel[index].productId.toString()]);
                            },
                            child: AppButton(
                              textColor: Colors.black,
                              bgColor: Colors.transparent,
                              text: 'Add Review',
                              fontWeight: FontWeight.normal,
                              icon: Icon(Icons.star,color: Colors.black,size: 14.sp,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
