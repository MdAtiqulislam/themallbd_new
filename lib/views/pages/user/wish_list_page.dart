import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constraints/app_colors.dart';
import '../../../constraints/body_text.dart';
import '../../../constraints/header_text.dart';
import '../../../controllers/user_controllers/wish_list_controller.dart';
import '../../../models/home_page_models/home_page_product_model.dart';
import '../../../widgets/custom_bottom_navigation_bar.dart';
import '../../screens/empty_cart.dart';

class WishListPage extends StatelessWidget {
  WishListPage({Key? key}) : super(key: key);
  final WishListController wishListController = Get.put(WishListController());

  //final ProductDetailsController productDetailsController = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
         /* backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: 'Wish List',
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () => wishListController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: bodyContent(),
                ),
        ),
      ),
    );
  }

  Widget bodyContent() {
    return wishListController.wishListModel!.isEmpty
        ? EmptyCard(
            image: "assets/images/empty_wishlist.png",
            title: "There are no items in your wishlist",
            bodyText:
                "Start Wishing and shop top brands and cult favourite now...",
            buttonText: "START SHOPPING",
            bottomText: "Please Add Item To Your Wishlist",
            onTap: () {
              Get.offAllNamed("/home_page");
            },
          )
        : wishListScreen(
            wishList: wishListController.wishListModel ?? [],
          );
  }

  Widget wishListScreen({required List<ProductsModel> wishList}) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wishList.length,
            itemBuilder: (buildContext, index) {
              return Dismissible(
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.black,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: HeaderText(
                      text: "DELETE",
                      color: Colors.white,
                      align: TextAlign.start,
                    ),
                  ),
                ),
                key: Key(wishList[index].productId.toString()),
                confirmDismiss: (direction) async {
                  var confirm = false.obs;
                  await Get.defaultDialog(
                    title: "Confirmation",
                    middleText:
                        "Are you sure you want to remove this item from your Wish list?",
                    backgroundColor: Colors.white,
                    titleStyle: const TextStyle(color: Colors.black),
                    middleTextStyle:
                        const TextStyle(color: AppColors.bodyTextColor),
                    textConfirm: "Confirm",
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black,
                    confirmTextColor: Colors.black,
                    buttonColor: Colors.grey,
                    barrierDismissible: false,
                    radius: 5,
                    onConfirm: () {
                      confirm.value = true;
                      Get.back();
                    },
                    onCancel: () => confirm.value = false,
                  );

                  return confirm.value;
                },
                onDismissed: (direction) => _deleteItem(
                  wishList[index].productId.toString(),
                ),
                child: listItem(
                  productModel: wishList[index],
                ),
              );
            }),
      ),
    );
  }

  Widget listItem({required ProductsModel productModel}) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey, width: .5),
      )),
      //height: 100,
      child: InkWell(
        onTap: () {
          var parameters = <String, String>{
            "proId": productModel.productId.toString(),
            "name": productModel.brandName ?? "",
            'descriptionText': productModel.name ?? "",
            'regularPrice': productModel.regularPrice.toString(),
            'appPrice': productModel.appPrice.toString(),
            'rating': productModel.reviewRate.toString(),
            'isBestSeller': productModel.isBestseller.toString(),
            'isFavourite': productModel.isFav.toString(),
            'isBackInStock': productModel.isBack.toString(),
            'isNewArrival': productModel.isNew.toString(),
            'review': productModel.reviewCount.toString(),
            'imageUrl': productModel.image.toString(),
            'groupId': productModel.groupId.toString(),
          };

          if (productModel.productFrom == "life_style") {
            Get.toNamed('/life_style_product_details_page',
                arguments: [
                  productModel.productId.toString(),
                ],
                parameters: parameters);
          } else {
            Get.toNamed('/product_details_page',
                arguments: [
                  productModel.productId.toString(),
                ],
                parameters: parameters);
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: /*FadeInImage(
                image: NetworkImage(
                  productModel.image ?? "",
                ),
                placeholder:
                    const AssetImage("assets/images/no-image_card.jpg"),
                imageErrorBuilder: (b, o, t) =>
                    Image.asset("assets/images/no-image_card.jpg"),
              ),*/
              Image.network(productModel.image??"",
                fit: BoxFit.fill,
                frameBuilder: (_, image, loadingBuilder, __) {
                  if (loadingBuilder == null) {
                    return Image.asset("assets/images/no-img.jpg",fit: BoxFit.cover,);
                  }
                  return image;
                },

                loadingBuilder:
                    (context, image, loading) {
                  if (loading == null) {
                    return image;
                  } else {
                    return Image.asset(
                        "assets/images/no-img.jpg",
                        fit: BoxFit.cover
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: productModel.brandName ?? "",
                      color: AppColors.bodyTextColor,
                    ),
                    BodyText(
                      text: productModel.name ?? "",
                      align: TextAlign.start,
                    ),
                    /*SizedBox(
                      height: 10.h,
                    ),*/
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                          child: HeaderText(
                            align: TextAlign.left,
                            fontWeight: FontWeight.normal,
                            text: "৳${productModel.discountPrice??0}",
                          ),
                        ),

                        if(productModel.regularPrice!=productModel.discountPrice)Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                          child: Text(
                            "৳${productModel.regularPrice??0}",
                            style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                    //app price
                    Padding(
                      padding:  EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                      ),
                      child: BodyText(
                        align: TextAlign.left,
                        fontWeight: FontWeight.normal,
                        color: AppColors.mainColorRed,
                        text: "App Price ৳${productModel.appPrice??0}",
                      ),
                    ),
                    SizedBox(height: 10.h,)
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: InkWell(
                onTap: () async {
                  await Get.defaultDialog(
                    title: "Confirmation",
                    middleText:
                        "Are you sure you want to remove this item from your Wish list?",
                    backgroundColor: Colors.white,
                    titleStyle: const TextStyle(color: Colors.black),
                    middleTextStyle:
                        const TextStyle(color: AppColors.bodyTextColor),
                    textConfirm: "Confirm",
                    textCancel: "Cancel",
                    cancelTextColor: Colors.black,
                    confirmTextColor: Colors.black,
                    buttonColor: Colors.grey,
                    barrierDismissible: false,
                    radius: 5,
                    onConfirm: () async {
                      _deleteItem(productModel.productId.toString());
                      Get.back();
                    },
                    onCancel: () => Get.back(),
                  );

                  //
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.w, vertical: 2.h),
                      child: HeaderText(
                        text: "delete".toUpperCase(),
                        fontWeight: FontWeight.normal,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteItem(String? productId) {
    wishListController.deleteFromWishList(productId);
  }
}
