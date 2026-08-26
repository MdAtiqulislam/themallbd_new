import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../models/home_page_models/home_page_category_model.dart';

class HomeCategoryGrid extends StatelessWidget {
  final bool isLoading;
  final List<HomePageCategoryModel> productList;

  const HomeCategoryGrid(
      {super.key, this.isLoading = true, required this.productList});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColorRed,
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GridView.builder(
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, top: 30.h, bottom: 30.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                          //childAspectRatio: .7

                          /*
                           */ /*MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.3)*/
                        ),
                        itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return /*GridTile(
                            footer:Text(homePageDataController.homePageSkinTypeList[index].name.toString()) ,
                            child: Container(
                              color: Colors.red,
                              child: Image.network(
                                homePageDataController
                                    .homePageSkinTypeList[index].image!.thumbnail
                                    .toString(),
                              ),
                            ),
                          );*/

                              InkWell(
                            onTap: () {
                              /*Get.toNamed("/search_category_product",
                                  arguments: "${AppStrings.searchByCategoryEndPoint}${productList[index].id}"*/
                              //arguments: productList[index].id.toString()
                              Get.toNamed('/test', arguments: [
                                "${AppStrings.searchByCategoryEndPoint}${productList[index].id}",
                                (productList[index].name!.toUpperCase())
                              ]);
                            },
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration:  BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.r),),),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: productList[index]
                                    .image!
                                    .thumbnail
                                    .toString(),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
      },
    );
  }
}
