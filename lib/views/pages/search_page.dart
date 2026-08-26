import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/search_product_controller.dart';
import '../../utils/show_snack_bar.dart';
import '../../widgets/circuler_button.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/side_menu_bar.dart';
import '../../widgets/single_card_item.dart';
import 'no_internet_page.dart';

class SearchPage extends StatelessWidget {
  final SearchProductController searchProductController =
  Get.put(SearchProductController());
  final ScrollController _scrollController = ScrollController();

  SearchPage({super.key});

  final searchKeyController = TextEditingController();
  final InternetConnectionController internetConnectionController =
  Get.put(InternetConnectionController());
  var currentPosition=0.0.obs;

  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchKeyController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      loadMoreData();
    });
    return Obx(() => internetConnectionController.connectionStatus.value.contains(
        ConnectivityResult.none)
        ? const NoInternetConnectionPage()
        : portraitView()

      /*ResponsiveHelper(
              portrait: portraitView(),
              landscape: landscapeView(),
            ),*/
    );
  }

  Widget portraitView() {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: searchButton(),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
          body: bodyContent()),
    );
  }

  Widget headerSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderText(
            text: "Items: ${searchProductController.productList.value.length}"
                " of ${searchProductController.searchProductsModel.value.total ?? 0}",
            align: TextAlign.start,
            fontWeight: FontWeight.normal,
          ),
          if (searchProductController.priceFilter.value.isNotEmpty ||
              searchProductController.nameFilter.value.isNotEmpty ||
              searchProductController.sliderMin.value > 0 ||
              searchProductController.sliderMax.value < 10000)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.r),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    searchProductController.priceFilter.value = "";
                    searchProductController.nameFilter.value = "";
                    searchProductController.sliderMin.value = 0;
                    searchProductController.sliderMax.value = 10000;
                    searchProductController.currentRangeValues =
                    const RangeValues(0, 10000);
                    searchProductController.searchFilter();
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
    );
  }

  Widget searchButton() {
    return Container(
      margin: EdgeInsets.only(right: 10.w, top: 5.h, bottom: 5.h),
      height: 45.h,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: AppColors.mainColorRed),
        borderRadius: BorderRadius.all(
          Radius.circular(15.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: TextFormField(
          controller: searchKeyController,
          onChanged: (value) {
            if (value.length >= 3) {
              searchProductController.searchKey.value = value;
              //searchProductController.isLoading.value = true;
              searchProductController.fetchData();
            }
          },
          style: TextStyle(fontSize: 16.spMin),
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  if (searchKeyController.text.length >= 3) {
                    searchByKey();
                  }else{
                    Get.closeAllSnackbars();
                    ShowSnackBar(msg: "Search key must not less then 3 characters!",isSuccess: false).showSnackBar();
                  }
                },
                icon: const Icon(Icons.search),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Search For Products'),
          onFieldSubmitted: (value) {
            if (value.length >= 3) {
              searchProductController.searchKey.value = value.toString();
              searchProductController.fetchData();
              searchProductController.isLoading.value = true;
            }else{
              Get.closeAllSnackbars();
              ShowSnackBar(msg: "Search key must not less then 3 characters!",isSuccess: false).showSnackBar();
            }
          },
        ),
      ),
    );
  }

  Widget bodyContent() {
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            headerSection(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  //  key: _globalKey,
                  controller: _scrollController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  //shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(Get.context!).orientation==Orientation.portrait?260:220.0,
                      //maxCrossAxisExtent: 220.0,
                      //mainAxisExtent: 350,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: .5),
                  itemCount: searchProductController.productList.value.length,
                  //homePageDataController.homePageBackInStock.value.products!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleGridItem(
                      // key: _globalKey,
                      productModel:
                      searchProductController.productList.value[index],
                      /* proId: searchProductController
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
                      groupId: searchCategoryProductController
                              .productList.value[index].groupId ??
                          0,
                      productFrom: searchCategoryProductController
                              .productList.value[index].productFrom ??
                          "",
                      discountPrice: searchCategoryProductController
                              .productList.value[index].discountPrice ??
                          0,
                      categoryId: '13',*/
                    );
                  },
                ),
              ),
            ),
            if (searchProductController.isLoadingMore.value)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColorRed,
                ),
              )
          ],
        ),
        SideMenuBar(page: "SearchPage"),
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
        )
      ],
    );
  }

  void searchByKey() {
    searchProductController.searchKey.value = searchKeyController.text;
    searchProductController.fetchData();
    searchProductController.isLoading.value = true;
  }

  void loadMoreData() {
    currentPosition.value=_scrollController.position.pixels;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (searchProductController.searchProductsModel.value.currentPage !=
          searchProductController.searchProductsModel.value.lastPage &&
          !searchProductController.isLoadingMore.value) {
        searchProductController.isLoadingMore.value = true;

        searchProductController.loadMoreData(searchProductController
            .searchProductsModel.value.nextPageUrl
            .toString());
      }
    }
  }

/*  Widget landscapeView() {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_outlined),
                  ),
                  HeaderText(
                    text: "TheMall",
                    align: TextAlign.start,
                    size: 26.sp,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(child: searchButton()),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                      text:
                          "Items: ${searchProductController.productList.value.length}"
                          " of ${(searchProductController.searchProductsModel.value.total ?? 0)}",
                      align: TextAlign.start,
                      fontWeight: FontWeight.normal,
                    ),
                    //Icon(Icons.filter_alt_outlined)
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                   // controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loadData(4),
                        loadMore(),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

/*  showResult() {
    return Obx(() =>
        SearchProductGrid(products: searchProductController.productList.value));
  }*/

/*  Widget loadData(int rowElement) {
    return searchProductController.isLoading.value
        ? ProductGridShimmer(
            text: "",
            image: false,
          ) */ /*const Center(

            child: CircularProgressIndicator(
            color: AppColors.mainColorRed,
          ))*/ /*
        : showResult();
  }*/

/* Widget loadMore() {
    return searchProductController.isLoadingMore.value
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColorRed,
            ),
          )
        : const Text("");
  }*/

/*  bodyContent_2() {
    return Stack(
      children: [
        Column(
          children: [
            headerSection(),
            Flexible(
              child: SingleChildScrollView(
                  //controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      loadData(2),
                      loadMore(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            ),
          ],
        ),
        SideMenuBar(page: "SearchPage"),
      ],
    );
  }*/

  void goToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInToLinear);
  }
}
