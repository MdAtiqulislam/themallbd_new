import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/app_strings.dart';
import '../../controllers/home_page_data_controller.dart';
import '../../services/local_services.dart';
import '../../utils/show_snack_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/home_brand_slider.dart';
import '../../widgets/home_category_grid.dart';
import '../../widgets/home_category_list.dart';
import '../../widgets/home_page_blog_slider.dart';
import '../../widgets/image_slider.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/shop_by_skin_type.dart';
import '../shimmers/home_page_shimmer.dart';
import 'blog/blog_auto_scroll_slider.dart';

class HomePagePortraitView extends StatelessWidget {
  HomePagePortraitView({super.key});

  final HomePageDataController homePageDataController =
      Get.put(HomePageDataController());
  //final BottomNavigationBarController bottomNavigationBarController=Get.put(BottomNavigationBarController());

/*  final BlogAutoScrollSliderController blogAutoScrollSliderController =
      Get.put(BlogAutoScrollSliderController());*/

  @override
  Widget build(BuildContext context) {
   // bottomNavigationBarController.getCartItems();
    return SafeArea(
      child: Obx(
        () {
          return Scaffold(
            extendBodyBehindAppBar: true,
            drawer: CustomDrawer(),
            bottomNavigationBar:  CustomBottomNavigationBar(),
            floatingActionButton: privilegesButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartFloat,
            body: homePageDataController.isLoading.value
                ? const HomePageShimmer()
                : Column(
                    children: [
                      //if (!homePageDataController.topTextExpand.value)
                       // topHeaderText(),
                      const CustomAppBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: homePageDataController.scrollController,
                          child: Column(children: [
                            ImageSlider(
                              images: homePageDataController.sliderImages,
                              height: 250.h,
                            ),
                            ShopBySkinType(
                                isLoading: false,
                                productList: homePageDataController
                                    .homePageSkinTypeList),
                            HomeCategoryGrid(
                                isLoading: false,
                                productList: homePageDataController
                                    .homePageCategoryList),
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

                            if (homePageDataController.brands.list !=
                                null)
                              HomeBrandSlider(
                                isLoading: false,
                                itemList:
                                    homePageDataController.brands.list!,
                                brandBanner: homePageDataController
                                    .brands.banners!,
                              ),

                            //New Arrival
                            if (homePageDataController
                                    .newArrival.value.products !=
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
                            if (homePageDataController
                                    .bestSeller.value.products !=
                                null)
                              ProductGrid(
                                showMoreTag: "best_seller",
                                blockTitle: "BEST SELLERS",
                                products: homePageDataController
                                    .bestSeller.value.products,
                                imageUrl: homePageDataController
                                    .bestSeller.value.banner
                                    .toString(),
                              ),

                            //Baby Care
                            if (homePageDataController
                                    .babyCare.value.products !=
                                null)
                              ProductGrid(
                                showMoreTag: "baby_care",
                                blockTitle: "BABY CARE",
                                products: homePageDataController
                                    .babyCare.value.products,
                                imageUrl: homePageDataController
                                    .babyCare.value.banner
                                    .toString(),
                              ),
                            //Life Style
                            if (homePageDataController
                                    .lifeStyle.value.products !=
                                null)
                              ProductGrid(
                                showMoreTag: "life_style",
                                blockTitle: "LIFE STYLE",
                                products: homePageDataController
                                    .lifeStyle.value.products,
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
                                  categoryList: homePageDataController
                                      .homePageCategoryList),

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
                                .homePageBlogList.isNotEmpty)
                              HomePageBlogSlider(
                                  itemList:
                                      homePageDataController.homePageBlogList),

                            SizedBox(
                              height: 30.h,
                            ),
                            if (homePageDataController
                                .autoScrollSliderData.isNotEmpty)
                              BlogAutoScrollSlider(
                                  itemList: homePageDataController
                                      .autoScrollSliderData),

                            SizedBox(
                              height: 30.h,
                            ),
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
          );
        },
      ),
    );
  }

  Widget privilegesButton() {
    return Visibility(
      visible: homePageDataController.showPrivilegeButton.value,
      child: Card(
        elevation: 5,
        color: AppColors.mainColorPink,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                var token = await LocalServices.getToken() ?? "";
                if (token.isEmpty) {
                  ShowSnackBar(
                    isWarning: true,
                    msg: "Please Login First to continue.",
                    title: "Login Required",
                    showButton: true,
                    buttonText: "GO TO LOGIN?"
                  ).showSnackBar();
                }else{
                  Get.toNamed("/vip_privileges_page");
                }
              },
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
            AppStrings.getNoticeMsg.value,
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
