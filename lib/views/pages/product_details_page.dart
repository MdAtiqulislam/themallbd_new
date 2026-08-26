import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:themallbd_new/models/reviews_model.dart';
import 'package:themallbd_new/widgets/single_list_product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/product_details_controller.dart';
import '../../controllers/related_product_controller.dart';
import '../../controllers/reviews_controller.dart';
import '../../controllers/user_controllers/add_review_controller.dart';
import '../../models/cart_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/cart_rule_details_dialog.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/image_slider.dart';
import 'package:intl/intl.dart';

import '../../widgets/my_animated_text.dart';
import '../../widgets/single_card_item_2.dart';
import '../screens/add_review.dart';
import '../screens/empty_cart.dart';
import 'no_internet_page.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key});

  //var categoryId = Get.arguments[1];
  var proId = Get.arguments[0];
  var groupId = Get.parameters['groupId'];
  var firstImage = Get.parameters["imageUrl"];
  PageController controller = PageController(initialPage: 0);

  var rowIndex = 0.obs;
  var imageURL = "".obs;
  var currentIndex = 0.obs;
  var quantity = 1.obs;
  var dotPosition = 0.obs;

  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  final ProductDetailsController productDetailsController =
      Get.put(ProductDetailsController());

  //final HomePageDataController homePageDataController = Get.put(HomePageDataController());

  final ReviewsController reviewsController = Get.put(ReviewsController());
  final RelatedProductController relatedProductController =
      Get.put(RelatedProductController());
  final AddReviewController addReviewController =
      Get.put(AddReviewController());

  final ScrollController _scrollController = ScrollController();

  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    //productDetailsController.images.value=[firstImage];
    productDetailsController.proId.value = proId;
    productDetailsController.fetchData();

    relatedProductController.key.value = proId;
    relatedProductController.fetchData();

