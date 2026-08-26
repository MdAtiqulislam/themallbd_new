import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../controllers/search_category_product_controller.dart';
import '../controllers/search_product_controller.dart';
import '../utils/custom_menu_clipper.dart';


class SideMenuBar extends StatefulWidget {
 final String? page;

  const SideMenuBar({this.page, super.key});

  @override
  State<SideMenuBar> createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  var isExpanded = false.obs;

  //RangeValues _currentRangeValues = const RangeValues(0, 10000);
  /*var filterKey="".obs;
  var nameFilter="".obs;
  var priceFilter="".obs;
  var sliderMin=0.obs;
  var sliderMax=10000.obs;
  RangeValues currentRangeValues = const RangeValues(0, 10000);*/

  /*SearchCategoryProductController searchCategoryProductController =
      Get.put(SearchCategoryProductController());*/

  var searchProductController;
  var searchCategoryProductController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.page == "SearchPage") {
      searchProductController = Get.put(SearchProductController());
    }else{
      searchCategoryProductController =
          Get.put(SearchCategoryProductController());
    }
  }

  //var nameFilter="".obs;
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Obx(
          () => AnimatedPositioned(
            height: Get.height,
/*            top: 0,
            bottom: 0,*/
            right: isExpanded.value ? 0 : -250.w,
            duration: const Duration(milliseconds: 500),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: CustomMenuClipper(position: "left"),
                  child: Container(
                    width: 25,
                    height: 90,
                    color: AppColors.mainColorRed.withOpacity(.9),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(2),
                      onPressed: () {
                        isExpanded.value = !isExpanded.value;
                      },
                      child: isExpanded.value
                          ? const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                sideBarMenuItems()
              ],
            ),
          ),
        ));
  }

  Widget sideBarMenuItems() {
    return Container(
      width: 250.w,
      height: Get.height,
      color: AppColors.mainColorRed.withOpacity(.9),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:  EdgeInsets.only(top:20.h,bottom: 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CircleAvatar(
                      backgroundColor: AppColors.mainColorRed,
                      radius: 50.r,
                      backgroundImage: const AssetImage("assets/filter.png"),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    HeaderText(
                      text: "Filter Your Search By:",
                      align: TextAlign.center,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: Colors.white,
              ),
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.page != "SearchPage"
                        ? Card(
                            elevation: 5,
                            color: searchCategoryProductController
                                        .nameFilter.value ==
                                    "ASC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor: searchCategoryProductController
                                        .nameFilter.value ==
                                    "ASC"
                                ? Colors.grey.withOpacity(.5)
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchCategoryProductController
                                        .nameFilter.value ==
                                    "ASC") {
                                  searchCategoryProductController
                                      .nameFilter.value = "";
                                } else {
                                  searchCategoryProductController
                                      .nameFilter.value = "ASC";
                                }
                                searchCategoryProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Alphabetically A to Z",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 5,
                            color: searchProductController.nameFilter.value ==
                                    "ASC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor:
                                searchProductController.nameFilter.value ==
                                        "ASC"
                                    ? Colors.grey.withOpacity(.5)
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchProductController.nameFilter.value ==
                                    "ASC") {
                                  searchProductController.nameFilter.value = "";
                                } else {
                                  searchProductController.nameFilter.value =
                                      "ASC";
                                }
                                searchProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Alphabetically A to Z",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    widget.page != "SearchPage"
                        ? Card(
                            elevation: 5,
                            color: searchCategoryProductController
                                        .nameFilter.value ==
                                    "DESC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor: searchCategoryProductController
                                        .nameFilter.value ==
                                    "DESC"
                                ? Colors.grey.withOpacity(.5)
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchCategoryProductController
                                        .nameFilter.value ==
                                    "DESC") {
                                  searchCategoryProductController
                                      .nameFilter.value = "";
                                } else {
                                  searchCategoryProductController
                                      .nameFilter.value = "DESC";
                                }
                                searchCategoryProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Alphabetically Z to A",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 5,
                            color: searchProductController.nameFilter.value ==
                                    "DESC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor:
                                searchProductController.nameFilter.value ==
                                        "DESC"
                                    ? Colors.grey.withOpacity(.5)
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchProductController.nameFilter.value ==
                                    "DESC") {
                                  searchProductController.nameFilter.value = "";
                                } else {
                                  searchProductController.nameFilter.value =
                                      "DESC";
                                }
                                searchProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Alphabetically Z to A",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    /*SizedBox(
                      height: 10,
                    ),*/

                    widget.page != "SearchPage"
                        ? Card(
                            elevation: 5,
                            color: searchCategoryProductController
                                        .priceFilter.value ==
                                    "ASC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor: searchCategoryProductController
                                        .priceFilter.value ==
                                    "ASC"
                                ? Colors.grey.withOpacity(.5)
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchCategoryProductController
                                        .priceFilter.value ==
                                    "ASC") {
                                  searchCategoryProductController
                                      .priceFilter.value = "";
                                } else {
                                  searchCategoryProductController
                                      .priceFilter.value = "ASC";
                                }
                                searchCategoryProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Price Low to High",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 5,
                            color: searchProductController.priceFilter.value ==
                                    "ASC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor:
                                searchProductController.priceFilter.value ==
                                        "ASC"
                                    ? Colors.grey.withOpacity(.5)
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchProductController.priceFilter.value ==
                                    "ASC") {
                                  searchProductController.priceFilter.value =
                                      "";
                                } else {
                                  searchProductController.priceFilter.value =
                                      "ASC";
                                }
                                searchProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Price Low to High",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    widget.page != "SearchPage"
                        ? Card(
                            elevation: 5,
                            color: searchCategoryProductController
                                        .priceFilter.value ==
                                    "DESC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor: searchCategoryProductController
                                        .priceFilter.value ==
                                    "DESC"
                                ? Colors.grey.withOpacity(.5)
                                : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchCategoryProductController
                                        .priceFilter.value ==
                                    "DESC") {
                                  searchCategoryProductController
                                      .priceFilter.value = "";
                                } else {
                                  searchCategoryProductController
                                      .priceFilter.value = "DESC";
                                }
                                searchCategoryProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Price High to Low",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            elevation: 5,
                            color: searchProductController.priceFilter.value ==
                                    "DESC"
                                ? Colors.red
                                : Colors.transparent,
                            shadowColor:
                                searchProductController.priceFilter.value ==
                                        "DESC"
                                    ? Colors.grey.withOpacity(.5)
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (searchProductController.priceFilter.value ==
                                    "DESC") {
                                  searchProductController.priceFilter.value =
                                      "";
                                } else {
                                  searchProductController.priceFilter.value =
                                      "DESC";
                                }
                                searchProductController.searchFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeaderText(
                                  text: "Price High to Low",
                                  align: TextAlign.start,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HeaderText(
                            text: "Price Range",
                            align: TextAlign.start,
                            color: Colors.white),
                      ),
                    ),
                    widget.page != "SearchPage"
                        ? RangeSlider(
                            activeColor: Colors.white,
                            values: searchCategoryProductController
                                .currentRangeValues,
                            max: 10000,
                            min: 0,
                            divisions: 1000,
                            labels: RangeLabels(
                              searchCategoryProductController
                                  .currentRangeValues.start
                                  .round()
                                  .toString(),
                              searchCategoryProductController
                                  .currentRangeValues.end
                                  .round()
                                  .toString(),
                            ),
                            onChanged: (RangeValues values) {
                              searchCategoryProductController.sliderMin.value =
                                  searchCategoryProductController
                                      .currentRangeValues.start
                                      .round();
                              searchCategoryProductController.sliderMax.value =
                                  searchCategoryProductController
                                      .currentRangeValues.end
                                      .round();

                              setState(() {
                                searchCategoryProductController
                                    .currentRangeValues = values;
                              });
                            },
                            onChangeEnd: (RangeValues values) {
                              searchCategoryProductController.searchFilter();
                            },
                          )
                        : RangeSlider(
                            activeColor: Colors.white,
                            values: searchProductController.currentRangeValues,
                            max: 10000,
                            min: 0,
                            divisions: 1000,
                            labels: RangeLabels(
                              searchProductController.currentRangeValues.start
                                  .round()
                                  .toString(),
                              searchProductController.currentRangeValues.end
                                  .round()
                                  .toString(),
                            ),
                            onChanged: (RangeValues values) {
                              searchProductController.sliderMin.value =
                                  searchProductController
                                      .currentRangeValues.start
                                      .round();
                              searchProductController.sliderMax.value =
                                  searchProductController.currentRangeValues.end
                                      .round();

                              setState(() {
                                searchProductController.currentRangeValues =
                                    values;
                              });
                            },
                            onChangeEnd: (RangeValues values) {
                              searchProductController.searchFilter();
                            },
                          ),
                    widget.page != "SearchPage"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeaderText(
                                  text:
                                      "${searchCategoryProductController.sliderMin.value}",
                                  color: Colors.white,
                                  size: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                HeaderText(
                                  text:
                                      "${searchCategoryProductController.sliderMax.value}",
                                  color: Colors.white,
                                  size: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeaderText(
                                  text:
                                      "${searchProductController.sliderMin.value}",
                                  color: Colors.white,
                                  size: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                HeaderText(
                                  text:
                                      "${searchProductController.sliderMax.value}",
                                  color: Colors.white,
                                  size: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 200.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  Future<bool> _onWillPop() async {
    if (isExpanded.value) {
      // isOpen ? controller.forward() : controller.reverse();
      isExpanded.value = !isExpanded.value;
      return false;
    } else {
      return true;
    }
  }
}
