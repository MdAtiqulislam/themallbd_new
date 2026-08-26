import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/header_text.dart';
import '../../models/home_page_models/home_page_product_model.dart';

class SliverProductGrid extends StatelessWidget {
  final List<ProductsModel>? products;
  final String? imageUrl;
  final String? blockTitle;
  final String showMoreTag;
  final bool viewShowMoreButton;

  const SliverProductGrid(
      {Key? key,
      this.blockTitle = "",
      required this.products,
      this.imageUrl = "",
      this.viewShowMoreButton = true,
      required this.showMoreTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverVisibility(
        visible: products!.isNotEmpty,
        sliver: SliverToBoxAdapter(
          child: Stack(
            children: [
              HeaderText(
                text: blockTitle.toString(),
                align: TextAlign.center,
                size: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 16.h
                    : 16.w,
              ),
              FadeInImage(
                placeholder: const AssetImage("assets/images/no-img.jpg"),
                image: NetworkImage(imageUrl ?? ""),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (b, c) {
                    return const Text("dddd");
                  },
                    childCount: 100,

                ),
              ),
            ],
          ),
        ));

    /*Visibility(
      visible: products!.isNotEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: blockTitle!.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.all(20.0.h),
              child:
              HeaderText(text: blockTitle.toString(), align: TextAlign.center,
                size: MediaQuery.of(context).orientation==Orientation.portrait?16.h:16.w,
              ),
            ),
          ),
          Stack(
            children: [
              //image
              Visibility(
                visible: imageUrl!.isNotEmpty,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FadeInImage(
                    //imageSemanticLabel: imageUrl!,
                    fit: BoxFit.fill,
                    placeholder: const AssetImage("assets/images/no-img.jpg"),
                    image: NetworkImage(imageUrl!),
                  ),),
              ),
              Column(
                children: [
                  Visibility(
                    visible: imageUrl!.isNotEmpty,
                    child: SizedBox(
                        height:MediaQuery.of(context).orientation==Orientation.portrait?167.h:167.w
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 10.0.w, right: 10.w),
                    child:SliverAppBar(),


                    */ /*GridView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        //shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            //mainAxisExtent: 350,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                            childAspectRatio: .5
                        ),
                        */ /**/ /* gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: MediaQuery.of(context).orientation==Orientation.portrait?2:4,
                         mainAxisSpacing: 5,
                         crossAxisSpacing: 5,
                         childAspectRatio:
                         .5,
                       ),*/ /**/ /*
                        itemCount: products!.length,
                        //homePageDataController.homePageBackInStock.value.products!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SingleCardItem(
                            proId: products![index].productId.toString(),
                            imageUrl: products![index].image??"",
                            proName: products![index].brandName??"Name",
                            descriptionText: products![index].name??"Description",
                            regularPrice: products![index].regularPrice??0,
                            appPrice: products![index].appPrice??0,
                            rating: products![index].reviewRate??0,
                            review: products![index].reviewCount??0,
                            isBackInStock: products![index].isBack??0,
                            isBestSeller: products![index].isBestseller??0,
                            isNewArrival: products![index].isNew??0,
                            isFavourite: products![index].isFav??0,
                            categoryId: '13',
                          );
                        }),*/ /*
                  ),
                ],
              )
            ],
          ),
          Visibility(
            visible: viewShowMoreButton,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child:  Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: (){
                    */ /* Get.toNamed(
                      '/search_category_product',
                      //
                      arguments: "${AppStrings.searchShowMoreEndPoint}$showMoreTag",
                    );*/ /*
                    Get.toNamed('/test',
                        arguments:
                        ["${AppStrings.filterByProductTypeEndPoint}$showMoreTag",
                          blockTitle!.toUpperCase()
                        ]
                    );
                  },
                  child: const LoadMoreButton(),),
              ),
            ),
          ),

        ],
      ),
    );*/
  }
}
