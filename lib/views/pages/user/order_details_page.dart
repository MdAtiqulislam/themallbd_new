import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/order_details_controller.dart';
import '../../../widgets/circuler_button.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../shimmers/shimmer_skeleton.dart';

class OrderDetailsPage extends StatelessWidget {
  OrderDetailsPage({super.key});

  final String orderId = Get.arguments[0];
  final String invoice = Get.arguments[1];
  final DateTime orderDate = Get.arguments[2];
  final String subTotal = Get.arguments[3];
  final String discount = (Get.arguments[4] ?? "0").toString();
  final String appSpecialDiscount = (Get.arguments[5] ?? "0").toString();
  final String deliveryCharge = Get.arguments[6];
  final String grandTotal = Get.arguments[7].toString();
  final int numberOfProducts = Get.arguments[8];
  final OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    orderDetailsController.orderId.value = orderId;
    orderDetailsController.fetchData();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "Order Details",
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() => bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(5.0.r),
        child: Column(
          children: [
            orderInfoSection(),
            if (orderDetailsController.orderDetails.value.timelineStatus == 1)
              timeLineSection(),
            orderDetailsController.isLoading.value
                ? orderSummarySectionShimmer()
                : orderSummarySection(),
            //OrderSummarySectionShimmer(),
            //
            orderDetailsController.isLoading.value
                ? shippingAddressSectionShimmer()
                : shippingAddressSection()
          ],
        ),
      ),
    );
  }

  Widget orderInfoSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Order Info",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            HeaderText(
              text:
                  "Invoice ID:${orderDetailsController.orderDetails.value.invoiceId ?? invoice}",
              fontWeight: FontWeight.normal,
              size: 14,
            ),
            HeaderText(
              text:
                  "Order Date:${DateFormat("EEE, dd MMM, yyyy hh:mm a").format(orderDetailsController.orderDetails.value.date ?? orderDate)}",
              fontWeight: FontWeight.normal,
              size: 14,
            ),
            if ((orderDetailsController.orderDetails.value.description ?? "")
                .isNotEmpty)
              HeaderText(
                text:
                    "Order Description:${orderDetailsController.orderDetails.value.description ?? ""}",
                fontWeight: FontWeight.normal,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }

  Widget timeLineSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Order Status",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            orderDetailsController.isHorizontalTimeLine.value
                ? horizontalTimeLine()
                : verticalTimeLine(),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  orderDetailsController.isHorizontalTimeLine.value =
                      !orderDetailsController.isHorizontalTimeLine.value;
                },
                child: CircularButton(
                  bgColor: AppColors.mainColorRed,
                  child: orderDetailsController.isHorizontalTimeLine.value
                      ? const Icon(Icons.expand_more_outlined,color: Colors.white,)
                      : const Icon(Icons.expand_less,color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget orderSummarySection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Order Summary",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderDetailsController
                        .orderDetails.value.orderDetails?.length ??
                    0,
                itemBuilder: (buildContext, x) {
                  return Column(
                    children: [
                      singleProduct(x),
                      if (x <
                          orderDetailsController
                                  .orderDetails.value.orderDetails!.length -
                              1)
                        Divider(
                          thickness: .5.h,
                        )
                    ],
                  );
                }),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Sub Total",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "৳${orderDetailsController.orderDetails.value.netTotal ?? ""}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Discount",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "- ৳${(orderDetailsController.orderDetails.value.discount ?? "0.00")}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),

            if (orderDetailsController.orderDetails.value.specialDiscount !=
                    null &&
                (orderDetailsController.orderDetails.value.specialDiscount ??
                        "")
                    .isNotEmpty &&
                (orderDetailsController.orderDetails.value.specialDiscount ??
                        "") !=
                    "0.00" &&
                (orderDetailsController.orderDetails.value.specialDiscount ??
                        "") !=
                    "0")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: "App Special Discount",
                    fontWeight: FontWeight.normal,
                    maxLine: 3,
                  ),
                  Flexible(
                    child: HeaderText(
                      text:
                          "- ৳${orderDetailsController.orderDetails.value.specialDiscount}",
                      fontWeight: FontWeight.normal,
                      maxLine: 5,
                    ),
                  ),
                ],
              ),
            if (orderDetailsController.orderDetails.value.couponDiscount !=
                    null &&
                (orderDetailsController.orderDetails.value.couponDiscount ?? "")
                    .isNotEmpty &&
                (orderDetailsController.orderDetails.value.couponDiscount ??
                        "") !=
                    "0.00" &&
                (orderDetailsController.orderDetails.value.couponDiscount ??
                        "") !=
                    "0")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text: "Coupon Discount",
                    fontWeight: FontWeight.normal,
                    maxLine: 3,
                  ),
                  Flexible(
                    child: HeaderText(
                      text:
                          "- ৳${orderDetailsController.orderDetails.value.couponDiscount}",
                      fontWeight: FontWeight.normal,
                      maxLine: 5,
                    ),
                  ),
                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Delivery Charge",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "+ ৳${orderDetailsController.orderDetails.value.shippingCost ?? ""}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Total",
                  fontWeight: FontWeight.normal,
                  color: AppColors.mainColorRed,
                ),
                HeaderText(
                  text:
                      "৳${orderDetailsController.orderDetails.value.grandTotal ?? ""}",
                  fontWeight: FontWeight.normal,
                  color: AppColors.mainColorRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget shippingAddressSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Shipping Address",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            Flexible(
              child: HeaderText(
                text:
                    "${orderDetailsController.orderDetails.value.shippingAddress?.firstName ?? ""}"
                    " ${orderDetailsController.orderDetails.value.shippingAddress?.lastName ?? ""}",
                fontWeight: FontWeight.normal,
                size: 14,
              ),
            ),
            Flexible(
              child: HeaderText(
                text: orderDetailsController
                        .orderDetails.value.shippingAddress?.phone ??
                    "",
                fontWeight: FontWeight.normal,
                size: 14,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: HeaderText(
                    text: orderDetailsController
                            .orderDetails.value.shippingAddress?.address ??
                        "",
                    fontWeight: FontWeight.normal,
                    size: 14,
                  ),
                ),
                if ((orderDetailsController
                            .orderDetails.value.shippingAddress?.area ??
                        "")
                    .isNotEmpty)
                  Flexible(
                    child: HeaderText(
                      text:
                          ", ${orderDetailsController.orderDetails.value.shippingAddress?.area}",
                      fontWeight: FontWeight.normal,
                      size: 14,
                    ),
                  ),
                if ((orderDetailsController
                            .orderDetails.value.shippingAddress?.city ??
                        "")
                    .isNotEmpty)
                  Flexible(
                    child: HeaderText(
                      text:
                          ", ${orderDetailsController.orderDetails.value.shippingAddress?.city}",
                      fontWeight: FontWeight.normal,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singleProduct(int x) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50.w,
          child: /*FadeInImage(
            placeholder: const AssetImage("assets/images/no-image_card.jpg"),
            image: NetworkImage(
                "${orderDetailsController.orderDetails.value.orderDetails![x].imageUrl.toString()}/"
                "${orderDetailsController.orderDetails.value.orderDetails![x].image.toString()}"),
            imageErrorBuilder: (context, obj, track) =>
                Image.asset("assets/images/no-image_card.jpg"),
          ),*/
              Image.network(
           // "${orderDetailsController.orderDetails.value.orderDetails?[x].imageUrl ?? ""}/"
            orderDetailsController.orderDetails.value.orderDetails?[x].image ?? "",
            fit: BoxFit.fill,
            frameBuilder: (_, image, loadingBuilder, __) {
              if (loadingBuilder == null) {
                return Image.asset(
                  "assets/images/no-img.jpg",
                  fit: BoxFit.cover,
                );
              }
              return image;
            },
            loadingBuilder: (context, image, loading) {
              if (loading == null) {
                return image;
              } else {
                return Image.asset("assets/images/no-img.jpg",
                    fit: BoxFit.cover);
              }
            },
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
          child: HeaderText(
            text: orderDetailsController
                    .orderDetails.value.orderDetails?[x].productName ??
                "",
            maxLine: 10,
            fontWeight: FontWeight.normal,
            size: 15,
            align: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HeaderText(
                text:
                    "${orderDetailsController.orderDetails.value.orderDetails?[x].quantity ?? 1}"
                    " X ৳${double.parse((orderDetailsController.orderDetails.value.orderDetails![x].salesPrice) ?? "0").floor()}",
                fontWeight: FontWeight.normal,
                align: TextAlign.end,
              ),
              if (orderDetailsController
                      .orderDetails.value.orderDetails?[x].salesPrice !=
                  orderDetailsController
                      .orderDetails.value.orderDetails?[x].regularPrice)
                Text(
                  "${orderDetailsController.orderDetails.value.orderDetails?[x].regularPrice}",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12.sp),
                  textAlign: TextAlign.end,
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget shippingAddressSectionShimmer() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Shipping Address",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            ShimmerSkeleton(
              width: 200.w,
              height: 20.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            ShimmerSkeleton(
              width: 150.w,
              height: 20.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            ShimmerSkeleton(
              width: 200.w,
              height: 20.h,
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget orderSummarySectionShimmer() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: "Order Summary",
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
            //SizedBox(height: 5.h,),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfProducts,
                itemBuilder: (buildContext, x) {
                  return Column(
                    children: [
                      singleProductShimmer(x),
                      if (x < 3)
                        Divider(
                          thickness: .5.h,
                        )
                    ],
                  );
                }),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Sub Total",
                  fontWeight: FontWeight.normal,
                ),
                ShimmerSkeleton(
                  height: 20.h,
                  width: 100.w,
                ),
                /*HeaderText(
                  text: "৳$subTotal",
                  fontWeight: FontWeight.normal,
                ),*/
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Discount",
                  fontWeight: FontWeight.normal,
                ),
                ShimmerSkeleton(
                  height: 20.h,
                  width: 100.w,
                ),
                /*HeaderText(
                  text: "- ৳$discount",
                  fontWeight: FontWeight.normal,
                ),*/
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "App Special Discount",
                  fontWeight: FontWeight.normal,
                ),
                /*HeaderText(
                  text: "- ৳$appSpecialDiscount",
                  fontWeight: FontWeight.normal,
                ),*/
                ShimmerSkeleton(
                  height: 20.h,
                  width: 100.w,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Delivery Charge",
                  fontWeight: FontWeight.normal,
                ),
                /*HeaderText(
                  text: "+ ৳$deliveryCharge",
                  fontWeight: FontWeight.normal,
                ),*/
                ShimmerSkeleton(
                  height: 20.h,
                  width: 100.w,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: .5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Total",
                  fontWeight: FontWeight.normal,
                  color: AppColors.mainColorRed,
                ),
                /*HeaderText(
                  text: "৳$deliveryCharge",
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),*/
                ShimmerSkeleton(
                  height: 20.h,
                  width: 100.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget singleProductShimmer(int x) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50.w,
          child: Image.asset("assets/images/no-image_card.jpg"),
        ),
        SizedBox(
          width: 20.w,
        ),
        Expanded(
          child: Column(
            children: [
              ShimmerSkeleton(
                height: 20.h,
                width: 200.w,
              ),
              SizedBox(
                height: 5.h,
              ),
              ShimmerSkeleton(
                height: 20.h,
                width: 150.w,
              ),
              SizedBox(
                height: 5.h,
              ),
              ShimmerSkeleton(
                height: 20.h,
                width: 100.w,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerSkeleton(
                width: 100.w,
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              ShimmerSkeleton(
                width: 50.w,
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              ShimmerSkeleton(
                width: 100.w,
                height: 20.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget horizontalTimeLine() {
    return SizedBox(
      height: 100.h,
      child: Center(
        child: ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,

            /// itemScrollController: _itemScrollController,
            // itemPositionsListener: _itemPositionsListener,
            // initialScrollIndex: orderDetailsController.orderDetails.value.timeline?.length??0,
            shrinkWrap: true,
            itemCount:
                orderDetailsController.orderDetails.value.timeline?.length ?? 0,
            itemBuilder: (c, i) {
              return TimelineTile(
                  endChild: BodyText(
                    text: orderDetailsController
                        .orderDetails.value.timeline![i].status
                        .toString(),
                    color: Colors.green,
                    // color: Color(int.parse((orderDetailsController.orderDetails.value.timeline![i].colorCode).toString().replaceAll('#', '0xff'))),
                  ),
                  beforeLineStyle: i == 0 ? inActiveLine() : completedLine(),
                  afterLineStyle: i ==
                          (orderDetailsController
                                  .orderDetails.value.timeline!.length -
                              1)
                      ? inActiveLine()
                      : completedLine(),
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.center,
                  indicatorStyle: completedIndicator());
            }),
      ),
    );
  }

  Widget verticalTimeLine() {
    return ScrollablePositionedList.builder(
        //itemScrollController: _itemScrollController,
        // itemPositionsListener: _itemPositionsListener,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            orderDetailsController.orderDetails.value.timeline?.length ?? 0,
        itemBuilder: (c, i) {
          return TimelineTile(
              //lineXY: 20,
              endChild: contentCompleted(i),
              beforeLineStyle: i == 0 ? inActiveLine() : completedLine(),
              afterLineStyle: i ==
                      orderDetailsController
                              .orderDetails.value.timeline!.length -
                          1
                  ? inActiveLine()
                  : completedLine(),
              axis: TimelineAxis.vertical,
              alignment: TimelineAlign.start,
              indicatorStyle: completedIndicator()
              /*IndicatorStyle(
                      padding: EdgeInsets.all(10),
                      indicator: Icon(i<5?Icons.check_circle_outline:i>5?Icons.circle_outlined:Icons.flag_circle,

                          size: 20,
                      color: i>5?Colors.grey:i<5?Colors.green:Colors.blue)),*/
              );
        });

    /*ScrollablePositionedList.builder(
        //itemScrollController: _itemScrollController,
        // itemPositionsListener: _itemPositionsListener,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (c, i) {
          return TimelineTile(
              //lineXY: 20,
              endChild: i == 5
                  ? contentActive(i)
                  : i < 5
                      ? contentCompleted(i)
                      : contentUpComing(i),
              beforeLineStyle: i == 0
                  ? inActiveLine()
                  : i > 5
                      ? upComingLine()
                      : i < 5
                          ? completedLine()
                          : activeLine(),
              afterLineStyle: i == 9
                  ? inActiveLine()
                  : i > 5
                      ? upComingLine()
                      : i < 5
                          ? completedLine()
                          : activeLine(),
              axis: TimelineAxis.vertical,
              alignment: TimelineAlign.start,
              indicatorStyle: i > 5
                  ? upComingIndicator()
                  : i < 5
                      ? completedIndicator()
                      : activeIndicator() */ /*IndicatorStyle(
                      padding: EdgeInsets.all(10),
                      indicator: Icon(i<5?Icons.check_circle_outline:i>5?Icons.circle_outlined:Icons.flag_circle,

                          size: 20,
                      color: i>5?Colors.grey:i<5?Colors.green:Colors.blue)),*/ /*
              );
        });*/
  }

  Widget contentActive(int i) {
    return Card(
      color: AppColors.mainColorRed,
      elevation: 10.r,
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(10.0.r),
        child: Column(
          children: [
            Text(
              "Pending",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text("03 Aug, 2022 at 05:10 PM",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500)),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
            Text(
                "Thank you for placing order at The Mall. "
                "Your invoice number is #IN230487 and we will"
                " start processing your order shortly",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget contentCompleted(int i) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0.w,
      ),
      child: Card(
        color: Colors.white,
        elevation: 5.r,
        shadowColor: Colors.grey,
        child: Column(
          children: [
            Container(
              width: Get.width,
              color: Color(int.parse((orderDetailsController
                      .orderDetails.value.timeline![i].colorCode)
                  .toString()
                  .replaceAll('#', '0xff'))),
              child: Padding(
                padding: EdgeInsets.all(10.0.r),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: HeaderText(
                        text: orderDetailsController
                            .orderDetails.value.timeline![i].status
                            .toString(),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                        "${orderDetailsController.orderDetails.value.timeline![i].date}, ${orderDetailsController.orderDetails.value.timeline![i].time}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Text(
                  orderDetailsController.orderDetails.value.timeline![i].desc
                      .toString(),
                  style: TextStyle(
                      color: Color(int.parse((orderDetailsController
                              .orderDetails.value.timeline![i].colorCode)
                          .toString()
                          .replaceAll('#', '0xff'))),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentUpComing(int i) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(10.0.r),
          child: Column(
            children: [
              Text(
                "Pending",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
              //Text("03 Aug, 2022 at 05:10 PM",style:TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.w500)),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              /*Text("Thank you for placing order at The Mall. "
                  "Your invoice number is #IN230487 and we will"
                  " start processing your order shortly",style:TextStyle(color: Colors.green,fontSize: 14,fontWeight: FontWeight.w500)),
*/
            ],
          ),
        ),
      ),
    );
  }

  IndicatorStyle activeIndicator() {
    return IndicatorStyle(
        width: 60.w,
        height: 60.h,
        padding: const EdgeInsets.all(1),
        indicator: Center(
          child: Icon(
            Icons.flag_circle_rounded,
            size: 60,
            color: AppColors.mainColorRed,
            shadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 20.r,
                spreadRadius: 50.r,
                blurStyle: BlurStyle.outer,
                offset: const Offset(0, 10),
              )
            ],
          ),
        ));
  }

  IndicatorStyle completedIndicator() {
    return IndicatorStyle(
        padding: EdgeInsets.all(5.r),
        indicator: Icon(
          Icons.check_circle_outline,
          size: 20.sp,
          color: Colors.green,
        ));
  }

  IndicatorStyle upComingIndicator() {
    return IndicatorStyle(
        padding: EdgeInsets.all(5.r),
        indicator: Icon(
          Icons.circle_outlined,
          size: 20.sp,
          color: Colors.grey,
        ));
  }

  LineStyle activeLine() {
    return const LineStyle(color: AppColors.mainColorRed, thickness: 1.5);
  }

  LineStyle inActiveLine() {
    return const LineStyle(
      color: Colors.transparent,
    );
  }

  LineStyle completedLine() {
    return const LineStyle(color: Colors.green, thickness: 1);
  }

  LineStyle upComingLine() {
    return const LineStyle(color: Colors.grey, thickness: 1);
  }
}
