import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constraints/app_strings.dart';
import '../../constraints/header_text.dart';
import '../models/home_page_models/home_page_skin_type_model.dart';

class ShopBySkinType extends StatelessWidget {
  final bool isLoading;
  final List<HomePageSkinTypesModel> productList;

  const ShopBySkinType(
      {super.key, this.isLoading = true, required this.productList});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: Text(""))
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(.2),
            ),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 40.h
                        : 20.w,
                  ),
                  child: HeaderText(
                    text: 'SHOP BY SKIN TYPE',
                    align: TextAlign.center,
                    size: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 16.h
                        : 16.w,
                  ),
                ),
                GridView.builder(
                    padding: EdgeInsets.only(
                        left: 40.w, right: 40.w, top: 30.h, bottom: 30.h),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return singleItem(index);
                    }),
              ],
            ),
          );
  }

  Widget singleItem(int index) {
    return InkWell(
      onTap: () {
        /*Get.toNamed(
                              '/search_category_product',
                              arguments: "${AppStrings.searchSkinTypeEndPoint}${productList[index].type}");*/
        Get.toNamed('/test',
            arguments:
            ["${AppStrings.searchSkinTypeEndPoint}${productList[index].type}",
              productList[index].name!.toUpperCase()
            ]
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child:CachedNetworkImage(
              imageUrl:  productList[index].image!.thumbnail.toString(),
              placeholder: (context, url) => Image.asset('assets/images/no-image_card.jpg'),
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset('assets/images/no-image_card.jpg'),
            ),


            /*Image.network(
                                productList[index].image!.thumbnail.toString(),
                              ),*/
          ),
          Text(
            productList[index].name.toString().toUpperCase(),
            style: TextStyle(fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