/*    productDetailsController.isLoading.value
        ? imageURL.value
        : imageURL.value = productDetailsController
            .productDetailsModel.value.regularImages?[0]??"";*/

    if (!productDetailsController.isLoading.value &&
        (productDetailsController.productDetailsModel.value.regularImages ?? [])
            .isNotEmpty) {
      imageURL.value = productDetailsController
              .productDetailsModel.value.regularImages?[0] ??
          "";
    }

    /*if(!productDetailsController.isLoading.value){
      images.value+=productDetailsController
          .productDetailsModel.value.regularImages!;
    }*/

    // _tabController = TabController();

    return Obx(() => internetConnectionController.connectionStatus.value
            .contains(ConnectivityResult.none)
        ? const NoInternetConnectionPage()
        : portrait());
    /*ResponsiveHelper(

      landscape: landscape(),
      portrait: portrait()
    );*/
  }

  Widget dotIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: DotsIndicator(
          dotsCount: productDetailsController
              .productDetailsModel.value.regularImages!.length,
          position: dotPosition.value.toDouble(),
          decorator: DotsDecorator(
            activeColor: AppColors.mainColorRed,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  Widget longDescription() {
    return Html(
        data: productDetailsController.productDetailsModel.value.longDesc ?? "",
        onLinkTap: (String? url, //RenderContext context,
            Map<String, String> attributes,
            dom.Element? element) async {
          final Uri _url = Uri.parse(url!);
          if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $_url';
          }
        });
  }

  Widget reviews() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderText(
                text: "Average User Rating",
                size: 18,
                //fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: RatingBarIndicator(
                  rating: productDetailsController
                              .productDetailsModel.value.avgRating ==
                          null
                      ? 0.0
                      : productDetailsController
                          .productDetailsModel.value.avgRating
                          .toDouble(),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  itemCount: 5,
                  itemSize: 22.0.sp,
                  direction: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              BodyText(
                text:
                    "${(productDetailsController.productDetailsModel.value.avgRating ?? 0).toStringAsFixed(2)}"
                    "/5 from ${productDetailsController.productDetailsModel.value.reviewCount} reviews",
                align: TextAlign.center,
                size: 14,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                //width: 200,
                height: 50.h,
                child: InkWell(
                  onTap: () => _callBackAddReview(),
                  child: const AppButton(
                    alignment: MainAxisAlignment.center,
                    text: "Rate and Write Review",
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    textSize: 18,
                  ),
                ),
              ),
              BodyText(
                text: "You Can Add Rating and Review from Here",
                align: TextAlign.center,
                size: 10,
              )
            ],
          ),
        ),
        if (productDetailsController.showReviewSection.value)
          AddReview(
            proId: productDetailsController.productDetailsModel.value.productId
                .toString(), //proId,
          ),
        reviewsController.isLoading.value
            ? const Text(
                "") /*const Center(
                child: CircularProgressIndicator(),
              )*/
            : Container(
                color: Colors.white,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviewsController.reviewList?.length ?? 0,
                  itemBuilder: (BuildContext context, index) {
                    return singleReviewCard(
                        review: reviewsController.reviewList?[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                ),
              )
      ],
    );
  }

  Widget bottomButton() {
    return (productDetailsController.productDetailsModel.value.productIn ??
                0) >=
            1
        ? Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.5).toInt()),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IgnorePointer(
                        ignoring: quantity.value <= 1,
                        child: InkWell(
                          onTap: () {
                            if (quantity.value > 1) {
                              --quantity.value;
                            }
                          },
                          child: Icon(
                            Icons.remove_rounded,
                            color: quantity.value == 1
                                ? Colors.transparent
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      HeaderText(text: quantity.toString()),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: () {
                          if (quantity.value <
                              productDetailsController
                                  .productDetailsModel.value.productIn!) {
                            ++quantity.value;
                          }
                        },
                        child: Icon(
                          Icons.add,
                          color: (productDetailsController.productDetailsModel
                                              .value.productIn ??
                                          0)
                                      .toInt() <=
                                  quantity.value
                              ? Colors.transparent
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: IgnorePointer(
                    ignoring: productDetailsController.isUpdating.value,
                    child: InkWell(
                      onTap: () {
                        productDetailsController.addToCart(
                            CartModel(
                                product_id:
                                    productDetailsController.proId.value,
                                product_quantity: quantity.toString()),
                            false);

                        /*ShowSnackBar(
                    msg: "Item Added Successfully!",
                    title: "Success",
                    showButton: true,
                    duration: 5,
                    buttonText: "View Basket",
                    callback: () => showBasket(),
                  ).showSnackBar();*/
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5.w),
                        height: 40,
                        color: productDetailsController.isUpdating.value
                            ? Colors.grey
                            : Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                            ),
                            HeaderText(
                              text: "Add to cart".toUpperCase(),
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 50,
            width: Get.width,
            // margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            //color: AppColors.mainColorRed,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: AppButton(
                textColor: Colors.white,
                text: 'OUT OF STOCK',
                alignment: MainAxisAlignment.center,
                bgColor: AppColors.mainColorRed,
                icon: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  Widget imageSlider() {
    return Stack(
      children: [
        ImageSlider(
          // images:productDetailsController.images.value,
/*         images: productDetailsController
                  .productDetailsModel.value.regularImages ??[],*/
          images: productDetailsController.images.value,
          //images: [Get.parameters['imageUrl']],
          autoPlay: false,
          height:
              MediaQuery.of(Get.context!).orientation == Orientation.portrait
                  ? 400.0.h
                  : 400.w,
          showInnerDotIndicator: false,
        ),
        Positioned(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                if (productDetailsController
                        .productDetailsModel.value.isBestSeller ==
                    1)
                  Container(
                      margin: EdgeInsets.all(2.r),
                      width: 40.r,
                      height: 40.r,
                      child: Image.asset(
                          "assets/images/product_tags/best_seller.png")),
                if (productDetailsController.productDetailsModel.value.isFav ==
                    1)
                  Container(
                    margin: EdgeInsets.all(2.r),
                    width: 40.r,
                    height: 40.r,
                    child:
                        Image.asset("assets/images/product_tags/favourite.png"),
                  ),
                if (productDetailsController.productDetailsModel.value.isNew ==
                    1)
                  Container(
                    margin: EdgeInsets.all(2.r),
                    width: 40.r,
                    height: 40.r,
                    child: Image.asset(
                        "assets/images/product_tags/new_arrival.png"),
                  ),
                if (productDetailsController.productDetailsModel.value.isBack ==
                    1)
                  Container(
                      margin: EdgeInsets.all(2.r),
                      width: 40.r,
                      height: 40.r,
                      child: Image.asset(
                          "assets/images/product_tags/back_in_stock.png")),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20.w,
          top: 10.h,
          child: InkWell(
            onTap: () {
              /* productDetailsController.addToWishList();
              productDetailsController.checkWishList();*/
              productDetailsController.controlWishList();
            },
            child: Obx(
              () => Icon(
                productDetailsController.isWish.value
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: AppColors.mainColorPink,
                size: 48.sp,
                shadows: [
                  Shadow(
                    color: Colors.grey.withAlpha((255 * .5).toInt()),
                    offset: const Offset(0, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


  Widget suggestionProductSection(){
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productDetailsController.productDetailsModel.value.suggestingProducts?.length??0,
            gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(Get.context!).orientation ==
                    Orientation.portrait
                    ? 500
                    : 500.0,
                //mainAxisExtent: 350,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 3
            ),
            itemBuilder: (buildContext,index){
            var item=productDetailsController.productDetailsModel.value.suggestingProducts?[index];

              return SingleListProduct(
                  imageUrl: item?.image??'',
                  title: item?.name??'',
                  rating:  ( item?.reviewRate??0.0).toString(),
                  reviews: ( item?.reviewCount??0).toString(),
                  oldPrice: ( item?.regularPrice??0),
                  newPrice:  item?.discountPrice??0,
                onTap: (){
                  facebookAppEvents.logViewContent(
                      id:  item?.productId
                          .toString(),
                      type: "Product",
                      currency: "BDT",
                      price:  (item?.appPrice??0)
                          .toDouble() >
                          0.0
                          ?  (item?.appPrice??0)
                          .toDouble()
                          :  (item?.regularPrice??0)
                          .toDouble(),
                      content: {
                        "pro_name":
                        item?.name??""
                      });

                  proId =  item?.slug;
                  rowIndex.value = 0;
                  // imageURL = "".obs;
                  // firstImage=relatedProductController.productList[index].image.toString();
                  currentIndex.value = 0;
                  quantity.value = 1;
                  dotPosition.value = 0;
                  productDetailsController.reLoading.value = true;
                  productDetailsController.images.value = [];
                  if ( item?.productFrom ==
                      "life_style") {
                    var parameters = <String, String>{
                      "proId": proId,
                      "name":  item?.brandName??"",
                      'descriptionText':  item?.name??"",
                      'regularPrice':  (item?.regularPrice??0)
                          .toString(),
                      'appPrice':  (item?.appPrice??0)
                          .toString(),
                      'rating':  (item?.reviewRate??0).toString(),
                      'isBestSeller':  (item?.isBestseller)
                          .toString(),
                      'isFavourite':  (item?.isFav)
                          .toString(),
                      'isBackInStock':  (item?.isBack)
                          .toString(),
                      'isNewArrival':  (item?.isNew)
                          .toString(),
                      'review':  (item?.reviewCount)
                          .toString(),
                      'imageUrl':  (item?.image)
                          .toString(),
                      'groupId':  (item?.groupId)
                          .toString(),
                    };

                    Get.offAndToNamed('/life_style_product_details_page',
                        arguments: [
                          proId.toString(),
                        ],
                        parameters: parameters);
                  } else {
                    productDetailsController.proId.value = proId;
                    productDetailsController.fetchData();
                  }

                  relatedProductController.key.value = proId;
                  relatedProductController.fetchData();
                  //productDetailsController.proId.value=relatedProductController.productList![index].productId.toString();

                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                  );

                  //productDetailsController.checkWishList();
                },
              );
            }),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productDetailsController.productDetailsModel.value.alternativeProducts?.length??0,
            gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(Get.context!).orientation ==
                    Orientation.portrait
                    ? 500
                    : 500.0,
                //mainAxisExtent: 350,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 3
            ),
            itemBuilder: (buildContext,index){
              var item=productDetailsController.productDetailsModel.value.alternativeProducts?[index];

              return SingleListProduct(
                imageUrl: item?.image??'',
                title: item?.name??'',
                rating:  ( item?.reviewRate??0.0).toString(),
                reviews: ( item?.reviewCount??0).toString(),
                oldPrice: ( item?.regularPrice??0),
                newPrice:  item?.discountPrice??0,
                onTap: (){
                  facebookAppEvents.logViewContent(
                      id:  item?.productId
                          .toString(),
                      type: "Product",
                      currency: "BDT",
                      price:  (item?.appPrice??0)
                          .toDouble() >
                          0.0
                          ?  (item?.appPrice??0)
                          .toDouble()
                          :  (item?.regularPrice??0)
                          .toDouble(),
                      content: {
                        "pro_name":
                        item?.name??""
                      });

                  proId =  item?.slug;
                  rowIndex.value = 0;
                  // imageURL = "".obs;
                  // firstImage=relatedProductController.productList[index].image.toString();
                  currentIndex.value = 0;
                  quantity.value = 1;
                  dotPosition.value = 0;
                  productDetailsController.reLoading.value = true;
                  productDetailsController.images.value = [];
                  if ( item?.productFrom ==
                      "life_style") {
                    var parameters = <String, String>{
                      "proId": proId,
                      "name":  item?.brandName??"",
                      'descriptionText':  item?.name??"",
                      'regularPrice':  (item?.regularPrice??0)
                          .toString(),
                      'appPrice':  (item?.appPrice??0)
                          .toString(),
                      'rating':  (item?.reviewRate??0).toString(),
                      'isBestSeller':  (item?.isBestseller)
                          .toString(),
                      'isFavourite':  (item?.isFav)
                          .toString(),
                      'isBackInStock':  (item?.isBack)
                          .toString(),
                      'isNewArrival':  (item?.isNew)
                          .toString(),
                      'review':  (item?.reviewCount)
                          .toString(),
                      'imageUrl':  (item?.image)
                          .toString(),
                      'groupId':  (item?.groupId)
                          .toString(),
                    };

                    Get.offAndToNamed('/life_style_product_details_page',
                        arguments: [
                          proId.toString(),
                        ],
                        parameters: parameters);
                  } else {
                    productDetailsController.proId.value = proId;
                    productDetailsController.fetchData();
                  }

                  relatedProductController.key.value = proId;
                  relatedProductController.fetchData();
                  //productDetailsController.proId.value=relatedProductController.productList![index].productId.toString();

                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                  );

                  //productDetailsController.checkWishList();
                },
              );
            }),

      ],
    );
  }



  tabSection() {
    return Container(
      color: AppColors.bgColorOffLight,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              rowIndex.value = 0;
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.r),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: rowIndex.value == 0
                            ? Colors.black
                            : Colors.transparent)),
              ),
              child: const Center(
                child: Text(
                  "Details",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              rowIndex.value = 1;
              final box = Get.context!.findRenderObject() as RenderBox?;

              await Share.share(
                productDetailsController.productDetailsModel.value.shareLink
                    .toString(),
                subject: "subject",
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: rowIndex.value == 1
                            ? Colors.black
                            : Colors.transparent)),
              ),
              child: const Center(
                child: Text(
                  "Share",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              rowIndex.value = 2;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 3,
                        color: rowIndex.value == 2
                            ? Colors.black
                            : Colors.transparent)),
              ),
              child: const Center(
                child: Text(
                  "Video",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (!productDetailsController.isLoading.value)
            InkWell(
              onTap: () {
                rowIndex.value = 3;
                if (productDetailsController
                        .productDetailsModel.value.reviewCount! >
                    0) {
                  reviewsController.key.value = productDetailsController
                      .productDetailsModel.value.productId
                      .toString();
                  reviewsController.isLoading.value = true;
                  reviewsController.fetchData();
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 3,
                          color: rowIndex.value == 3
                              ? Colors.black
                              : Colors.transparent)),
                ),
                child: const Center(
                  child: Text(
                    "Review",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget relatedProductSection() {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: HeaderText(
              text: "Related Products",
              align: TextAlign.start,
              size: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: const Divider(
              thickness: 1,
            ),
          ),
          GridView.builder(
            itemCount: relatedProductController.productList.value.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(Get.context!).orientation ==
                        Orientation.portrait
                    ? 260
                    : 220.0,
                //mainAxisExtent: 350,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: .5),
            itemBuilder: (BuildContext context, int index) {
              return SingleCardItem2(
                productsModel: relatedProductController.productList[index],
                callback: () {
                  facebookAppEvents.logViewContent(
                      id: relatedProductController.productList[index].productId
                          .toString(),
                      type: "Product",
                      currency: "BDT",
                      price: relatedProductController
                                  .productList[index].appPrice
                                  .toDouble() >
                              0.0
                          ? relatedProductController.productList[index].appPrice
                              .toDouble()
                          : relatedProductController
                              .productList[index].regularPrice
                              .toDouble(),
                      content: {
                        "pro_name":
                            relatedProductController.productList[index].name
                      });

                  proId = relatedProductController.productList[index].slug;
                  rowIndex.value = 0;
                  // imageURL = "".obs;
                  // firstImage=relatedProductController.productList[index].image.toString();
                  currentIndex.value = 0;
                  quantity.value = 1;
                  dotPosition.value = 0;
                  productDetailsController.reLoading.value = true;
                  productDetailsController.images.value = [];
                  if (relatedProductController.productList[index].productFrom ==
                      "life_style") {
                    var parameters = <String, String>{
                      "proId": proId,
                      "name": relatedProductController
                          .productList[index].brandName
                          .toString(),
                      'descriptionText': relatedProductController
                          .productList[index].name
                          .toString(),
                      'regularPrice': relatedProductController
                          .productList[index].regularPrice
                          .toString(),
                      'appPrice': relatedProductController
                          .productList[index].appPrice
                          .toString(),
                      'rating': relatedProductController
                          .productList[index].reviewRate
                          .toString(),
                      'isBestSeller': relatedProductController
                          .productList[index].isBestseller
                          .toString(),
                      'isFavourite': relatedProductController
                          .productList[index].isFav
                          .toString(),
                      'isBackInStock': relatedProductController
                          .productList[index].isBack
                          .toString(),
                      'isNewArrival': relatedProductController
                          .productList[index].isNew
                          .toString(),
                      'review': relatedProductController
                          .productList[index].reviewCount
                          .toString(),
                      'imageUrl': relatedProductController
                          .productList[index].image
                          .toString(),
                      'groupId': relatedProductController
                          .productList[index].groupId
                          .toString(),
                    };

                    Get.offAndToNamed('/life_style_product_details_page',
                        arguments: [
                          proId.toString(),
                        ],
                        parameters: parameters);
                  } else {
                    productDetailsController.proId.value = proId;
                    productDetailsController.fetchData();
                  }

                  relatedProductController.key.value = proId;
                  relatedProductController.fetchData();
                  //productDetailsController.proId.value=relatedProductController.productList![index].productId.toString();

                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                  );

                  //productDetailsController.checkWishList();
                },
              );
            },
          ),
        ],
      ),
    );

    /*ProductGrid(
      viewShowMoreButton: false,
      showMoreTag: "",
      blockTitle: "Related Products",
      products: relatedProductController.productList,
    );*/
  }

  void _callBackAddReview() {
    productDetailsController.controlReviewSection();
  }

  reviewsSection() {
    return productDetailsController.productDetailsModel.value.reviewCount == 0
        ? Column(
            children: [
              EmptyCard(
                onTap: () => _callBackAddReview(),
                title: "No Review Found",
                bodyText: "This Product have not made any review yet...",
                buttonText: "Rate and Write Review",
                bottomText: "You Can Add Rating and Review from Here",
              ),
              if (productDetailsController.showReviewSection.value)
                AddReview(
                  proId: productDetailsController
                      .productDetailsModel.value.productId
                      .toString(),
                )
            ],
          )
        : reviews();
  }

  Widget portrait() {
    return Obx(
      () => Stack(
        children: [
          SafeArea(
            child: Scaffold(
              appBar: const CustomAppBar(),
              bottomNavigationBar: productDetailsController.isLoading.value
                  ? const Text("")
                  : bottomButton(),
              body: RefreshIndicator(
                color: AppColors.mainColorRed,
                backgroundColor: Colors.white,
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 2),
                      () => productDetailsController.handelRefresh());
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      //Slider Images
                      imageSlider(),

                      //Product info ..Name, Description, price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),

                                //Name section
                                HeaderText(
                                    text: (productDetailsController
                                            .productDetailsModel
                                            .value
                                            .brandName) ??
                                        (Get.parameters["name"] ?? ""),
                                    align: TextAlign.start),
                                SizedBox(
                                  height: 5.h,
                                ),

                                //Short Description Section
                                BodyText(
                                  text:
                                      "${productDetailsController.productDetailsModel.value.name ?? Get.parameters["descriptionText"]}",
                                  align: TextAlign.start,
                                  size: 14,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),

                                //Rating Section
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        rowIndex.value = 3;
                                        if (productDetailsController
                                                .productDetailsModel
                                                .value
                                                .reviewCount! >
                                            0) {
                                          reviewsController.key.value =
                                              productDetailsController
                                                  .productDetailsModel
                                                  .value
                                                  .productId
                                                  .toString();
                                          reviewsController.isLoading.value =
                                              true;
                                          reviewsController.fetchData();
                                        }
                                        _scrollController.animateTo(
                                          MediaQuery.of(Get.context!)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? 800.0.h
                                              : 600.w,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.decelerate,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RatingBarIndicator(
                                            rating: productDetailsController
                                                    .productDetailsModel
                                                    .value
                                                    .avgRating
                                                    ?.toDouble() ??
                                                0.0,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: AppColors.headerTextColor,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          BodyText(
                                              text:
                                                  "(${productDetailsController.productDetailsModel.value.reviewCount ?? Get.parameters["review"]} Reviews)",
                                              align: TextAlign.start)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        HeaderText(
                                          text:
                                              "৳${productDetailsController.productDetailsModel.value.discountPrice ?? Get.parameters["regularPrice"]}",
                                          align: TextAlign.center,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        if ((productDetailsController
                                                    .productDetailsModel
                                                    .value
                                                    .regularPrice ??
                                                0) !=
                                            (productDetailsController
                                                    .productDetailsModel
                                                    .value
                                                    .discountPrice ??
                                                0.toInt()))
                                          Text(
                                            "৳${productDetailsController.productDetailsModel.value.regularPrice ?? Get.parameters["regularPrice"]}",
                                            style: TextStyle(
                                                color:
                                                    AppColors.headerTextColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    if ((productDetailsController
                                                .productDetailsModel
                                                .value
                                                .appPrice ??
                                            0) >
                                        0)
                                      Center(
                                        child: HeaderText(
                                          text:
                                              "App Price: ৳${productDetailsController.productDetailsModel.value.appPrice ?? Get.parameters["appPrice"]}",
                                          align: TextAlign.center,
                                          size: 20,
                                          color: AppColors.mainColorRed,
                                        ),
                                      ),
                                    SizedBox(height: 10.h),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: Get.context!,
                                            builder: (buildContext) {
                                              return CartRuleDetailsDialog(
                                                  description:
                                                      productDetailsController
                                                              .productDetailsModel
                                                              .value
                                                              .cartRuleDescription ??
                                                          "");
                                            });
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: MyAnimatedText(
                                            sentence: productDetailsController
                                                    .productDetailsModel
                                                    .value
                                                    .cartRuleTitle ??
                                                "",
                                            fontSize: 14,
                                          )

                                          /*BodyText(
                                          text:productDetailsController.productDetailsModel.value.cartRuleTitle??"",
                                          color: AppColors.cart_rule_text_color,
                                          maxLine: 5,
                                          align: TextAlign.start,
                                          size: 14,
                                        ),*/
                                          ),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                ),
                                //Description Section
                                HeaderText(
                                    text: "Description",
                                    align: TextAlign.start),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Html(
                                  data: productDetailsController
                                          .productDetailsModel
                                          .value
                                          .shortDesc ??
                                      "",
                                ),
                              ],
                            ),
                          ),

                          // _tabSection(context),
                          suggestionProductSection(),

                          tabSection(),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                if (rowIndex.value == 0) longDescription(),

                                // if (rowIndex.value == 1) openShare(),

                                if (rowIndex.value == 2)
                                  emptyCard(
                                      subTitle:
                                          'Sorry! This product does not have any video link',
                                      title: 'No Video Found'),
                                if (rowIndex.value == 3) reviewsSection(),
                                SizedBox(
                                  height: 20.h,
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                          //Related Product Section
                          if (!relatedProductController.isLoading.value)
                            relatedProductSection()
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          /* Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: Colors.red.shade100,
                  elevation: 0,
                  onPressed: (){},
                child: Badge(
                  label: HeaderText(text: "5",color: Colors.white,size: 12,fontWeight: FontWeight.normal,),
                  alignment:AlignmentDirectional.centerEnd,
                  child: Icon(
                    Icons.shopping_bag_outlined,color: AppColors.mainColorRed,
                  size: 40.sp,),
                ),),
          ),*/

          if (addReviewController.isLoading.value ||
              productDetailsController.reLoading.value)
            Container(
              width: Get.width,
              height: Get.height,
              color: Colors.grey.withOpacity(.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  Widget landscape() {
    return Obx(() => productDetailsController.isLoading.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: .05,
              // iconTheme: const IconThemeData(color: Colors.black),
              title: const Text(
                "TheMall",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                InkWell(
                  child: Row(
                    children: [
                      const Text(
                        "Hello Guest",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        //width: 20,
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 2, bottom: 2),
                        margin: const EdgeInsets.only(left: 5, right: 15),
                        decoration: const BoxDecoration(
                            color: AppColors.mainColorRed,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  onTap: () {},
                ),
              ],
              actionsIconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () {
                            return Column(
                              children: [
                                Container(
                                  height: 250.h,
                                  width: Get.width / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.r)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            imageURL.value.toString(),
                                          ),
                                          fit: BoxFit.fill)),
                                ),
                                /*Obx(
                          () => sliderImagesController.isLoading.value
                              ? Container(
                                  height: 250.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/loading_image.png",
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                )
                              : Container(
                                  width: 200.w,
                                  child: ImageSlider(
                                    images: sliderImagesController.images,
                                    autoPlay: false,
                                    height: 150.w,
                                  ),
                                ),
                        ),*/
                                SizedBox(
                                  height: 100.h,
                                  width: Get.width / 2,
                                  child: ListView.builder(
                                    itemCount: productDetailsController
                                        .productDetailsModel
                                        .value
                                        .regularImages!
                                        .length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: InkWell(
                                          onTap: () {
                                            imageURL.value =
                                                productDetailsController
                                                    .productDetailsModel
                                                    .value
                                                    .regularImages![i];
                                            currentIndex.value = i;
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      productDetailsController
                                                          .productDetailsModel
                                                          .value
                                                          .regularImages![i]
                                                          .toString()),
                                                  colorFilter: currentIndex
                                                              .value ==
                                                          i
                                                      ? ColorFilter.mode(
                                                          Colors.black
                                                              .withOpacity(0),
                                                          BlendMode.darken)
                                                      : ColorFilter.mode(
                                                          Colors.black
                                                              .withOpacity(.7),
                                                          BlendMode.darken),
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              HeaderText(
                                  text: "Others", align: TextAlign.start),
                              SizedBox(
                                height: 10.h,
                              ),
                              BodyText(
                                text:
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
                                align: TextAlign.start,
                                size: 14,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RatingBarIndicator(
                                    rating: 5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: AppColors.headerTextColor,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  BodyText(
                                      text: "(5 Reviews)",
                                      align: TextAlign.start)
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  HeaderText(
                                    text: "৳229",
                                    align: TextAlign.center,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "৳380",
                                    style: TextStyle(
                                        color: AppColors.headerTextColor,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: HeaderText(
                                  text: "App Price: ৳218",
                                  align: TextAlign.center,
                                  size: 20,
                                  color: AppColors.mainColorRed,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              HeaderText(
                                  text: "Description", align: TextAlign.start),
                              SizedBox(
                                height: 10.h,
                              ),
                              const Text(
                                "This refreshing facewash is 100% soap-free.This vegan face wash removes dirt,oil and impurities.Leaving skin feeling refreshed and revived.No colours, no perfume, no harsh chemicals that can upset your skin.Perfect for even the most sensitive skin.Made in EU.",
                                style: TextStyle(height: 1.4),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const DefaultTabController(
                    length: 4,
                    child: TabBar(
                      labelColor: AppColors.headerTextColor,
                      indicatorColor: AppColors.headerTextColor,
                      unselectedLabelColor: AppColors.bodyTextColor,
                      tabs: [
                        Tab(
                          text: "Details",
                        ),
                        Tab(
                          text: "Share",
                        ),
                        Tab(
                          text: "Video",
                        ),
                        Tab(
                          text: "Reviews",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  relatedProductSection()
                ],
              ),
            ),
          ));
  }

  Widget emptyCard({required String title, required String subTitle}) {
    return EmptyCard(
      title: title,
      bodyText: subTitle,
      showButton: false,
    );
  }

  Widget singleReviewCard({ReviewsModel? review}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black26),
          borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Row(
                      children: [
                        HeaderText(
                          text: "${review?.rating?.toDouble()}",
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
                HeaderText(text: review?.title ?? "")
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: BodyText(
                text: review?.review ?? "",
                align: TextAlign.start,
                maxLine: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.black26,
              height: .5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BodyText(
                    text: "${review?.reviewBy?.firstName ?? ""}"
                        " ${review?.reviewBy?.lastName ?? ""}",
                    size: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    DateFormat('dd MMM yyyy')
                        .format(review?.createdAt ?? DateTime.now()),
                    style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.bodyTextColor),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 15,
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 15,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_down_alt_outlined,
                        size: 15,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          leading: const Icon(Icons.report),
                          title: const Text('Report Abuse'),
                          onTap: () {
                            // Handle the report abuse action
                            Get.back(); // Close the bottom sheet
                            productDetailsController.openReportPage(review: review??ReviewsModel());

                          },
                        ),
                      ),
                      backgroundColor: Colors.white,
                      // Add background color if needed
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
