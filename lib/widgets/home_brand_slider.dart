import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../constraints/header_text.dart';
import '../models/home_page_models/home_page_brand_model.dart';

class HomeBrandSlider extends StatelessWidget {
  final bool isLoading;
  final List<ListElement> itemList;
  final List<Banners> brandBanner;

  const HomeBrandSlider(
      {super.key,
      this.isLoading = true,
      required this.itemList,
      required this.brandBanner});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: HeaderText(
            text: "SHOP BY BRAND",
            align: TextAlign.center,
            size: MediaQuery.of(context).orientation == Orientation.portrait
                ? 16.h
                : 16.w,
          ),
        ),
        Container(
          height: 120.w,
          color: Colors.black,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    /* Get.toNamed(
                        '/search_category_product',
                        arguments: "${AppStrings.searchBrandEndPoint}${itemList[index].id}");*/

                    Get.toNamed('/test', arguments: [
                      "${AppStrings.searchBrandEndPoint}${itemList[index].id}",
                      itemList[index].name!.toUpperCase()
                    ]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 5, right: 5),
                    child: Image.network(
                      itemList[index].image?.thumbnail ?? "",
                      frameBuilder: (_, image, loadingBuilder, __) {
                        if (loadingBuilder == null) {
                          return SizedBox(
                            height: 300,
                            child: Image.asset("assets/images/no-img.jpg"),
                          );
                        }
                        return image;
                      },

                      loadingBuilder:
                          (context, image, loading) {
                        if (loading == null) {
                          return image;
                        } else {
                          return Image.asset(
                              "assets/images/no-img.jpg");
                        }
                      },
                    ),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          //padding: EdgeInsets.only(top: 10,bottom: 10),
          height: 300.h,
          color: Colors.black,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: brandBanner.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.toNamed('/test', arguments: [
                      "${AppStrings.searchBrandEndPoint}${itemList[index].id}",
                      itemList[index].name!.toUpperCase()
                    ]);
                  },
                  child: SizedBox(
                    width: Get.width,
                    child: Image.network(
                      brandBanner[index].image?.cover ?? "",
                      fit: BoxFit.contain,
                      frameBuilder: (_, image, loadingBuilder, __) {
                        if (loadingBuilder == null) {
                          return SizedBox(
                            height: 300,
                            child: Image.asset("assets/images/no-img.jpg"),
                          );
                        }
                        return image;
                      },

                      loadingBuilder:
                          (context, image, loading) {
                        if (loading == null) {
                          return image;
                        } else {
                          return Image.asset(
                              "assets/images/no-img.jpg");
                        }
                      },
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
