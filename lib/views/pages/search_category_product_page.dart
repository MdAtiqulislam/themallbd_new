import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../controllers/search_category_product_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/side_menu_bar.dart';

class SearchCategoryProduct extends StatelessWidget {
  SearchCategoryProduct({super.key});

  final endPoint = Get.arguments;

  final SearchCategoryProductController searchCategoryProductController =
      Get.put(SearchCategoryProductController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    searchCategoryProductController.fetchData(endPoint);
    _scrollController.addListener(() {
      loadMoreData();
    });
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(
          () {
            return searchCategoryProductController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              height: 50.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  HeaderText(
                                    text:
                                        "Items: ${searchCategoryProductController.searchCategoryProductsModel.value.total}",
                                    align: TextAlign.start,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  //Icon(Icons.filter_alt_outlined)
                                ],
                              ),
                            ),
                            loadData(),
                            loadMore(),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      SideMenuBar(),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget loadData() {
    return ProductGrid(
      products: searchCategoryProductController.productList,
      viewShowMoreButton: false,
      showMoreTag: "",
    );
  }

  Widget loadMore() {
    return searchCategoryProductController.isLoadingMore.value
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColorRed,
            ),
          )
        : const Text("");
  }

  void loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (searchCategoryProductController
              .searchCategoryProductsModel.value.currentPage !=
          searchCategoryProductController
              .searchCategoryProductsModel.value.lastPage) {
        searchCategoryProductController.isLoadingMore.value = true;
        searchCategoryProductController.loadMoreData(
            searchCategoryProductController
                .searchCategoryProductsModel.value.nextPageUrl
                .toString());
      }
    }
  }

/*  Future<bool> _onWillPop() async {

    if(isExpanded.value){
     // isOpen ? controller.forward() : controller.reverse();
      isExpanded.value=!isExpanded.value;
      return false;
    }else {
      return true;
    }
  }*/
}
