import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/app_strings.dart';
import '../../controllers/home_page_data_controller.dart';
import '../../controllers/internet_controller.dart';
import '../../models/slider_images_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/home_brand_slider.dart';
import '../../widgets/home_category_grid.dart';
import '../../widgets/home_category_list.dart';
import '../../widgets/home_page_blog_slider.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/shop_by_skin_type.dart';
import '../shimmers/home_page_shimmer.dart';
import 'blog/blog_auto_scroll_slider.dart';
import 'no_internet_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomePageDataController homePageDataController =
      Get.put(HomePageDataController());
  final InternetConnectionController internetController =
      Get.put(InternetConnectionController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      // print("Content Height: ${_globalKey.currentContext?.size?.height}");
      loadMoreData();
    });
    if (internetController.shouldReload.value &&
        !homePageDataController.isLoading.value) {
      homePageDataController.searchKey.value = "0";
      homePageDataController.fetchData();
    }
    return portrait();
    /*ResponsiveHelper(
      landscape: HomePageLandscapeView(),
      portrait: portrait()
     // HomePagePortraitView(),
    );*/
  }

  Widget portrait() {
    // homePageDataController.sliderImages=[];
    return Obx(
      () => SafeArea(
        child: internetController.connectionStatus.value.contains(ConnectivityResult.none)
            ? const NoInternetConnectionPage()
            : Stack(
                children: [
                  Scaffold(
                    extendBodyBehindAppBar: true,
                    drawer: CustomDrawer(),
                    bottomNavigationBar: CustomBottomNavigationBar(),
                    floatingActionButton: privilegesButton(),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.miniStartFloat,
                    body: homePageDataController.isLoading.value
                        ? const HomePageShimmer()
                        : RefreshIndicator(
                            color: AppColors.mainColorRed,
                            backgroundColor:Colors.white,
                            onRefresh: () {
                              //homePageDataController.isRefreshing.value=true;
                              return Future.delayed(const Duration(seconds: 2),
                                  () => homePageDataController.handelRefresh());
                            },
                            child: bodyContentPortrait(),
                          ),
                    //body: homePageDataController.isLoading.value
                  ),
                ],
              ),
      ),
    );
  }

  Widget bodyContentPortrait() {
    return Column(
      children: [
        if (homePageDataController.topTextExpand.value &&
            AppStrings.getNoticeMsg.value.isNotEmpty)
          topHeaderText(),
        const CustomAppBar(),
        Flexible(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: imageSlider(
                    // images: homePageDataController.sliderImages,
                    images: homePageDataController.sliderImageList
                    //height:MediaQuery.of(Get.context !).orientation == Orientation.portrait? 280.h:250.w,
                    ),
              ),
              SliverToBoxAdapter(
                child: ShopBySkinType(
                    isLoading: false,
                    productList: homePageDataController.homePageSkinTypeList),
              ),
              SliverToBoxAdapter(
                child: HomeCategoryGrid(
                    isLoading: false,
                    productList: homePageDataController.homePageCategoryList),
              ),
              if (homePageDataController.homePageBackInStock.value.products !=
                  null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "back_in_stock",
                    blockTitle: "BACK IN STOCK",
                    products: homePageDataController
                        .homePageBackInStock.value.products,
                    imageUrl: homePageDataController
                        .homePageBackInStock.value.banner
                        .toString(),
                  ),
                ),
              if (homePageDataController.brands.list != null)
                SliverToBoxAdapter(
                  child: HomeBrandSlider(
                    isLoading: false,
                    itemList: homePageDataController.brands.list ?? [],
                    brandBanner: homePageDataController.brands.banners ?? [],
                  ),
                ),

              //New Arrival
              if (homePageDataController.newArrival.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "new_arrival",
                    blockTitle: "NEW ARRIVALS",
                    products: homePageDataController.newArrival.value.products,
                    imageUrl: homePageDataController.newArrival.value.banner
                        .toString(),
                  ),
                ),
              //Best Seller
              if (homePageDataController.bestSeller.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "best_seller",
                    blockTitle: "BEST SELLERS",
                    products: homePageDataController.bestSeller.value.products,
                    imageUrl: homePageDataController.bestSeller.value.banner
                        .toString(),
                  ),
                ),

              //Baby Care
              if (homePageDataController.babyCare.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "baby_care",
                    blockTitle: "BABY CARE",
                    products: homePageDataController.babyCare.value.products,
                    imageUrl:
                        homePageDataController.babyCare.value.banner.toString(),
                  ),
                ),
              //Life Style
              if (homePageDataController.lifeStyle.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "life_style",
                    blockTitle: "LIFE STYLE",
                    products: homePageDataController.lifeStyle.value.products,
                    imageUrl: homePageDataController.lifeStyle.value.banner
                        .toString(),
                  ),
                ),

              //Exclusive Sale
              if (homePageDataController.exclusiveSale.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "exclusive_sale",
                    blockTitle: "EXCLUSIVE SALE",
                    products:
                        homePageDataController.exclusiveSale.value.products,
                    imageUrl: homePageDataController.exclusiveSale.value.banner
                        .toString(),
                  ),
                ),

              //Shop By Category
              if (homePageDataController.exclusiveSale.value.products != null)
                SliverToBoxAdapter(
                  child: HomeCategoryList(
                      blockTitle: "SHOP BY CATEGORY",
                      isLoading: false,
                      categoryList:
                          homePageDataController.homePageCategoryList),
                ),

              //Featured Products
              if (homePageDataController.featuredProduct.value.products != null)
                SliverToBoxAdapter(
                  child: ProductGrid(
                    showMoreTag: "featured_products",
                    blockTitle: "FEATURED PRODUCTS",
                    products:
                        homePageDataController.featuredProduct.value.products,
                    imageUrl: homePageDataController
                        .featuredProduct.value.banner
                        .toString(),
                  ),
                ),

              //Blog Slider
              if (homePageDataController.homePageBlogList.isNotEmpty)
                SliverToBoxAdapter(
                  child: HomePageBlogSlider(
                      itemList: homePageDataController.homePageBlogList),
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 30.h,
                ),
              ),
              if (homePageDataController.autoScrollSliderData.isNotEmpty)
                SliverToBoxAdapter(
                  child: BlogAutoScrollSlider(
                      itemList: homePageDataController.autoScrollSliderData),
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 30.h,
                ),
              ),
              if (homePageDataController.isLoadingMore.value)
                const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator())),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20.h,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget topHeaderText() {
    return Container(
      //color: AppColors.mainColorRed,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Center(
          child: Text(
            AppStrings.getNoticeMsg.value,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 12.spMin,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget privilegesButton() {
    return Visibility(
      visible: homePageDataController.showPrivilegeButton.value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColors.mainColorPink,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 5)
            )
          ]
        ),
       // elevation: 5,

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Get.toNamed("/vip_privileges_page"),
              child: SizedBox(
                height: 30.h,
                //width: 60,
                child: AppButton(
                  text: 'VIP PRIVILEGES',
                  bgColor: Colors.transparent,
                  textColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 5.w),
            InkWell(
              onTap: () {
                homePageDataController.showPrivilegeButton.value = false;
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 16.spMin,
              ),
            )
          ],
        ),
      ),
    );
  }

  //imageSlider({required List images,  double? height})
  imageSlider({required List<SliderImagesModel> images, double? height}) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
                items: images.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                          width: Get.width,
                          child: InkWell(
                            onTap: () {
                              if ((i.moduleType ?? "").isNotEmpty) {
                                homePageDataController.controlSliderClick(i);
                              }
                            },
                            child: Image.network(
                              i.image ?? "",
                              fit: BoxFit.contain,
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
                          ));
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  onPageChanged: (i, r) {
                    homePageDataController.dotPosition.value = i;
                  },
                  //height: 280,
                  aspectRatio: 1.5,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  //enlargeCenterPage: true,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                )),
            Positioned(
              bottom: 0,
              width: Get.width,
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: DotsIndicator(
                      mainAxisAlignment: MainAxisAlignment.center,
                      dotsCount: images.isEmpty ? 1 : images.length,
                      position: homePageDataController.dotPosition.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: AppColors.mainColorRed,
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  void loadMoreData() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        homePageDataController.loadingValue.value < 4 &&
        !homePageDataController.isLoadingMore.value) {
      homePageDataController.loadMoreData();
    }
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        homePageDataController.loadingValue.value == 4 &&
        homePageDataController.autoScrollSliderData.isEmpty &&
        !homePageDataController.isLoadingMore.value) {
      homePageDataController.fetchAutoScrollSliderData();
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      homePageDataController.topTextExpand.value = false;
    }
    if (_scrollController.position.pixels == 0) {
      homePageDataController.topTextExpand.value = true;
      homePageDataController.searchKey.value = "0";
      homePageDataController.fetchData();
    }

    /*
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        topTextExpand.value=true;
      }*/
  }
}
