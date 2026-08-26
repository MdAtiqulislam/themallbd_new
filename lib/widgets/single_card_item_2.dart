import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../models/home_page_models/home_page_product_model.dart';

class SingleCardItem2 extends StatelessWidget {
  ProductsModel productsModel;
  VoidCallback? callback;

  SingleCardItem2({
    Key? key,
    required this.productsModel,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        //color: Colors.amber,
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        child: Flex(
          //crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            //pro image
            Flexible(
              fit: FlexFit.tight,
              flex: 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    errorWidget: (buildContext, s, d) =>
                        Image.asset('assets/images/no-image_card.jpg'),
                    placeholder: (context, url) =>
                        Image.asset('assets/images/no-image_card.jpg'),
                    imageUrl: (productsModel.image.toString()),
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (productsModel.isFav == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 40.r,
                            height: 40.r,
                            child: Image.asset(
                                "assets/images/product_tags/favourite.png")),
                      if (productsModel.isBestseller == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 40.r,
                            height: 40.r,
                            child: Image.asset(
                                "assets/images/product_tags/best_seller.png")),
                      if (productsModel.isNew == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 40.r,
                            height: 40.r,
                            child: Image.asset(
                                "assets/images/product_tags/new_arrival.png")),
                      if (productsModel.isBack == 1)
                        Container(
                            margin: EdgeInsets.all(2.r),
                            width: 40.r,
                            height: 40.r,
                            child: Image.asset(
                                "assets/images/product_tags/back_in_stock.png")),
                    ],
                  ),
                  if ((productsModel.productIn ?? 0) < 1)
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
                          size: 18,
                          text: productsModel.brandName ?? "",
                        ),
                      ),
                      //pro description
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, top: 5.h),
                        child: BodyText(
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                          maxLine: 2,
                          text: productsModel.name ?? "",
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
                              text: "৳${productsModel.discountPrice}",
                            ),
                          ),
                          if (productsModel.regularPrice !=
                              productsModel.discountPrice)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5.w, right: 5.w, top: 5.h),
                              child: Text(
                                "৳${productsModel.regularPrice}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      ),
                      //app price
                      if((productsModel.appPrice??0.0)>0)Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                        ),
                        child: BodyText(
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                          color: AppColors.mainColorRed,
                          text: "App Price ৳${productsModel.appPrice}",
                        ),
                      ),
                      //rating
                      Padding(
                        padding:
                            EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                        child: Row(
                          children: [
                            RatingBarIndicator(
                              rating:
                                  (productsModel.reviewRate ?? 0).toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.mainColorPink,
                              ),
                              itemCount: 5,
                              itemSize: 10.0.sp,
                              direction: Axis.horizontal,
                            ),
                            BodyText(
                                text: "(${productsModel.reviewCount} Reviews)",
                                align: TextAlign.start)
                          ],
                        ),
                      ),
                    ],
                  ),
                  /*if ((productsModel.productIn!) < 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      width: 30,
                      height: 30,
                      child: Image.asset(
                          "assets/images/product_tags/out-of-stock.png"),
                    )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
