import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../models/home_page_models/home_page_product_model.dart';
import 'my_animated_text.dart';

FacebookAppEvents facebookAppEvents = FacebookAppEvents();

class SingleGridItem extends StatelessWidget {
  final String? proId;
  final String? imageUrl;
  final String? proName;
  final String? descriptionText;
  final dynamic regularPrice;
  final dynamic discountPrice;
  final dynamic appPrice;
  final dynamic rating;
  final int? review;
  final int? isFavourite;
  final int? isBestSeller;
  final int? isNewArrival;
  final int? isBackInStock;
  final String? categoryId;
  final String? productFrom;
  final int? groupId;
  final ProductsModel productModel;

  const SingleGridItem(
      {super.key,
      this.proId,
      this.imageUrl,
      this.proName,
      this.descriptionText,
      this.regularPrice,
      this.appPrice,
      this.rating,
      this.review,
      this.isBestSeller,
      this.isFavourite,
      this.isBackInStock,
      this.isNewArrival,
      this.groupId,
      this.productFrom,
      this.discountPrice,
      this.categoryId = "",
      required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          facebookAppEvents.logViewContent(
              id: productModel.productId.toString(),
              type: "Product",
              currency: "BDT",
              price: productModel.appPrice.toDouble() > 0.0
                  ? productModel.appPrice.toDouble()
                  : productModel.regularPrice.toDouble(),
              content: {"proname": productModel.name});

          var parameters = <String, String>{
            "proId": productModel.productId.toString(),
            "name": productModel.brandName ?? "",
            'descriptionText': productModel.name ?? "",
            'regularPrice': productModel.regularPrice.toString(),
            'appPrice': productModel.appPrice.toString(),
            'rating': productModel.reviewRate.toString(),
            'isBestSeller': productModel.isBestseller.toString(),
            'isFavourite': productModel.isFav.toString(),
            'isBackInStock': productModel.isBack.toString(),
            'isNewArrival': productModel.isNew.toString(),
            'review': productModel.reviewCount.toString(),
            'imageUrl': productModel.image.toString(),
            'groupId': productModel.groupId.toString(),
          };

          if (productModel.productFrom == "life_style") {

            Get.toNamed('/life_style_product_details_page',
                arguments: [
                 // productModel.productId.toString(),
                  productModel.slug,
                  categoryId,
                ],
                parameters: parameters);
          } else {
            Get.toNamed('/product_details_page',
                arguments: [
                  productModel.slug,
                  categoryId,
                ],
                parameters: parameters);
          }
        },
        child: Flex(
          //crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            //pro image
            Flexible(
              fit: FlexFit.tight,
              flex: 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    errorWidget: (buildContext, s, d) =>
                        Image.asset('assets/images/no-image_card.jpg'),
                    placeholder: (context, url) =>
                        Image.asset('assets/images/no-image_card.jpg'),
                    imageUrl: (productModel.image ?? ""),
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (productModel.isFav == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 35.r,
                            height: 35.r,
                            child: Image.asset(
                                "assets/images/product_tags/favourite.png")),
                      if (productModel.isBestseller == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 35.r,
                            height: 35.r,
                            child: Image.asset(
                                "assets/images/product_tags/best_seller.png")),
                      if (productModel.isNew == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 35.r,
                            height: 35.r,
                            child: Image.asset(
                                "assets/images/product_tags/new_arrival.png")),
                      if (productModel.isBack == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 35.r,
                            height: 35.r,
                            child: Image.asset(
                                "assets/images/product_tags/back_in_stock.png")),
                    ],
                  ),
                  if ((productModel.productIn ?? 0) < 1)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              50.r,
                            ),
                            bottomLeft: Radius.circular(50.r)),
                        elevation: 2,
                        color: AppColors.mainColorRed,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 15.w, right: 5.w, top: 5.h, bottom: 5.h),
                          child: HeaderText(
                            text: "Out Of Stock",
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  /* Positioned(
                      bottom: 10,
                      left: 5,
                      right: 5,
                      child: BodyText(text: "Buy 1 'Absolute New-york Woter-proof Gel Eye-liner' Get 50tk off.",color: AppColors.cart_rule_text_color,maxLine: 5,align: TextAlign.start,size: 10,))*/
                ],
              ),
            ),
            //pro name

            Flexible(
              flex: 9,
              fit: FlexFit.tight,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, top: 5.h),
                        child: HeaderText(
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                          size: 15,
                          text: productModel.brandName ?? "",
                        ),
                      ),
                      //pro description
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, top: 5.h),
                        child: BodyText(
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                          maxLine: 2,
                          size: 11,
                          text: productModel.name ?? "",
                        ),
                      ),
                      //regular price
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 5.h),
                            child: HeaderText(
                              align: TextAlign.left,
                              fontWeight: FontWeight.normal,
                              text: "৳${productModel.discountPrice ?? 0}",
                            ),
                          ),
                          if (productModel.regularPrice !=
                              productModel.discountPrice)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5.w, right: 5.w, top: 5.h),
                              child: Text(
                                "৳${productModel.regularPrice ?? 0}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.spMin),
                              ),
                            ),
                        ],
                      ),
                      //app price
                     if((productModel.appPrice??0.0)>0)
                       Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                        ),
                        child: BodyText(
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                          color: AppColors.mainColorRed,
                          text: "App Price ৳${productModel.appPrice ?? 0}",
                        ),
                      ),

                      Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 5.0),
                        child: MyAnimatedText(sentence: productModel.cartRuleTitle,fontSize: 11,maxLine: 3,)
                        /*BodyText(
                          text:"${productModel.cartRuleTitle}",
                          color: AppColors.cart_rule_text_color,
                          maxLine: 2,
                          align: TextAlign.start,
                          size: 10,
                        )*/,
                      ),
                      //rating
                      Padding(
                        padding:
                            EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                        child: Row(
                          children: [
                            RatingBarIndicator(
                              rating: (productModel.reviewRate ?? 0).toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.mainColorPink,
                              ),
                              itemCount: 5,
                              itemSize: 10.0.spMin,
                              direction: Axis.horizontal,
                            ),
                            BodyText(
                                text:
                                    "(${productModel.reviewCount ?? 0} Reviews)",
                                align: TextAlign.start)
                          ],
                        ),
                      ),
                    ],
                  ),
                  /*if((productModel.productIn??0)<1)Positioned(
                      bottom: 10,
                      right: 10,
                      width: 30,
                      height: 30,
                      child: Image.asset("assets/images/product_tags/out-of-stock.png"))*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
