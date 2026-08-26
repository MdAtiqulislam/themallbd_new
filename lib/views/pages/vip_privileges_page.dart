import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/vip_privileges_controller.dart';
import '../../models/vip_privilege_trending_offer_model.dart';
import 'no_internet_page.dart';

class VIPPrivilegesPage extends StatelessWidget {
  VIPPrivilegesPage({super.key});
  final VIPPrivilegesController vipPrivilegesController =
      Get.put(VIPPrivilegesController());
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _globalKey=GlobalKey();
  final GlobalKey _globalKey2=GlobalKey();

  final InternetConnectionController internetConnectionController=Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: "PRIVILEGES",
            color: Colors.white,
          ),

        ),
        body: Obx(() =>  internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
            ?const NoInternetConnectionPage()
            : vipPrivilegesController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      primary: false,
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            //Header Image

            //Should be Dynamic
            Image.network("https://www.themallbd.com/website/static/vip/header1.jpg",
              key: _globalKey2,
              fit: BoxFit.fill,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                }
                return image;
              },

              loadingBuilder:
                  (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover
                  );
                }
              },
            ),
             /*FadeInImage(
              key: _globalKey2,
              placeholder: AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(
                  "https://www.themallbd.com/website/static/vip/header1.jpg"),
            ),*/

            const SizedBox(
              height: 30,
            ),
            HeaderText(
              text: "CATEGORIES",
              size: 20,
              fontWeight: FontWeight.normal,
            ),
            categoryGrid(),
            SizedBox(
              height: 20.h,
            ),
            vipPrivilegesController.selectedCategory.value == -1
                ? vipPrivilegesController.allPrivilegesList.isNotEmpty?trendingOffersGrid(
                    vipPrivilegesController.allPrivilegesList.value):const Text("")
                : (vipPrivilegesController.categoryShopList.isNotEmpty)?categoryShopGrid():const Text(""),

            SizedBox(
              height: 20.h,
            ),
            /*FadeInImage(
              //key: _globalKey2,
              placeholder: AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(
                  "https://themallbd.com/website/assets/images/vip/banner.jpg"),
            ),*/
            Image.network("https://themallbd.com/website/assets/images/vip/banner.jpg",
              fit: BoxFit.fill,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                }
                return image;
              },

              loadingBuilder:
                  (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover
                  );
                }
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            HeaderText(
              text: "TRENDING OFFERS",
              size: 20,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(
              height: 10.h,
            ),
            trendingOffersGrid(
                vipPrivilegesController.trendingOffersList.value),
            SizedBox(
              height: 20.h,
            ),
            /*FadeInImage(
              //key: _globalKey2,
              placeholder: AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(
                  "https://themallbd.com/website/static/vip/banner_1.jpg"),
            ),*/
            Image.network("https://themallbd.com/website/static/vip/banner_1.jpg",
              fit: BoxFit.fill,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                }
                return image;
              },

              loadingBuilder:
                  (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover
                  );
                }
              },
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryGrid() {
    return GridView.builder(
      key: _globalKey,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: .85),
        itemCount: vipPrivilegesController.categoryList.value.length + 1,
        //homePageDataController.homePageBackInStock.value.products!.length,
        itemBuilder: (BuildContext context, int index) {


         return index == 0
              ? categoryGridItemToShowAll()
              : categoryGridItem(index - 1);
        });
  }

  Widget categoryGridItemToShowAll() {
    return InkWell(
      onTap: () {
        vipPrivilegesController.selectedCategory.value = -1;
        vipPrivilegesController.getAllPrivileges();


        _scrollController.animateTo(_globalKey.currentContext!.size!.height+_globalKey2.currentContext!.size!.height+80.h,
            duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      },
      child: Obx(
        () => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          color: vipPrivilegesController.selectedCategory.value == -1
              ? AppColors.vipCategorySelectedColor
              : Colors.grey.withOpacity(.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: /*FadeInImage(
                  placeholder: AssetImage("assets/images/no-image_card.jpg"),
                  image: NetworkImage(
                    vipPrivilegesController.categoryList.value[0].image
                        .toString(),
                  ),
                ),*/
                Image.network(vipPrivilegesController.categoryList.value[0].image??"",
                  fit: BoxFit.fill,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                    }
                    return image;
                  },

                  loadingBuilder:
                      (context, image, loading) {
                    if (loading == null) {
                      return image;
                    } else {
                      return Image.asset(
                          "assets/images/no-img.jpg",
                          fit: BoxFit.cover
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: HeaderText(
                  text: "All",
                  fontWeight: FontWeight.normal,
                  size: 12,
                  maxLine: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryGridItem(int index) {
    return InkWell(
      onTap: () {
        vipPrivilegesController.selectedCategory.value =
            vipPrivilegesController.categoryList.value[index].id!;
        vipPrivilegesController.getCategoryShop();

        _scrollController.animateTo(_globalKey.currentContext!.size!.height+_globalKey2.currentContext!.size!.height+80.h,
            duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      },
      child: Obx(
        () => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          color: vipPrivilegesController.selectedCategory.value ==
                  vipPrivilegesController.categoryList.value[index].id
              ? AppColors.vipCategorySelectedColor
              : Colors.grey.withOpacity(.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: /*FadeInImage(
                  placeholder: AssetImage("assets/images/no-image_card.jpg"),
                  image: NetworkImage(
                    vipPrivilegesController.categoryList.value[index].image
                        .toString(),
                  ),
                ),*/
                Image.network(vipPrivilegesController.categoryList.value[index].image??"",
                  fit: BoxFit.fill,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                    }
                    return image;
                  },

                  loadingBuilder:
                      (context, image, loading) {
                    if (loading == null) {
                      return image;
                    } else {
                      return Image.asset(
                          "assets/images/no-img.jpg",
                          fit: BoxFit.cover
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: HeaderText(
                  text: vipPrivilegesController.categoryList.value[index].name
                      .toString(),
                  fontWeight: FontWeight.normal,
                  size: 12,
                  maxLine: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryShopGrid() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: .55),
        itemCount: vipPrivilegesController.categoryShopList.value.length,
        //homePageDataController.homePageBackInStock.value.products!.length,
        itemBuilder: (BuildContext context, int index) {
          return categoryShopGridItem(index);
        });
  }

  Widget categoryShopGridItem(int index) {
    return InkWell(
        onTap: () {
          /* vipPrivilegesController.selectedCategory.value =
          vipPrivilegesController.categoryList.value[index].id!;*/

          Get.toNamed("/privilege_details",arguments: [vipPrivilegesController
              .categoryShopList.value[index].id,vipPrivilegesController
              .categoryShopList.value[index].categoryName]);
        },
        child: Obx(
          () => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(5.r),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: /*FadeInImage(
                      placeholder:
                          const AssetImage("assets/images/no-image_card.jpg"),
                      image: NetworkImage(
                        vipPrivilegesController
                            .categoryShopList.value[index].logo
                            .toString(),
                      ),
                    ),*/
                    Image.network(vipPrivilegesController.categoryShopList.value[index].logo??"",
                      fit: BoxFit.fill,
                      frameBuilder: (_, image, loadingBuilder, __) {
                        if (loadingBuilder == null) {
                          return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                        }
                        return image;
                      },

                      loadingBuilder:
                          (context, image, loading) {
                        if (loading == null) {
                          return image;
                        } else {
                          return Image.asset(
                              "assets/images/no-img.jpg",
                              fit: BoxFit.cover
                          );
                        }
                      },
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    //color: Colors.green,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: HeaderText(
                            text: vipPrivilegesController
                                .categoryShopList.value[index].name
                                .toString()
                                .toUpperCase(),
                            fontWeight: FontWeight.normal,
                            size: 14,
                            maxLine: 4,
                          ),
                        ),
                        BodyText(
                          text: vipPrivilegesController
                              .categoryShopList.value[index].categoryName
                              .toString()
                              .toUpperCase(),
                          color: Colors.green,
                          size: 10,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        BodyText(
                          text: vipPrivilegesController
                              .categoryShopList.value[index].discountText
                              .toString()
                              .toUpperCase(),
                          color: Colors.red,
                          size: 12,
                          maxLine: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget trendingOffersGrid(List<TrendingOffersModel> value) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: .55),
        itemCount: value.length,
        //itemCount: vipPrivilegesController.trendingOffersList.value.length,
        //homePageDataController.homePageBackInStock.value.products!.length,
        itemBuilder: (BuildContext context, int index) {
          return trendingOffersGridItem(value[index]);
        });
  }

  Widget trendingOffersGridItem(TrendingOffersModel item) {
    return InkWell(
        onTap: () {
          Get.toNamed("/privilege_details",arguments: [item.id,
           item.category!.name]);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(5.r),
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: /*FadeInImage(
                    placeholder:
                        const AssetImage("assets/images/no-image_card.jpg"),
                    image: NetworkImage(
                      item.imageUrl.toString(),
                    ),
                  ),*/
                  Image.network(item.imageUrl??"",
                    fit: BoxFit.fill,
                    frameBuilder: (_, image, loadingBuilder, __) {
                      if (loadingBuilder == null) {
                        return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                      }
                      return image;
                    },

                    loadingBuilder:
                        (context, image, loading) {
                      if (loading == null) {
                        return image;
                      } else {
                        return Image.asset(
                            "assets/images/no-img.jpg",
                            fit: BoxFit.cover
                        );
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  //color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: HeaderText(
                          text: item.name.toString().toUpperCase(),
                          fontWeight: FontWeight.normal,
                          size: 14,
                          maxLine: 4,
                        ),
                      ),
                      BodyText(
                        text: item.category!.name.toString().toUpperCase(),
                        color: Colors.green,
                        size: 10,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      BodyText(
                        text: item.discountText.toString().toUpperCase(),
                        color: Colors.red,
                        size: 12,
                        maxLine: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
