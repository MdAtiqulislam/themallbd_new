import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/responsive_helper.dart';
import 'multiple_search_brand_list_page.dart';
import 'multiple_search_categories_page.dart';
import 'multiple_search_offer_list_page.dart';
import 'no_internet_page.dart';

class MultipleSearch extends StatelessWidget {
  MultipleSearch({Key? key}) : super(key: key);
  var cPageValue = 0.obs;
  PageController controller = PageController( initialPage: int.parse(Get.arguments[0]??"0"));
  final InternetConnectionController internetConnectionController=Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    //cPageValue.value=int.parse(Get.arguments[0]??"0");



    if(Get.arguments!=null){
      cPageValue.value=int.parse(Get.arguments[0]??"0");
    }else{
      cPageValue.value=0;
    }
    return SafeArea(
      child: Obx(() => internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
          ?const NoInternetConnectionPage()
          : ResponsiveHelper(
          landscape: landscapeView(),
          portrait: portraitView())),
    );
  }

  landscapeView() {
    return Scaffold(
      /*appBar: const CustomAppBar(),*/
      drawer: CustomDrawer(),
      bottomNavigationBar:  CustomBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: [Obx(
                  () {
                return SizedBox(
                  height: 35.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(0);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cPageValue.value == 0 ? Colors.black : Colors.white,
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Center(
                              child: HeaderText(
                                text: "Categories",
                                color: cPageValue.value == 0 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cPageValue.value == 1 ? Colors.black : Colors.white,
                              border:
                              Border.all(width: 1, color: Colors.black),),
                            child: Center(
                              child: HeaderText(
                                text: "Brands",
                                color: cPageValue.value == 1 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: cPageValue.value == 2 ? Colors.black : Colors.white,
                                border:
                                Border.all(width: 1, color: Colors.black)),
                            child: Center(
                              child: HeaderText(
                                text: "Offers",
                                color: cPageValue.value == 2 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
              SizedBox(height: 10.h,),
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int num) {
                    cPageValue.value = num;
                  },
                  controller: controller,
                  children:  <Widget>[
                    const MultipleSearchCategoriesPage(),
                    MultipleSearchBrandListPage(),
                    MultipleSearchOfferListPage(),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }

  portraitView() {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      bottomNavigationBar:  CustomBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: [Obx(
                  () {
                return SizedBox(
                  height: 35.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(0);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cPageValue.value == 0 ? Colors.black : Colors.white,
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Center(
                              child: HeaderText(
                                text: "Categories",
                                color: cPageValue.value == 0 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cPageValue.value == 1 ? Colors.black : Colors.white,
                              border:
                              Border.all(width: 1, color: Colors.black),),
                            child: Center(
                              child: HeaderText(
                                text: "Brands",
                                color: cPageValue.value == 1 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.jumpToPage(2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: cPageValue.value == 2 ? Colors.black : Colors.white,
                                border:
                                Border.all(width: 1, color: Colors.black)),
                            child: Center(
                              child: HeaderText(
                                text: "Offers",
                                color: cPageValue.value == 2 ? Colors.white : Colors.black,
                                align: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
              SizedBox(height: 10,),
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int num) {
                    cPageValue.value = num;
                  },

                  controller: controller,
                  children:  <Widget>[
                    const MultipleSearchCategoriesPage(),
                    MultipleSearchBrandListPage(),
                    MultipleSearchOfferListPage(),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }

}
