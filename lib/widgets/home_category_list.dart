import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/header_text.dart';
import '../constraints/app_strings.dart';
import '../models/home_page_models/home_page_category_model.dart';

class HomeCategoryList extends StatelessWidget {
  final String blockTitle;
  final bool isLoading;
  final List<HomePageCategoryModel> categoryList;

  const HomeCategoryList(
      {super.key,
      this.blockTitle = "Title",
      this.isLoading = true,
      required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Text("")
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
                child: HeaderText(
                    text: blockTitle.toString(), align: TextAlign.center),
              ),
              ListView.builder(
                  padding: EdgeInsets.only(bottom: 20.h),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  /* gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      //childAspectRatio: .7

                      */ /*
                       */ /* */ /*MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.3)*/ /*
                    ),*/
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: InkWell(
                        onTap: () {
                          /*Get.toNamed(
                            "/search_category_product",
                              arguments: "${AppStrings.searchByCategoryEndPoint}${categoryList[index].id}"
                            //arguments: categoryList[index].id.toString(),
                          );*/

                          Get.toNamed('/test', arguments: [
                            "${AppStrings.searchByCategoryEndPoint}${categoryList[index].id}",
                            (categoryList[index].name!.toUpperCase())
                          ]);
                        },
                        child: Image.network(
                          categoryList[index].image?.cover ?? "",
                          fit: BoxFit.fill,
                          frameBuilder: (_, image, loadingBuilder, __) {
                            if (loadingBuilder == null) {
                              return Container(
                                color: Colors.blueGrey.withOpacity(.2),
                                height: 80.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.w, bottom: 5.h),
                                      child: HeaderText(
                                          text: categoryList[index].name ?? ""),
                                    ),
                                    Image.asset(
                                      "assets/images/no-img.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return image;
                          },
                          loadingBuilder: (context, image, loading) {
                            if (loading == null) {
                              return image;
                            } else {
                              return Container(
                                color: Colors.blueGrey.withOpacity(.2),
                                height: 80.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.w, bottom: 5.h),
                                      child: HeaderText(
                                          text: categoryList[index].name ?? ""),
                                    ),
                                    Image.asset(
                                      "assets/images/no-img.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }),
            ],
          );
  }
}
