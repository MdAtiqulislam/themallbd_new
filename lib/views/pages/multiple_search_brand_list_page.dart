import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


import '../../constraints/app_colors.dart';
import '../../constraints/app_strings.dart';
import '../../constraints/body_text.dart';
import '../../controllers/brand_list_controller.dart';
import '../../models/brand_list_model.dart';
import '../../widgets/my_animated_text.dart';

class MultipleSearchBrandListPage extends StatelessWidget {
  MultipleSearchBrandListPage({super.key});

  TextEditingController searchController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  var selectedIndex = 0.obs;
  var itemLis = <BrandListMode>[].obs;
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final BrandListController brandListController =
      Get.put(BrandListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => brandListController.isLoading.value
        ? const Text("Please Wait....")
        : alphabetScrollList());
  }

  Widget alphabetScrollList() {
    return Column(
      children: [
        searchButton(),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [itemListView(), itemIndexView()],
          ),
        ),
      ],
    );
  }

  Widget itemListView() {
    itemLis.value = brandListController.brandList ?? [];

    return Obx(() => Flexible(
          child: ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: itemLis.value.length,
              itemBuilder: (buildContext, index) {
                return InkWell(
                  onTap: () {
                    Get.toNamed('/test', arguments: [
                      "${AppStrings.searchBrandEndPoint}${itemLis.value[index].id}",
                      (itemLis.value[index].name!.toUpperCase())
                    ]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemLis[index].name ?? ""),
                       if(itemLis[index].cartRuleTitle!=null)
                         MyAnimatedText(sentence: itemLis[index].cartRuleTitle ?? ""),
                         /*BodyText(text:itemLis[index].cartRuleTitle ?? "",color: AppColors.cart_rule_text_color,),
                   */   ],
                    ),
                  ),
                );
              }),
        ));
  }

  Widget itemIndexView() {
    List<String> indexList = [];
    for (var element in brandListController.brandList!) {
      indexList.add(element.name![0].toUpperCase());
    }
    var distinctIndex = indexList.toSet().toList();

    return Container(
      color: Colors.white.withOpacity(.5),
      width: 30,
      child: ListView.builder(
          itemCount: distinctIndex.length,
          itemBuilder: (buildContext, index) {
            return InkWell(
                onTap: () async {
                  selectedIndex.value = index;
                  scrollTo(brandListController.brandList!.indexWhere(
                      (element) => element.name![0] == distinctIndex[index]));
                },
                child: Obx(() => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedIndex.value == index
                              ? AppColors.mainColorRed
                              : Colors.transparent),
                      child: selectedIndex.value == index
                          ? BodyText(
                              text: distinctIndex[index],
                              align: TextAlign.center,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: 16,
                            )
                          : BodyText(
                              text: distinctIndex[index],
                              align: TextAlign.center,
                            ),
                    )));
          }),
    );
  }

  void scrollTo(int index) => itemScrollController.scrollTo(
      index: index,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
      alignment: 0);

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
          //controller: searchKeyController,
          onChanged: (value) {
            if (value.length >= 1) {
              filterList(value);
            } else {
              itemLis.value = brandListController.brandList ?? [];
            }
          },
          style: TextStyle(fontSize: 16.spMin),
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Search For Products'),
          onFieldSubmitted: (value) {
            if (value.length >= 3) {}
          },
        ),
      ),
    );
  }

  filterList(String value) {
    itemLis.value = [];
    for (var element in brandListController.brandList!) {
      //print(value.toUpperCase());
      //print(element.name!.contains(value));
      if (element.name!.toUpperCase().contains(value.toUpperCase())) {
        itemLis.value.add(element);
      }
    }
  }
}
