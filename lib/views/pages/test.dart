import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/search_category_product_controller.dart';
import '../../widgets/circuler_button.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/side_menu_bar.dart';
import '../../widgets/single_card_item.dart';
import 'no_internet_page.dart';

class TestPage extends StatelessWidget {
  TestPage({Key? key}) : super(key: key);

  final SearchCategoryProductController searchCategoryProductController =
      Get.put(SearchCategoryProductController());
  final ScrollController _scrollController = ScrollController();
  final endPoint = Get.arguments[0];
  final categoryName = Get.arguments[1];
  final GlobalKey _globalKey = GlobalKey();
  final InternetConnectionController internetConnectionController=Get.put(InternetConnectionController());
  var currentPosition=0.0.obs;


  @override
  Widget build(BuildContext context) {
    searchCategoryProductController.fetchData(endPoint);
    _scrollController.addListener(() {
      // print("Content Height: ${_globalKey.currentContext?.size?.height}");
      loadMoreData();
    });
    // print("Scroll Position: ${_scrollController.position}");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Center(child: HeaderText(text: categoryName,
            color: Colors.white,
          ),
          ),
          actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_outlined))],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: RefreshIndicator(
          color: AppColors.mainColorPink,
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2),
                    () => searchCategoryProductController.handelRefresh());
          },
          child: Obx(
            () => internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
      
                ?const NoInternetConnectionPage()
                : searchCategoryProductController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : bodyContent(),
          ),
        ),
      ),
    );
  }

  void loadMoreData() {
  currentPosition.value=_scrollController.position.pixels;
    if (_scrollController.position.pixels ==
        /*currentPage * ((proNoperPage / col) * cHeight).round()
                 &&
        !searchCategoryProductController
            .isLoadingMore.value */
        _scrollController.position.maxScrollExtent) {
      if (searchCategoryProductController
              .searchCategoryProductsModel.value.currentPage !=
          searchCategoryProductController
              .searchCategoryProductsModel.value.lastPage && !searchCategoryProductController.isLoadingMore.value) {
        searchCategoryProductController.loadMoreData(
            searchCategoryProductController
                .searchCategoryProductsModel.value.nextPageUrl
                .toString());
      }
    }
  }

  Widget bodyContent() {
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    text:
                        "Items: ${searchCategoryProductController.productList.value.length}"
                            " of ${(searchCategoryProductController.searchCategoryProductsModel.value.total)??"___"}",
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),

                  if(searchCategoryProductController.priceFilter.value.isNotEmpty||
                  searchCategoryProductController.nameFilter.value.isNotEmpty||
                  searchCategoryProductController.sliderMin.value>0||
                  searchCategoryProductController.sliderMax.value<10000)Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                      ),
                      child: InkWell(
                        onTap: (){
                          searchCategoryProductController.priceFilter.value="";
                              searchCategoryProductController.nameFilter.value="";
                              searchCategoryProductController.sliderMin.value=0;
                              searchCategoryProductController.sliderMax.value=10000;
                          searchCategoryProductController.currentRangeValues=const RangeValues(0, 10000);
                              searchCategoryProductController.searchFilter();
                        },
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.h),
                          child: HeaderText(
                            text: "clear filter".toUpperCase(),
                            fontWeight: FontWeight.normal,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Icon(Icons.filter_alt_outlined)
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  key: _globalKey,
                  controller: _scrollController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  //shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(Get.context!).orientation==Orientation.portrait?260:220.0,
                      //mainAxisExtent: 350,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: .5),
                  itemCount: searchCategoryProductController.productList.value.length,
                  //homePageDataController.homePageBackInStock.value.products!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleGridItem(
                      // key: _globalKey,
                      productModel: searchCategoryProductController
                          .productList.value[index],
                      proId: searchCategoryProductController
                          .productList.value[index].productId
                          .toString(),
                      imageUrl: searchCategoryProductController
                              .productList.value[index].image ??
                          "",
                      proName: searchCategoryProductController
                              .productList.value[index].brandName ??
                          "",
                      descriptionText: searchCategoryProductController
                              .productList.value[index].name ??
                          "",
                      regularPrice: searchCategoryProductController
                              .productList.value[index].regularPrice ??
                          0,
                      appPrice: searchCategoryProductController
                              .productList.value[index].appPrice ??
                          0,
                      rating: searchCategoryProductController
                              .productList.value[index].reviewRate ??
                          0,
                      review: searchCategoryProductController
                              .productList.value[index].reviewCount ??
                          0,
                      isBackInStock: searchCategoryProductController
                              .productList.value[index].isBack ??
                          0,
                      isBestSeller: searchCategoryProductController
                              .productList.value[index].isBestseller ??
                          0,
                      isNewArrival: searchCategoryProductController
                              .productList.value[index].isNew ??
                          0,
                      isFavourite: searchCategoryProductController
                              .productList.value[index].isFav ??
                          0,
                      groupId: searchCategoryProductController.productList.value[index].groupId??0,
                      productFrom: searchCategoryProductController.productList.value[index].productFrom??"",
                      discountPrice: searchCategoryProductController.productList.value[index].discountPrice??0,
                      categoryId: '13',
                    );
                  },
                ),
              ),
            ),
            if(searchCategoryProductController.isLoadingMore.value)const CircularProgressIndicator()
          ],
        ),
        SideMenuBar(),
        Visibility(
          visible: currentPosition.value>Get.height*10,
          child: Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: ()=>goToTop(),
              child: CircularButton(
                circleColor: AppColors.mainColorRed,
                bgColor: AppColors.mainColorRed,
                child: Icon(Icons.arrow_drop_up_outlined,size: 36.sp,),),
            ),),
        ),
        if(searchCategoryProductController.isRefreshing.value)Container(child: const Center(child: CircularProgressIndicator(),),)
      ],
    );
  }
  void goToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInToLinear);
  }
}
