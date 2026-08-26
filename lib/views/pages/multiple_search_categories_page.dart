import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/app_strings.dart';
import '../../constraints/body_text.dart';
import '../../constraints/header_text.dart';
import '../../controllers/categories_controller.dart';
import '../../widgets/my_animated_text.dart';
import '../../widgets/responsive_helper.dart';
import '../../widgets/single_list_item.dart';

class MultipleSearchCategoriesPage extends StatefulWidget {
  const MultipleSearchCategoriesPage({super.key});

  @override
  State<MultipleSearchCategoriesPage> createState() =>
      _MultipleSearchCategoriesPageState();
}

class _MultipleSearchCategoriesPageState
    extends State<MultipleSearchCategoriesPage> {
  final CategoriesController categoriesController =
      Get.put(CategoriesController());
  PageController controller = PageController(viewportFraction: .85);
  var currentPageValue = 0.0;
  var scaleFactor = .8;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper(
        landscape: landscapeView(),
        portrait: portraitView());
  }

  Widget slider() {
    return SizedBox(
      height: 280.h,
      //  color: Colors.red,
      child: PageView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categoriesController.categoryList?.length??0,
          itemBuilder: (context, index) {
            //Transition Animation Start
            Matrix4 matrix = Matrix4.identity();
            if (currentPageValue.floor() == index) {
              var currScale =
                  1 - (currentPageValue - index) * (1 - scaleFactor);
              var curTran = 280.h * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1, currScale, 1)
                ..setTranslationRaw(0, curTran, 0);
            } else if (currentPageValue.floor() + 1 == index) {
              var currScale = scaleFactor +
                  (currentPageValue - index + 1) * (1 - scaleFactor);
              var curTran = 280.h * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1, currScale, 1)
                ..setTranslationRaw(0, curTran, 0);
            } else if (currentPageValue.floor() - 1 == index) {
              var currScale =
                  1 - (currentPageValue - index) * (1 - scaleFactor);
              var curTran = 280.h * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1, currScale, 1)
                ..setTranslationRaw(0, curTran, 0);
            } else {
              var curTran = 280.h * (1 - scaleFactor) / 2;
              matrix = Matrix4.diagonal3Values(1, scaleFactor, 1)
                ..setTranslationRaw(0, curTran, 0);
            }

            //Transition Animation End

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Transform(
                transform: matrix,
                child: InkWell(
                  onTap: (){

                    Get.toNamed('/test', arguments: [
                      "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![index].id}",
                      " ${categoriesController.categoryList![index].name!.toUpperCase()}"
                    ]);

                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainColorRed,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                categoriesController
                                    .categoryList![index].thumbnail
                                    .toString(),
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              //spreadRadius: 2.0,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50.h,
                          //width: 250,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Colors.white.withOpacity(.9),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HeaderText(
                                  text: categoriesController.categoryList![index].name
                                      .toString(),
                                  align: TextAlign.center,
                                ),
                                if(categoriesController.categoryList![index].cartRuleTitle!=null)
                                  Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                                    child: MyAnimatedText(sentence:categoriesController.categoryList![index].cartRuleTitle
                                        .toString() ,)

                                    /*BodyText(
                                    text: categoriesController.categoryList![index].cartRuleTitle
                                        .toString(),
                                    align: TextAlign.center,color: AppColors.cart_rule_text_color,
                                )*/,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget dotIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: DotsIndicator(
          dotsCount: categoriesController.categoryList!.length,
          position: currentPageValue.toDouble(),
          decorator: DotsDecorator(
            activeColor: AppColors.mainColorRed,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  Widget categoryName() {
    return HeaderText(
      text:
          "${categoriesController.categoryList![currentPageValue.floor()].name} Categories",
      align: TextAlign.start,
      fontWeight: FontWeight.normal,
    );
  }

  Widget categoryChildList() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoriesController
            .categoryList![currentPageValue.floor()].children!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              /* Get.toNamed('/search_category_product',
                  arguments: AppStrings.searchByCategoryEndPoint +
                      categoriesController
                          .categoryList![currentPageValue.floor()]
                          .children![index]
                          .id
                          .toString()
                  //arguments: categoriesController.categoryList![currentPageValue.floor()].children![index].id.toString(),
                  );*/
              Get.toNamed('/test', arguments: [
                "${AppStrings.searchByCategoryEndPoint}${categoriesController.categoryList![currentPageValue.floor()].children![index].id}",
                " ${categoriesController.categoryList![currentPageValue.floor()].children![index].name!.toUpperCase()}"
              ]);
            },
            child: SingleListItem(
              image: categoriesController
                  .categoryList![currentPageValue.floor()]
                  .children![index]
                  .thumbnail
                  .toString(),
              title: categoriesController
                  .categoryList![currentPageValue.floor()].children![index].name
                  .toString(),
              subTitle: categoriesController
                  .categoryList![currentPageValue.floor()].children![index].cartRuleTitle,

              trailing: const Icon(Icons.add),
            ),
          );
        });
  }

  Widget portraitView() {
    return SingleChildScrollView(
      child: Obx(() {
        return categoriesController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //slider
                  slider(),

                  //dot Indicator
                  dotIndicator(),

                  const SizedBox(
                    height: 20,
                  ),

                  //category name
                  categoryName(),

                  const SizedBox(
                    height: 10,
                  ),

                  //category child list
                  categoryChildList()
                ],
              );
      }),
    );
  }

  Widget landscapeView() {
    return Obx(() {
      return categoriesController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //slider
                          slider(),

                          //dot Indicator
                          dotIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 3,
                ),
                Container(
                  width: 2,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 3,
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                ),
                Flexible(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //category name
                        categoryName(),

                        //category child list
                        categoryChildList()
                      ],
                    ),
                  ),
                )
              ],
            );
    });
  }
}
