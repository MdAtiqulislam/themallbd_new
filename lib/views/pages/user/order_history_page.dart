import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/order_history_controller.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../screens/empty_cart.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({super.key});

  final OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      // print("Content Height: ${_globalKey.currentContext?.size?.height}");
      loadMoreData();
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Center(
            child: HeaderText(
              text: "My Orders",
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() => orderHistoryController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return orderHistoryController.orderHistoryList.isEmpty
        ? const SingleChildScrollView(
            child: EmptyCard(
                image: "assets/images/empty-cart.png",
                title: "Your Order Is Empty",
                bodyText: "Looks Like you haven't made your choice yet...",
                buttonText: "Continue Shopping",
                bottomText: "Start shopping to Make Your First Order."),
          )
        : orderHistory();
  }

  Widget orderHistory() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, top: 30.h, bottom: 10.h),
              child: HeaderText(
                text: "Your Order List",
                color: Colors.black,
                fontWeight: FontWeight.normal,
                size: 14,
                align: TextAlign.start,
              ),
            ),
          ),
        ),
        SliverList(

          delegate:
              SliverChildBuilderDelegate(

                      (BuildContext context, int index) {
            return InkWell(
              onTap: () => Get.toNamed("/order_details", arguments: [
                //'316645',
               orderHistoryController.orderHistoryList[index].id.toString(),
                orderHistoryController.orderHistoryList[index].invoiceId
                    .toString(),
                orderHistoryController.orderHistoryList[index].date,
                orderHistoryController.orderHistoryList[index].subTotal,
                orderHistoryController.orderHistoryList[index].discount,
                0,
                orderHistoryController.orderHistoryList[index].deliveryCharge,
                orderHistoryController.orderHistoryList[index].grandTotal,
                orderHistoryController.orderHistoryList[index].numberOfProducts,
              ]),
              child: listItem(index),
            );
          },
                childCount: orderHistoryController.orderHistoryList.length,
              ),
        ),
        if(orderHistoryController.isLoadingMore.value)const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  Widget listItem(int index) {

    int color=int.parse((orderHistoryController.orderHistoryList.value[index].statusColor).toString().replaceAll('#', '0xff'));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.h),
      child: Container(
        color: AppColors.bgColorOffLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child:  CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color:Color(color),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                      color: Color(color),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: HeaderText(
                        text: orderHistoryController.orderHistoryList.value[index].status.toString(),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        size: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  BodyText(
                    text:
                        "Invoice No:${orderHistoryController.orderHistoryList[index].invoiceId}",
                    size: 15,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  BodyText(
                    text:
                        "Order Date:${DateFormat('dd MMM yyyy').format(orderHistoryController.orderHistoryList[index].date ?? DateTime.now())}",
                    size: 15,
                    color: Colors.grey,
                    align: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  BodyText(text: "Total"),
                  HeaderText(
                      text:
                          "৳${orderHistoryController.orderHistoryList[index].grandTotal}")
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
      ),
    );
  }
  void loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (orderHistoryController
          .orderHistoryData.value.currentPage !=
          orderHistoryController
              .orderHistoryData.value.lastPage) {
        orderHistoryController.loadMore(
            orderHistoryController
                .orderHistoryData.value.nextPageUrl
                .toString());
      }
    }
  }
}
