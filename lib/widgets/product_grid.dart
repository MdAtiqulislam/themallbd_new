import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/header_text.dart';
import '../../models/home_page_models/home_page_product_model.dart';

import '../constraints/app_strings.dart';
import 'load_more_button.dart';
import 'single_card_item.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductsModel>? products;
  final String? imageUrl;
  final String? blockTitle;
  final String showMoreTag;
  final bool viewShowMoreButton;

  const ProductGrid(
      {super.key,
      this.blockTitle = "",
      required this.products,
      this.imageUrl = "",
      this.viewShowMoreButton = true,
      required this.showMoreTag});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: products!.isNotEmpty,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: blockTitle!.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.all(20.0.h),
                child: HeaderText(
                  text: blockTitle.toString(),
                  align: TextAlign.center,
                  size:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 16.h
                          : 16.w,
                ),
              ),
            ),
            Stack(
              children: [
                //image
                Visibility(
                  visible: (imageUrl ?? "").isNotEmpty,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      imageUrl ?? "",
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
                ),
                Column(
                  children: [
                    Visibility(
                      visible: (imageUrl ?? "").isNotEmpty,
                      child: SizedBox(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 175.spMin
                              : 175.spMax),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: GridView.builder(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      MediaQuery.of(Get.context!).orientation ==
                                              Orientation.portrait
                                          ? 250.0
                                          : 220,
                                  //mainAxisExtent: 350,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: .45),
                          itemCount: products!.length,
                          //homePageDataController.homePageBackInStock.value.products!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleGridItem(
                              productModel: products![index],
                              proId: products![index].productId.toString(),
                              imageUrl: products![index].image ?? "",
                              proName: products![index].brandName ?? "Name",
                              descriptionText:
                                  products![index].name ?? "Description",
                              regularPrice:
                                  products![index].regularPrice ?? 0.0,
                              appPrice: products![index].appPrice ?? 0.0,
                              rating: products![index].reviewRate ?? 0,
                              review: products![index].reviewCount ?? 0,
                              isBackInStock: products![index].isBack ?? 0,
                              isBestSeller: products![index].isBestseller ?? 0,
                              isNewArrival: products![index].isNew ?? 0,
                              isFavourite: products![index].isFav ?? 0,
                              groupId: products![index].groupId ?? 0,
                              productFrom: products![index].productFrom ?? "",
                              discountPrice:
                                  products![index].discountPrice ?? 0.0,
                              categoryId: '13',
                            );
                          }),
                    ),
                  ],
                )
              ],
            ),
            Visibility(
              visible: viewShowMoreButton,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/test', arguments: [
                        "${AppStrings.filterByProductTypeEndPoint}$showMoreTag",
                        blockTitle!.toUpperCase()
                      ]);
                    },
                    child: const LoadMoreButton(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
