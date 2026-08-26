import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/home_page_models/home_page_product_model.dart';
import 'single_card_item.dart';

class SearchProductGrid extends StatelessWidget {
  final List<ProductsModel>? products;

  const SearchProductGrid(
      {Key? key,
        required this.products,
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: products!.isNotEmpty,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: 10.0.w, right: 10.w),
                  child: GridView.builder(
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: .5
                      ),
                      itemCount: products!.length,
                      //homePageDataController.homePageBackInStock.value.products!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleGridItem(
                          productModel: products![index],
                         /* proId: products![index].id.toString(),
                          imageUrl: products![index].thumbnailImage??"",
                          proName: products![index].productName??"Name",
                          descriptionText: products![index].productName??"Description",
                          regularPrice: 300,
                          appPrice: 290,
                          rating:4,
                          review: 99,
                          isBestSeller: products![index].isBestseller??0,
                          isFavourite: products![index].isFav??0,
                          isNewArrival: products![index].isNew??0,
                          isBackInStock: products![index].isBack??0,
                          discountPrice:0,
                          productFrom: "",
                          groupId: 0,
                          categoryId: '13',*/
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}








/*class ProductGridWithoutBanner extends StatelessWidget {
  List<ProductsModel>? products;
  String? blockTitle;

  ProductGridWithoutBanner({Key? key,
    this.blockTitle = "Title",
    this.products = const [],})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: HeaderText(
              text: blockTitle.toString(), align: TextAlign.start),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
          child: Divider(),
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: .5
            ),
           *//* gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).orientation==Orientation.portrait?2:4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio:
              .5,
            ),*//*
            itemCount: products!.length,
            //homePageDataController.homePageBackInStock.value.products!.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleCardItem(
                image_url: products![index].image.toString(),
                proName: products![index].brandName,
                descriptionText: products![index].name,
                regularPrice: products![index].regularPrice,
                appPriec: products![index].appPrice,
                rating: products![index].reviewRate,
                review: products![index].reviewCount,
              );
            }),
      ],
    );
  }
}*/
