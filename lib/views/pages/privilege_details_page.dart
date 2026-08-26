import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/header_text.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/privilege_details_controller.dart';
import '../../models/privilege_details_model.dart';
import 'no_internet_page.dart';

class PrivilegeDetailsPage extends StatelessWidget {
  PrivilegeDetailsPage({super.key});

  var privilegeID = Get.arguments[0].toString();
  var categoryName = Get.arguments[1].toString();
  var catagory = "".obs;

  final PrivilegeDetailsController pController =
      Get.put(PrivilegeDetailsController());
  final ScrollController _controller = ScrollController();
  late WebViewController _webViewController;
  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    catagory.value = categoryName;
    pController.privilegeID.value = privilegeID;
    pController.fetchData();

    return Obx(
      () => internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
              
          ? const NoInternetConnectionPage()
          : SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  /*backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),*/
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  title: HeaderText(
                    text: catagory.value.toString(),
                    color: Colors.white,
                  ),
                ),
                body: pController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : bodyContent(),
              ),
          ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      controller: _controller,
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerSection(),
            SizedBox(
              height: 10.h,
            ),
            vipOfferSection(),
            SizedBox(
              height: 10.h,
            ),
            gallerySection(),
            SizedBox(
              height: 10.h,
            ),
            aboutSection(),
            SizedBox(
              height: 10.h,
            ),
            /*if(!pController.isLoading.value)mapSection(),
            SizedBox(
              height: 10.h,
            ),*/
            if ((pController.detailsData.value.childs??[]).isNotEmpty)
              nearbySection(),
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: /*FadeInImage(
                placeholder: const AssetImage("assets/images/no-img.jpg"),
                image:
                    NetworkImage(pController.detailsData.value.logo.toString()),
              ),*/
                  Image.network(
                pController.detailsData.value.logo ?? "",
                // fit: BoxFit.fill,
                frameBuilder: (_, image, loadingBuilder, __) {
                  if (loadingBuilder == null) {
                    return Image.asset(
                      "assets/images/no-img.jpg",
                      fit: BoxFit.cover,
                    );
                  }
                  return image;
                },
                loadingBuilder: (context, image, loading) {
                  if (loading == null) {
                    return image;
                  } else {
                    return Image.asset("assets/images/no-img.jpg",
                        fit: BoxFit.cover);
                  }
                },
              ),
            ),
          ),
          Container(
            color: AppColors.mainColorRed,
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: pController.detailsData.value.name.toString(),
                    color: Colors.white,
                    size: 20,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                  HeaderText(
                    text: pController.detailsData.value.categoryName.toString(),
                    color: Colors.white,
                    size: 14,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: RatingBarIndicator(
                      rating: 4.0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      itemCount: 5,
                      itemSize: 20.0.sp,
                      direction: Axis.horizontal,
                    ),
                  ),
                  HeaderText(
                    text: "⟟  ${pController.detailsData.value.address}",
                    color: Colors.white,
                    size: 14,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget vipOfferSection() {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            child: /*FadeInImage(
              placeholder: const AssetImage("assets/images/no-img.jpg"),
              image: NetworkImage(pController
                  .detailsData.value.offerForVipCustomer?.bannerImage??""),
              fit: BoxFit.cover,
            ),*/
                Image.network(
              pController.detailsData.value.offerForVipCustomer?.bannerImage ??
                  "",
              fit: BoxFit.cover,
              frameBuilder: (_, image, loadingBuilder, __) {
                if (loadingBuilder == null) {
                  return Image.asset(
                    "assets/images/no-img.jpg",
                    fit: BoxFit.cover,
                  );
                }
                return image;
              },
              loadingBuilder: (context, image, loading) {
                if (loading == null) {
                  return image;
                } else {
                  return Image.asset("assets/images/no-img.jpg",
                      fit: BoxFit.cover);
                }
              },
            ),
          ),
          SizedBox(
            //color: AppColors.mainColorRed,
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: pController
                        .detailsData.value.offerForVipCustomer?.discountText??"",
                    color: AppColors.mainColorRed,
                    size: 20,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                  HeaderText(
                    text:
                        "Valid For: ${pController.detailsData.value.offerForVipCustomer?.validFor??""}",
                    color: AppColors.headerTextColor,
                    size: 14,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                  HeaderText(
                    text:
                        "Valid Till: ${pController.detailsData.value.offerForVipCustomer?.validTill??""}",
                    color: AppColors.headerTextColor,
                    size: 14,
                    maxLine: 20,
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r))),
                        height: 30.h,
                        onPressed: () {
                          Get.defaultDialog(
                              buttonColor: AppColors.mainColorRed,
                              confirmTextColor: Colors.white,
                              title: "Offer Details",
                              textConfirm: "Ok",
                              onConfirm: () => Get.back(),
                              content:Container(
                                height: 200.h,
                                width: 300.w,
                                child: Html(
                                  shrinkWrap: true,
                                    data: (pController
                                            .detailsData
                                            .value
                                            .offerForVipCustomer??OfferForVipCustomerModel())
                                            .discountDetails ??
                                        "",
                                    onLinkTap: (String? url,
                                        //RenderContext context,
                                        Map<String, String> attributes,
                                        dom.Element? element) async {
                                      final Uri _url = Uri.parse(url!);
                                      if (!await launchUrl(_url,
                                          mode: LaunchMode.externalApplication)) {
                                        throw 'Could not launch $_url';
                                      }
                                    }),
                              ),
                          );
                        },
                        color: AppColors.mainColorRed,
                        child: HeaderText(
                          text: "DETAILS",
                          color: Colors.white,
                          size: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r))),
                        height: 30.h,
                        onPressed: () {
                          Get.defaultDialog(
                              buttonColor: AppColors.mainColorRed,
                              confirmTextColor: Colors.white,
                              title: "Terms & Conditions",
                              textConfirm: "Ok",
                              onConfirm: () => Get.back(),
                              content: Container(
                                height: 200.h,
                                width: 300.h,
                                child: Html(
                                  shrinkWrap: true,
                                    data: (pController
                                            .detailsData
                                            .value
                                            .offerForVipCustomer??OfferForVipCustomerModel())
                                            .discountTermsAndConditions ??
                                        "",
                                    onLinkTap: (String? url,
                                       // RenderContext context,
                                        Map<String, String> attributes,
                                        dom.Element? element) async {
                                      final Uri _url = Uri.parse(url!);
                                      if (!await launchUrl(_url,
                                          mode: LaunchMode.externalApplication)) {
                                        throw 'Could not launch $_url';
                                      }
                                    }),
                              ));
                        },
                        color: AppColors.mainColorRed,
                        child: HeaderText(
                          text: "T & C",
                          color: Colors.white,
                          size: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget gallerySection() {
    return Card(
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: HeaderText(
                  text: "Gallery",
                  size: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
              ListView.separated(
                itemCount: pController.detailsData.value.galleries?.length??0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (buildContext, index) {
                  return /*FadeInImage(
                      alignment: Alignment.topLeft,
                      placeholder: const AssetImage("assets/images/no-img.jpg"),
                      image: NetworkImage(pController
                          .detailsData.value.galleries![index]
                          .toString()));*/
                      Image.network(
                    pController.detailsData.value.galleries?[index] ?? "",
                    //fit: BoxFit.fill,
                    alignment: Alignment.topLeft,
                    frameBuilder: (_, image, loadingBuilder, __) {
                      if (loadingBuilder == null) {
                        return Image.asset(
                          "assets/images/no-img.jpg",
                          fit: BoxFit.cover,
                        );
                      }
                      return image;
                    },
                    loadingBuilder: (context, image, loading) {
                      if (loading == null) {
                        return image;
                      } else {
                        return Image.asset("assets/images/no-img.jpg",
                            fit: BoxFit.cover);
                      }
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(padding: EdgeInsets.only(bottom: 1));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutSection() {
    return Card(
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: HeaderText(
                  text: "About",
                  size: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "Timing",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.bodyTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              Html(
                  data: pController.detailsData.value.timing ?? "",
                  onLinkTap: (String? url,
                      //RenderContext context,
                      Map<String, String> attributes,
                      dom.Element? element) async {
                    final Uri _url = Uri.parse(url!);
                    if (!await launchUrl(_url,
                        mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $_url';
                    }
                  }),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                "Speciality",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.bodyTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              Html(
                  data: pController.detailsData.value.specialties ?? "",
                  onLinkTap: (String? url,
                     // RenderContext context,
                      Map<String, String> attributes,
                      dom.Element? element) async {
                    final Uri _url = Uri.parse(url!);
                    if (!await launchUrl(_url,
                        mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $_url';
                    }
                  }),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Contact",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.bodyTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                pController.detailsData.value.mobile ?? "",
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.bodyTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: () async {
                  var fUrl = pController.detailsData.value.facebook ?? "";
                  if (fUrl.isNotEmpty) {
                    String url = "fb://facewebmodal/f?href=$fUrl";
                    //String url = fUrl;
                    final Uri _url = Uri.parse(url);
                    try {
                      if (!await launchUrl(
                        _url,
                      )) {
                        throw 'Could not launch $_url';
                      }
                    } on Exception catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      //String url="https://www.facebook.com/themallbd";
                      final Uri _url = Uri.parse(fUrl);
                      if (!await launchUrl(_url,
                          mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $_url';
                      }
                    }
                  }
                },
                child: Text(
                  pController.detailsData.value.facebook ?? "",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.bodyTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mapSection() {
    return Card(
      child: SizedBox(
        height: 470,
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (String url) {
                  if (pController.isReLoading.value) {
                    _webViewController.reload();
                  }
                },
              ),
            )
            ..loadHtmlString(
              '<html lang="en"><meta name="viewport" content="width=device-width, initial-scale=1">'
                  '<body>${pController.detailsData.value.locations![0]}</body></html>',
            ),
        ),
      ),
    );
  }

  Widget nearbySection() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: HeaderText(
            text: "Nearby",
            size: 22,
            fontWeight: FontWeight.normal,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            // childAspectRatio: .80
          ),
          itemCount: pController.detailsData.value.childs!.length,
          //homePageDataController.homePageBackInStock.value.products!.length,
          itemBuilder: (BuildContext context, int index) {
            return gridItem(index);
          },
        ),
      ],
    );
  }

  Widget gridItem(int index) {
    return InkWell(
      onTap: () async {
        _controller.animateTo(0,
            duration: const Duration(seconds: 2), curve: Curves.decelerate);
        pController.privilegeID.value =
            pController.detailsData.value.childs![index].id.toString();
        catagory.value = pController
            .detailsData.value.childs![index].categoryName
            .toString();
        pController.fetchData();
        if (!pController.isReLoading.value) {
          _webViewController
              .loadHtmlString(
                  '<html lang="en"><meta name="viewport" content="width=device-width, initial-scale=1"><body>${pController.detailsData.value.locations![0]}</body></html>')
              .toString();
        }

        //pController.reLoadMap();
      },
      child: Obx(
        () => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: /*FadeInImage(
                  placeholder: const AssetImage("assets/images/no-image_card.jpg"),
                  image: NetworkImage(
                    pController.detailsData.value.childs![index].logo
                        .toString(),
                  ),
                ),*/
                    Image.network(
                  pController.detailsData.value.childs?[index].logo ?? "",
                 // fit: BoxFit.fill,
                  frameBuilder: (_, image, loadingBuilder, __) {
                    if (loadingBuilder == null) {
                      return Image.asset(
                        "assets/images/no-img.jpg",
                        fit: BoxFit.cover,
                      );
                    }
                    return image;
                  },
                  loadingBuilder: (context, image, loading) {
                    if (loading == null) {
                      return image;
                    } else {
                      return Image.asset("assets/images/no-img.jpg",
                          fit: BoxFit.cover);
                    }
                  },
                ),
              ),
              HeaderText(
                text: pController.detailsData.value.childs![index].name
                    .toString()
                    .toUpperCase(),
                fontWeight: FontWeight.normal,
                size: 18,
                maxLine: 4,
              ),
              SizedBox(
                height: 10.h,
              ),
              HeaderText(
                text: pController.detailsData.value.childs![index].categoryName
                    .toString()
                    .toUpperCase(),
                color: Colors.green,
                size: 12,
                fontWeight: FontWeight.normal,
              ),
              SizedBox(
                height: 10.h,
              ),
              HeaderText(
                text: pController.detailsData.value.childs![index].discountText
                    .toString()
                    .toUpperCase(),
                color: Colors.red,
                size: 14,
                fontWeight: FontWeight.normal,
              )
            ],
          ),
        ),
      ),
    );
  }
}
