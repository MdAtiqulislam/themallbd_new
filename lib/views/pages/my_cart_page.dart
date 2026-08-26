import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/my_cart_controller.dart';
import '../../widgets/circuler_button.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/my_animated_text.dart';
import '../../widgets/single_card_item.dart';
import '../screens/empty_cart.dart';
import '../shimmers/shimmer_skeleton.dart';
import 'no_internet_page.dart';

class MyCartPage extends StatelessWidget {
  MyCartPage({super.key});
  final MyCartController myCartController = Get.put(MyCartController());
  final ScrollController _scrollController = ScrollController();
  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());

  var currentPosition = 0.0.obs;

  @override
  Widget build(BuildContext context) {
/*    myCartController.scrollController.addListener(() {
      myCartController.reLoadMoreData();
    });*/
    _scrollController.addListener(() {
      loadMoreData();
    });
    myCartController.fetchRecommendedProduct();
    //myCartController.fetchMyCartData();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBGColor,
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "Shopping Bag",
            color: Colors.white,
          ),
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(
          isCart: false,
        ),
        body: RefreshIndicator(
          color: AppColors.mainColorRed,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2),
                    () => myCartController.handelRefresh());
          },
          child: Obx(
            () => internetConnectionController.connectionStatus.value.contains(
                ConnectivityResult.none)
                ? const NoInternetConnectionPage()
                : myCartController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : bodyContent(),
          ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            (myCartController.myCartList.value.cart ?? []).isEmpty
                ? myCartController.myCartList.value.cart?.length !=
                        myCartController.itemsOnLocal.value
                    ? cartItemsShimmerSection()
                    : SliverToBoxAdapter(
                        child: EmptyCard(
                          image: "assets/images/empty-cart.png",
                          title: "Your Shopping Bag is Empty",
                          bodyText:
                              "Looks like you haven't made your choice yet...",
                          buttonText: "START SHOPPING",
                          bottomText: "",
                          onTap: () {
                            Get.offAllNamed("/home_page");
                          },
                        ),
                      )
                : SliverPadding(
                    padding: EdgeInsets.all(15.r),
                    sliver: cartItemsSection(),
                  ),

            if ((myCartController.myCartList.value.cartRules ?? []).isNotEmpty)
              SliverToBoxAdapter(child: cartOfferSection()),

            if ((myCartController.myCartList.value.cart ?? []).isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: summarySection(),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    top: 30.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(text: "Recommended For You"),
                      SizedBox(
                        height: 5.h,
                      ),
                      BodyText(text: "Tap item to add your basket")
                    ],
                  )),
            ),

            SliverPadding(
              padding: EdgeInsets.all(10.r),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return SingleGridItem(
                      productModel: myCartController.productList.value[index],
                      /*review:
                          myCartController.productList.value[index].reviewCount ??
                              0,
                      appPrice:
                          myCartController.productList.value[index].appPrice ?? 0,
                      regularPrice:
                          myCartController.productList.value[index].regularPrice ??
                              0,
                      proId: myCartController.productList.value[index].productId
                          .toString(),
                      isNewArrival:
                          myCartController.productList.value[index].isNew ?? 0,
                      imageUrl: myCartController.productList.value[index].image
                          .toString(),
                      proName: myCartController.productList.value[index].brandName
                          .toString(),
                      rating:
                          myCartController.productList.value[index].reviewRate ?? 0,
                      descriptionText:
                          myCartController.productList.value[index].name.toString(),
                      isFavourite:
                          myCartController.productList.value[index].isFav ?? 0,
                      isBackInStock:
                          myCartController.productList.value[index].isBack ?? 0,
                      isBestSeller:
                          myCartController.productList.value[index].isBestseller ??
                              0,
                      groupId:
                          myCartController.productList.value[index].groupId ?? 0,
                      productFrom:
                          myCartController.productList.value[index].productFrom ??
                              "",
                      discountPrice:
                          myCartController.productList.value[index].discountPrice ??
                              0,*/
                    );
                  },
                  childCount: myCartController.productList.value.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220.0,
                    //mainAxisExtent: 350,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: .5),
              ),
            ),
            if (myCartController.isLoadingMore.value)
              const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            // summarySection()
          ],
        ),
        if (myCartController.isReloading.value ||
            myCartController.isUpdating.value)
          Container(
            color: Colors.grey.withOpacity(.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Visibility(
          visible: currentPosition.value > Get.height * 10,
          child: Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: () => goToTop(),
              child: CircularButton(
                circleColor: AppColors.mainColorRed,
                bgColor: AppColors.mainColorRed,
                child: Icon(
                  Icons.arrow_drop_up_outlined,
                  size: 36.sp,
                ),
              ),
            ),
          ),
        )
      ],
    );

    /* SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Flex(
                 direction: Axis.vertical,
                children: [
                  cartItemsSection(),
                  SizedBox(
                    height: 10.h,
                  ),
                  summarySection(),

                ],
              ),
            ),
          );*/
  }

  Widget singleCartItem(int index) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: .5),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: (myCartController.myCartList.value.cart![index].available ??
                        0) <
                    (myCartController.myCartList.value.cart![index].quantity ??
                        0)
                ? Colors.red.withOpacity(.1)
                : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(10.r),
                  width: 50.w,
                  child: /*FadeInImage(
                    placeholder: const AssetImage("assets/images/no-image_card.jpg"),
                    image: NetworkImage(
                        "${myCartController.myCartList.value.cart![index].image}"),
                    imageErrorBuilder: (context, obj, track) =>
                        Image.asset("assets/images/no-image_card.jpg"),
                  ),*/
                      Image.network(
                    myCartController.myCartList.value.cart?[index].image ?? "",
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
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0.h, left: 10.w, right: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (myCartController
                                    .myCartList.value.cart![index].status ==
                                0)
                            ? HeaderText(
                                text: "Not Available",
                                color: Colors.red,
                                size: 15,
                              )
                            : (myCartController.myCartList.value.cart![index]
                                        .available ==
                                    0)
                                ? HeaderText(
                                    text: "Out of stock",
                                    color: Colors.red,
                                    size: 15,
                                  )
                                : ((myCartController.myCartList.value
                                                .cart![index].available ??
                                            0) <
                                        (myCartController.myCartList.value
                                                .cart![index].quantity ??
                                            0))
                                    ? HeaderText(
                                        text:
                                            "Available Quantity: ${(myCartController.myCartList.value.cart![index].available ?? 0)}",
                                        color: Colors.green,
                                        size: 15,
                                      )
                                    : const Text(""),
                        HeaderText(
                          text: myCartController
                                  .myCartList.value.cart?[index].name ??
                              "",
                          maxLine: 10,
                          fontWeight: FontWeight.normal,
                          size: 13,
                          align: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        if (myCartController
                                .myCartList.value.cart![index].colour !=
                            null)
                          HeaderText(
                            text:
                                "Color: ${myCartController.myCartList.value.cart![index].colour ?? ""} |"
                                " Size: ${myCartController.myCartList.value.cart![index].size ?? ""}",
                            size: 12,
                          ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0.w),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text:
                                  "৳${((myCartController.myCartList.value.cart?[index].pPrice!.toDouble())! * (myCartController.myCartList.value.cart![index].quantity!.toDouble())).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                              children: [
                                TextSpan(
                                  text:
                                      " (৳${myCartController.myCartList.value.cart?[index].pPrice!.toStringAsFixed(2) ?? 0}"
                                      " x ${myCartController.myCartList.value.cart![index].quantity})  ",
                                  style: TextStyle(
                                      color: AppColors.bodyTextColor,
                                      fontSize: 12.sp),
                                ),
                                if (myCartController.myCartList.value
                                        .cart![index].oldPriceStatus ==
                                    1)
                                  TextSpan(
                                    text:
                                        "   ৳${myCartController.myCartList.value.cart?[index].price!.toStringAsFixed(2) ?? 0}",
                                    style: TextStyle(
                                        color: AppColors.bodyTextColor,
                                        fontSize: 12.sp,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if ((myCartController.myCartList.value.cart?[index]
                                    .cartRuleTitle ??
                                "") !=
                            "")
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5, top: 5),
                            child:MyAnimatedText(sentence:myCartController.myCartList.value
                                .cart?[index].cartRuleTitle ??
                                "" ,) /*BodyText(
                              text: myCartController.myCartList.value
                                      .cart?[index].cartRuleTitle ??
                                  "",
                              color: AppColors.cart_rule_text_color,
                              maxLine: 5,
                              align: TextAlign.start,
                              size: 10,
                            ),*/
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  ignoring: (myCartController.myCartList.value
                                              .cart![index].quantity ??
                                          0) <=
                                      1,
                                  child: IconButton(
                                      onPressed: () {
                                        if (!myCartController
                                                .isUpdating.value &&
                                            (myCartController
                                                        .myCartList
                                                        .value
                                                        .cart![index]
                                                        .quantity ??
                                                    0) >
                                                1) {
                                          myCartController.updateCart(
                                              type: 1,
                                              cartId: myCartController
                                                  .myCartList
                                                  .value
                                                  .cart![index]
                                                  .cartId!);
                                        }
                                      },
                                      icon: Obx(
                                        () => Icon(
                                          Icons.remove,
                                          color: ((myCartController
                                                          .myCartList
                                                          .value
                                                          .cart?[index]
                                                          .quantity ??
                                                      0) <=
                                                  1)
                                              ? Colors.transparent
                                              : Colors.black,
                                        ),
                                      )),
                                ),
                                HeaderText(
                                  text:
                                      "${myCartController.myCartList.value.cart![index].quantity}",
                                  size: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                                IgnorePointer(
                                  ignoring: (myCartController.myCartList.value
                                              .cart![index].available ??
                                          0) <=
                                      (myCartController.myCartList.value
                                              .cart![index].quantity ??
                                          0),
                                  /*(myCartController.myCartList.value.cart![index].available??0)==0,*/
                                  child: IconButton(
                                    onPressed: () {
                                      if (!myCartController.isUpdating.value) {
                                        myCartController.updateCart(
                                            type: 2,
                                            cartId: myCartController.myCartList
                                                .value.cart![index].cartId!);
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    color: (myCartController.myCartList.value
                                                    .cart![index].available ??
                                                0) >
                                            (myCartController.myCartList.value
                                                    .cart![index].quantity ??
                                                0)
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            IgnorePointer(
                              ignoring: myCartController.isReloading.value,
                              child: InkWell(
                                onTap: () {
                                  // myCartController.isLoading.value=true;

                                  /*  if(myCartController.removedCardRuleIds.contains(myCartController.myCartList.value.cartRules?[index].id)){
                                      myCartController.removedCardRuleIds.remove(myCartController.myCartList.value.cartRules?[index].id);
                                    }*/

                                  myCartController.removeFromCart(
                                      myCartController.myCartList.value
                                          .cart![index].cartId!);
                                },
                                child: HeaderText(
                                  text: "X Remove",
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if ((myCartController.myCartList.value.cart![index].available ?? 0) <
              (myCartController.myCartList.value.cart![index].quantity ?? 0))
            Container(
              color: AppColors.mainColorRed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IgnorePointer(
                  ignoring: myCartController.isUpdating.value,
                  child: InkWell(
                    onTap: () {
                      myCartController.removeMultipleItemsFromCart(
                          myCartController
                              .myCartList.value.cart![index].cartId!,
                          (myCartController
                                      .myCartList.value.cart![index].quantity ??
                                  0) -
                              (myCartController.myCartList.value.cart![index]
                                      .available ??
                                  0));
                    },
                    child: HeaderText(
                      text:
                          "Click to remove ${(myCartController.myCartList.value.cart![index].quantity ?? 0) - (myCartController.myCartList.value.cart![index].available ?? 0)} quantities",
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget singleCartItemShimmer(int index) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: .5),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(10.r),
                width: 100.w,
                height: 100.h,
                child: const ShimmerSkeleton(),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10.0.h, left: 10.w, right: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerSkeleton(
                        width: 200.w,
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
                      ShimmerSkeleton(
                        width: 200.w,
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cartItemsSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return singleCartItem(index);
        },
        childCount: myCartController.myCartList.value.cart?.length ?? 0,
      ),
    );
  }

  Widget cartItemsShimmerSection() {
    return SliverPadding(
      padding: EdgeInsets.all(15.r),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return singleCartItemShimmer(index);
          },
          childCount: 4,
        ),
      ),
    );
  }

/*  Widget cartItemsSection() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount:
        myCartController.myCartList.value.cart?.length ?? 0,
        itemBuilder: (context, index) {
          return singleCartItem(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 1,
            color: Colors.grey,
          );
        },
      ),
    );
  }*/

  Widget summarySection() {
    return Container(
      color: Colors.white,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0.w, right: 10.w, top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Sub Total",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "৳${myCartController.myCartList.value.couponData!.subTotal!.toStringAsFixed(2)}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: myCartController.myCartList.value.couponData?.vip == 1
                      ? "Discount (VIP)"
                      : myCartController.myCartList.value.couponData?.loyal == 1
                          ? "Discount (Loyal)"
                          : "Discount (Regular)",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "- ৳${myCartController.myCartList.value.couponData!.regularDiscount!.toStringAsFixed(2)}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Mobile App Special Discount",
                  fontWeight: FontWeight.normal,
                ),
                HeaderText(
                  text:
                      "- ৳${myCartController.myCartList.value.couponData!.mobileAppSpecialDiscount!.toStringAsFixed(2)}",
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: .5.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "Total",
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: AppColors.mainColorRed,
                ),
                HeaderText(
                  text:
                      "৳${myCartController.myCartList.value.couponData!.total!.toStringAsFixed(2)}",
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: AppColors.mainColorRed,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }

  Widget cartOfferSection() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15.h),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HeaderText(
              text: "Cart Offers",
              size: 18,
              align: TextAlign.start,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myCartController.cartOfferProductsModule.length,
              itemBuilder: (buildContext, index) {
                return singleOfferProductItem(index);
              }),
          //  if ((myCartController.isChecked).isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: myCartController.myCartList.value.cartRules?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: .5),
                  ),
                ),
                child: Obx(
                  () => CheckboxListTile(
                    activeColor: Colors.blue,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: MyAnimatedText(sentence: myCartController
                          .myCartList.value.cartRules?[index].title ??
                          "",)
                      /*BodyText(
                        text: myCartController
                                .myCartList.value.cartRules?[index].title ??
                            "",
                        align: TextAlign.start,
                        color: AppColors.cart_rule_text_color,
                      )*/,
                      value: myCartController.selectedCartRuleIds.contains(
                          myCartController
                              .myCartList.value.cartRules?[index].id),
                      onChanged: (value) {
                        myCartController.isModifiedCartRule = true;
                        if (value ?? true) {
                          myCartController.removedCardRuleIds.remove(
                              myCartController
                                  .myCartList.value.cartRules?[index].id);

                          //  print(myCartController.removedCardRuleIds);

                          myCartController.selectedCartRuleIds.add(
                              myCartController
                                  .myCartList.value.cartRules?[index].id);
                          myCartController.updateOfferCart();
                        } else {
                          myCartController.removedCardRuleIds.add(
                              myCartController
                                  .myCartList.value.cartRules?[index].id);
                          myCartController.selectedCartRuleIds.remove(
                              myCartController
                                  .myCartList.value.cartRules?[index].id);
                          myCartController.updateOfferCart();
                        }
                      }),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void loadMoreData() {
    // currentPosition.value = _scrollController.position.pixels;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (myCartController.searchCategoryProductsModel.value.currentPage !=
              myCartController.searchCategoryProductsModel.value.lastPage &&
          !myCartController.isLoadingMore.value) {
        myCartController.isLoadingMore.value = true;
        myCartController.loadMoreData(myCartController
            .searchCategoryProductsModel.value.nextPageUrl
            .toString());
      }
    }
  }

  void goToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInToLinear);
  }

  Widget singleOfferProductItem(int index) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: .5),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(10.r),
                  width: 50.w,
                  child: Image.network(
                    myCartController
                            .cartOfferProductsModule.value[index].image ??
                        "",
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
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0.h, left: 10.w, right: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(
                          text: myCartController
                                  .cartOfferProductsModule.value[index].name ??
                              '',
                          maxLine: 10,
                          fontWeight: FontWeight.normal,
                          size: 13,
                          align: TextAlign.start,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0.w),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text:
                                  "৳${((myCartController.cartOfferProductsModule.value[index].salesPrice?.toDouble())! * (myCartController.cartOfferProductsModule.value[index].quantity!.toDouble())).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                              children: [
                                TextSpan(
                                  text:
                                      " (৳${myCartController.cartOfferProductsModule.value[index].salesPrice?.toStringAsFixed(2) ?? 0}"
                                      " x ${myCartController.cartOfferProductsModule.value[index].quantity})  ",
                                  style: TextStyle(
                                      color: AppColors.bodyTextColor,
                                      fontSize: 12.sp),
                                ),
                                TextSpan(
                                  text:
                                      " ৳ ${myCartController.cartOfferProductsModule.value[index].priceTaxInc}",
                                  style: TextStyle(
                                      color: AppColors.bodyTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  ignoring: (myCartController.myCartList.value
                                      .cart![index].quantity ??
                                      0) <=
                                      1,
                                  child: IconButton(
                                      onPressed: () {
                                        if (!myCartController
                                            .isUpdating.value &&
                                            (myCartController
                                                .myCartList
                                                .value
                                                .cart![index]
                                                .quantity ??
                                                0) >
                                                1) {
                                          myCartController.updateCart(
                                              1,
                                              myCartController.myCartList.value
                                                  .cart![index].cartId!);
                                        }
                                      },
                                      icon: Obx(
                                            () => Icon(
                                          Icons.remove,
                                          color: ((myCartController
                                              .myCartList
                                              .value
                                              .cart?[index]
                                              .quantity ??
                                              0) <=
                                              1)
                                              ? Colors.transparent
                                              : Colors.black,
                                        ),
                                      )),
                                ),
                                HeaderText(
                                  text:
                                  "${myCartController.myCartList.value.cart![index].quantity}",
                                  size: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                                IgnorePointer(
                                  ignoring: (myCartController.myCartList.value
                                      .cart![index].available ??
                                      0) <=
                                      (myCartController.myCartList.value
                                          .cart![index].quantity ??
                                          0),
                                  */
                        /*(myCartController.myCartList.value.cart![index].available??0)==0,*/ /*
                                  child: IconButton(
                                    onPressed: () {
                                      if (!myCartController.isUpdating.value) {
                                        myCartController.updateCart(
                                            2,
                                            myCartController.myCartList.value
                                                .cart![index].cartId!);
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    color: (myCartController.myCartList.value
                                        .cart![index].available ??
                                        0) >
                                        (myCartController.myCartList.value
                                            .cart![index].quantity ??
                                            0)
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            IgnorePointer(
                              ignoring: myCartController.isReloading.value,
                              child: InkWell(
                                onTap: () {
                                  // myCartController.isLoading.value=true;
                                  myCartController.removeFromCart(
                                      myCartController.myCartList.value
                                          .cart![index].cartId!);
                                },
                                child: HeaderText(
                                  text: "X Remove",
                                  color: Colors.red,
                                ),),
                            )
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
