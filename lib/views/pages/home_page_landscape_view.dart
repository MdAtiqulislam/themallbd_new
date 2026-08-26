import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/custom_menu_clipper.dart';
import '../../views/shimmers/home_page_shimmer.dart';
import '../../constraints/app_colors.dart';
import '../../controllers/home_page_data_controller.dart';
import '../../controllers/slider_images_controller.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/home_brand_slider.dart';
import '../../widgets/home_category_grid.dart';
import '../../widgets/home_category_list.dart';
import '../../widgets/home_page_blog_slider.dart';
import '../../widgets/image_slider.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/shop_by_skin_type.dart';

class HomePageLandscapeView extends StatelessWidget {
  HomePageLandscapeView({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final SliderImagesController sliderImagesController = Get.put(
    SliderImagesController(),
  );

  final HomePageDataController homePageDataController =
      Get.put(HomePageDataController());
  int loadingValue = 0;
  var showPrivilegeButton = true.obs;
  var topTextExpand = true.obs;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          loadingValue < 4) {
        loadMoreData();
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        topTextExpand.value = false;
      }
      if (_scrollController.position.pixels == 0) {
        topTextExpand.value = true;
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      bottomNavigationBar:  CustomBottomNavigationBar(),
      floatingActionButton: privilegesButton(),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniStartFloat,
      body: Obx(() {
        return homePageDataController.isLoading.value
            ? const HomePageShimmer()
            : SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        if(topTextExpand.value)topHeaderText(),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(children: [
                              ImageSlider(
                                images: homePageDataController.sliderImages,
                                height: 250.h,
                              ),
                              ShopBySkinType(
                                  isLoading: false,
                                  productList:
                                      homePageDataController.homePageSkinTypeList),
                              HomeCategoryGrid(
                                  isLoading: false,
                                  productList:
                                      homePageDataController.homePageCategoryList),
                              //back in stock
                              if (homePageDataController
                                      .homePageBackInStock.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "back_in_stock",
                                  blockTitle: "BACK IN STOCK",
                                  products: homePageDataController
                                      .homePageBackInStock.value.products,
                                  imageUrl: homePageDataController
                                      .homePageBackInStock.value.banner
                                      .toString(),
                                ),

                              if (homePageDataController.brands.list != null)
                                HomeBrandSlider(
                                  isLoading: false,
                                  itemList: homePageDataController.brands.list!,
                                  brandBanner:
                                      homePageDataController.brands.banners!,
                                ),

                              //New Arrival
                              if (homePageDataController.newArrival.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "new_arrival",
                                  blockTitle: "NEW ARRIVALS",
                                  products: homePageDataController
                                      .newArrival.value.products,
                                  imageUrl: homePageDataController
                                      .newArrival.value.banner
                                      .toString(),
                                ),
                              //Best Seller
                              if (homePageDataController.bestSeller.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "best_sellers",
                                  blockTitle: "BEST SELLERS",
                                  products: homePageDataController
                                      .bestSeller.value.products,
                                  imageUrl: homePageDataController
                                      .bestSeller.value.banner
                                      .toString(),
                                ),

                              //Baby Care
                              if (homePageDataController.babyCare.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "baby_care",
                                  blockTitle: "BABY CARE",
                                  products:
                                      homePageDataController.babyCare.value.products,
                                  imageUrl: homePageDataController
                                      .babyCare.value.banner
                                      .toString(),
                                ),
                              //Life Style
                              if (homePageDataController.lifeStyle.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "life_style",
                                  blockTitle: "LIFE STYLE",
                                  products:
                                      homePageDataController.lifeStyle.value.products,
                                  imageUrl: homePageDataController
                                      .lifeStyle.value.banner
                                      .toString(),
                                ),

                              //Exclusive Sale
                              if (homePageDataController
                                      .exclusiveSale.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "exclusive_sale",
                                  blockTitle: "EXCLUSIVE SALE",
                                  products: homePageDataController
                                      .exclusiveSale.value.products,
                                  imageUrl: homePageDataController
                                      .exclusiveSale.value.banner
                                      .toString(),
                                ),

                              //Shop By Category
                              if (homePageDataController
                                      .exclusiveSale.value.products !=
                                  null)
                                HomeCategoryList(
                                    blockTitle: "SHOP BY CATEGORY",
                                    isLoading: false,
                                    categoryList:
                                        homePageDataController.homePageCategoryList),

                              //Featured Products
                              if (homePageDataController
                                      .featuredProduct.value.products !=
                                  null)
                                ProductGrid(
                                  showMoreTag: "featured_products",
                                  blockTitle: "FEATURED PRODUCTS",
                                  products: homePageDataController
                                      .featuredProduct.value.products,
                                  imageUrl: homePageDataController
                                      .featuredProduct.value.banner
                                      .toString(),
                                ),
                              //Blog Slider
                              if (homePageDataController
                                  .homePageBlogList.value.isNotEmpty)
                                HomePageBlogSlider(itemList:homePageDataController.homePageBlogList.value),

                              if (homePageDataController.isLoadingMore.value)
                                const CircularProgressIndicator(),
                              SizedBox(
                                height: 20.h,
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                    
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ClipPath(
                        clipper: CustomMenuClipper(position: "left"),
                        child: Container(
                          width: 35,
                          height: 110,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ], color: AppColors.mainColorRed),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: AppColors.mainColorRed,
                            onPressed: () {
                              Get.toNamed('/search_page');
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ClipPath(
                        clipper: CustomMenuClipper(position: "right"),
                        child: Container(
                          width: 35,
                          height: 110,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ], color: AppColors.mainColorRed),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: AppColors.mainColorRed,
                            onPressed: () {
                              _scaffoldKey.currentState!.isDrawerOpen
                                  ? _scaffoldKey.currentState?.closeDrawer()
                                  : _scaffoldKey.currentState?.openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
      }),
    );
  }

  void loadMoreData() {
      loadingValue++;
      homePageDataController.isLoadingMore.value = true;
      homePageDataController.searchKey.value = loadingValue.toString();
      homePageDataController.fetchData();
  }

  Widget privilegesButton() {
    return Visibility(
      visible: showPrivilegeButton.value,
      child: Card(
        elevation: 5,
        color: AppColors.mainColorPink,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {},
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
                showPrivilegeButton.value = false;
              },
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 16.sp,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topHeaderText() {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Center(
          child: Text(
            "Flat 21Tk Delivery Charge Inside Dhaka & Flat 70Tk Delivery Charge Outside Dhaka!",
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/*class HomePageLandscapeView extends StatelessWidget {
  HomePageLandscapeView({Key? key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final SliderImagesController sliderImagesController = Get.put(
    SliderImagesController(),
  );

  final HomePageDataController homePageDataController =
      Get.put(HomePageDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Obx(() {
        return sliderImagesController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ImageSlider(
                            images: sliderImagesController.images,
                            height: 180.w,
                          ),
                          SearchBySkinType(
                              isLoading: false,
                              productList:
                                  homePageDataController.homePageSkinTypeList),
                          HomeCategoryGrid(
                              isLoading: false,
                              productList:
                                  homePageDataController.homePageCategoryList),
                          ProductGrid(
                            blockTitle: "BACK IN STOCK",
                            products: homePageDataController
                                .homePageDataModel.value.backInStock!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.backInStock!.banner
                                .toString(),
                          ),
                          HomeBrandSlider(
                            isLoading: false,
                            itemList: homePageDataController
                                .homePageDataModel.value.brand!.list!,
                            brandBanner: homePageDataController
                                .homePageDataModel.value.brand!.banners!,
                          ),
                          ProductGrid(
                            blockTitle: "NEW ARRIVALS",
                            products: homePageDataController
                                .homePageDataModel.value.newArrival!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.newArrival!.banner
                                .toString(),
                          ),
                          ProductGrid(
                            blockTitle: "BEST SELLERS",
                            products: homePageDataController
                                .homePageDataModel.value.bestSeller!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.bestSeller!.banner
                                .toString(),
                          ),
                          ProductGrid(
                            blockTitle: "BABY CARE",
                            products: homePageDataController
                                .homePageDataModel.value.babyCare!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.babyCare!.banner
                                .toString(),
                          ),
                          ProductGrid(
                            blockTitle: "LIFE STYLE",
                            products: homePageDataController
                                .homePageDataModel.value.lifestyle!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.lifestyle!.banner
                                .toString(),
                          ),
                          ProductGrid(
                            blockTitle: "EXCLUSIVE SALE",
                            products: homePageDataController.homePageDataModel
                                .value.exclusiveSale!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.exclusiveSale!.banner
                                .toString(),
                          ),
                          HomeCategoryList(
                              blockTitle: "SHOP BY CATEGORY",
                              isLoading: false,
                              categoryList:
                                  homePageDataController.homePageCategoryList),
                          ProductGrid(
                            blockTitle: "FEATURED PRODUCTS",
                            products: homePageDataController
                                .homePageDataModel.value.featured!.products,
                            imageUrl: homePageDataController
                                .homePageDataModel.value.featured!.banner
                                .toString(),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5.h,
                      right: 0,
                      child: ClipPath(
                        clipper: CustomMenuClipper(position: "left"),
                        child: Container(
                          width: 35,
                          height: 110,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ], color: AppColors.mainColorRed),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: AppColors.mainColorRed,
                            onPressed: () {
                              Get.toNamed('/search_page');
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5.h,
                      left: 0,
                      child: ClipPath(
                        clipper: CustomMenuClipper(position: "right"),
                        child: Container(
                          width: 35,
                          height: 110,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ], color: AppColors.mainColorRed),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            // backgroundColor: AppColors.mainColorRed,
                            onPressed: () {
                              _scaffoldKey.currentState!.isDrawerOpen
                                  ? _scaffoldKey.currentState?.closeDrawer()
                                  : _scaffoldKey.currentState?.openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        //color: AppColors.mainColorRed,
                        decoration: BoxDecoration(
                          color: AppColors.mainColorRed,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          color: AppColors.mainColorRed,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              //spreadRadius: 5,
                              blurRadius: 7.r,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
      }),
    );
  }
}*/
