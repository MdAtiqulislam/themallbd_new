import 'package:cached_network_image/cached_network_image.dart';
import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../controllers/categories_controller.dart';
import 'my_animated_text.dart';


class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final CategoriesController categoriesController =
      Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    categoriesController.fetchData();
    return SafeArea(
      child: SizedBox(
        height: Get.height,
        width: 300.w,
        child: Drawer(
          backgroundColor: AppColors.mainColorRed.withOpacity(.80),
          child: SingleChildScrollView(
            child: Obx(
              () {
                return categoriesController.isLoading.value
                    ? const Text("Loading...")
                    : newProcess(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget newProcess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40.h,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.highlight_remove_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.offAndToNamed(
                '/multiple_search',
                arguments: ["2"],
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: HeaderText(
                text: "OFFERS",
                align: TextAlign.start,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.offAndToNamed(
                '/multiple_search',
                arguments: ["1"],
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: HeaderText(
                text: "Brands",
                align: TextAlign.start,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.offAndToNamed(
                '/multiple_search',
                arguments: ["0"],
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: HeaderText(
                text: "Categories",
                align: TextAlign.start,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              child: categoryList(),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () {
              Get.offAndToNamed('/test', arguments: [
                "${AppStrings.filterByProductTypeEndPoint}combo_product",
                "Combo offers".toUpperCase()
              ]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: HeaderText(
                text: "COMBO OFFERS",
                align: TextAlign.start,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              String url =
                  "fb://facewebmodal/f?href=https://www.facebook.com/themallbd";
              final Uri _url = Uri.parse(url);
              try {
                if (!await launchUrl(
                  _url,
                )) {
                  throw 'Could not launch $_url';
                }
              } on Exception catch (e) {
                if (kDebugMode) {
                  print(e);
                }
                String url = "https://www.facebook.com/themallbd";
                final Uri _url = Uri.parse(url);
                if (!await launchUrl(_url,
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch $_url';
                }
              }
            },
            child: BodyText(
              text: "Join The Community!",
              align: TextAlign.start,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget categoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoriesController.categoryList!.length,
      itemBuilder: (context, index) {
        return ConfigurableExpansionTile(
          animatedWidgetFollowingHeader: const Icon(
            Icons.expand_more,
            color: Colors.white,
          ),
          header: (bool isExpanded, Animation<double> iconTurns, Animation<double> heightFactor, ConfigurableExpansionTileController controller) { return Flexible(
            child: SizedBox(
              height:65.h,/*categoriesController
                  .categoryList![index].cartRuleTitle !=
                  null? 65.h:45.h,*/
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        /*   Get.toNamed('/search_category_product',
                            arguments:
                                "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].id}"
*/
                        Get.toNamed('/test', arguments: [
                          "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].id}",
                          "${categoriesController.categoryList![index].name?.toUpperCase()}"
                        ]);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*  CachedNetworkImage(
                        imageUrl: categoriesController
                          .categoryList![index].thumbnail
                          .toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset("assets/images/lazy.png"),
                        errorWidget: (context, url, error) => Image.asset("assets/images/lazy.png"),
                      ),*/
                          CircleAvatar(
                            backgroundColor: AppColors.mainColorRed,
                            backgroundImage: CachedNetworkImageProvider(
                              categoriesController
                                  .categoryList![index].thumbnail
                                  .toString(),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(categoriesController.categoryList![index].name.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  if (categoriesController
                                      .categoryList![index].cartRuleTitle !=
                                      null)
                                    MyAnimatedText(sentence: categoriesController
                                        .categoryList![index].cartRuleTitle
                                        .toString(),fontSize: 12,
                                      maxLine: 3,
                                      color_1: AppColors.cart_rule_nav_text_color,
                                      color_2: Colors.white,
                                    )
                                  /*BodyText(
                                      text:categoriesController
                                          .categoryList![index].cartRuleTitle
                                          .toString(),
                                      color: AppColors.cart_rule_nav_text_color,
                                      maxLine: 3,
                                      size: 12,
                                      align: TextAlign.start,
                                    )*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Icon(Icons.add,color: Colors.white,),
                ],
              ),
            ),
          ); },
          childrenBody:
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  categoriesController.categoryList![index].children!.length,
              itemBuilder: (c, i) {
                return
                ConfigurableExpansionTile(
                  animatedWidgetFollowingHeader: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.expand_more,
                      color: Colors.white,
                    ),
                  ),
                  header: (bool isExpanded, Animation<double> iconTurns, Animation<double> heightFactor, ConfigurableExpansionTileController controller) { return Flexible(
                    child: Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 0),
                      height:75.h,/*categoriesController
                        .categoryList![index].children![i].cartRuleTitle !=
                        null?75.h:40.h,*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                /* Get.toNamed('/search_category_product',
                                    arguments:
                                        "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].children![i].id}"*/

                                Get.toNamed('/test', arguments: [
                                  "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].children![i].id}",
                                  "${categoriesController.categoryList![index].children![i].name?.toUpperCase()}"
                                ]);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 60, right: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            categoriesController.categoryList![index]
                                                .children![i].name
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),

                                          if (categoriesController
                                              .categoryList![index].children![i].cartRuleTitle !=
                                              null)
                                            MyAnimatedText(sentence: categoriesController
                                                .categoryList![index].children![i].cartRuleTitle
                                                .toString(),
                                              maxLine: 4,
                                              fontSize: 12,
                                              color_1: AppColors.cart_rule_nav_text_color,
                                              color_2: Colors.white,

                                            )
                                          /*BodyText(
                                              text:categoriesController
                                                  .categoryList![index].children![i].cartRuleTitle
                                                  .toString(),
                                              color: AppColors.cart_rule_nav_text_color,
                                              maxLine: 4,
                                              size: 12,
                                              align: TextAlign.start,
                                            )*/
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Icon(  Icons.add,color: Colors.white,),
                        ],
                      ),
                    ),
                  ); },
                  childrenBody:
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoriesController
                          .categoryList![index].children![i].children!.length,
                      itemBuilder: (con, ix) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            /*Get.toNamed('/search_category_product',
                                arguments:
                                    "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].children![i].children![ix].id}");*/

                            Get.toNamed('/test', arguments: [
                              "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].children![i].children![ix].id}",
                              "${categoriesController.categoryList![index].children![i].children![ix].name?.toUpperCase()}"
                            ]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 80),
                            height:75.h,/* categoriesController
                                .categoryList![index].children![i].children![ix].cartRuleTitle !=
                                null?75.h:45.h,*/
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categoriesController.categoryList![index].children![i].children![ix].name.toString(),
                                    style: const TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis,),
                                    maxLines: 2,

                                  ),
                                  if (categoriesController
                                      .categoryList![index].children![i].children![ix].cartRuleTitle !=
                                      null)
                                    MyAnimatedText(sentence: categoriesController
                                        .categoryList![index].children![i].children![ix].cartRuleTitle
                                        .toString(),
                                    maxLine: 4,
                                      fontSize: 12,
                                      color_1: AppColors.cart_rule_nav_text_color,
                                      color_2: Colors.white,
                                    )
                                    /*BodyText(
                                      text:categoriesController
                                          .categoryList![index].children![i].children![ix].cartRuleTitle
                                          .toString(),
                                      color: AppColors.cart_rule_nav_text_color,
                                      maxLine: 4,
                                      size: 12,
                                      align: TextAlign.start,
                                    )*/
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                )
                ;
              },
            )
          ,
        );
      },
    );
  }
}
