import 'dart:convert';
import 'dart:io';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:themallbd_new/controllers/product_details_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constraints/app_colors.dart';
import '../constraints/app_strings.dart';
import '../constraints/body_text.dart';
import '../constraints/header_text.dart';
import '../models/app_version_model.dart';
import '../models/blog_models/blog_auto_scroo_slider_model.dart';
import '../models/home_page_models/home_page_blog_model.dart';
import '../models/home_page_models/home_page_brand_model.dart';
import '../models/home_page_models/home_page_category_model.dart';
import '../models/home_page_models/home_page_data_model.dart';
import '../models/home_page_models/home_page_productsblock_model.dart';
import '../models/home_page_models/home_page_skin_type_model.dart';
import '../models/home_page_models/notice_model.dart';
import '../models/home_page_models/offer_popup_model.dart';
import '../models/slider_images_model.dart';
import '../services/local_services.dart';
import '../services/notification_services.dart';
import '../services/remote_services.dart';
import '../widgets/offer_popup_widget.dart';
import 'blogs/blog_view_controller.dart';
import 'internet_controller.dart';
import 'package:path_provider/path_provider.dart';

class HomePageDataController extends GetxController {

  NotificationServices notificationServices = NotificationServices();
  //var productList=<SingleSearchProductModel>[].obs;
  var homePageSkinTypeList = <HomePageSkinTypesModel>[].obs;
  var homePageCategoryList = <HomePageCategoryModel>[].obs;
  //var homePageCategoryList = <HomePageCategoryModel>[].obs;
  var sliderImageList = <SliderImagesModel>[].obs;
  var sliderImages = [];
  var homePageBlogList = <HomePageBlogsModel>[].obs;
  var homePageBackInStock = HomePageProductsBlockModel().obs;
  var newArrival = HomePageProductsBlockModel().obs;
  var bestSeller = HomePageProductsBlockModel().obs;

  //var brands = HomePageBrandModel().obs;
  HomePageBrandModel brands = HomePageBrandModel();
  var babyCare = HomePageProductsBlockModel().obs;
  var lifeStyle = HomePageProductsBlockModel().obs;
  var exclusiveSale = HomePageProductsBlockModel().obs;
  var featuredProduct = HomePageProductsBlockModel().obs;
  var homePageDataModel = HomePageDataModel().obs;
  var noticeData = NoticeModel().obs;
  var appVersionData = AppVersionModel().obs;
  var autoScrollSliderData = <BlogAutoScrollSliderModel>[].obs;
  final InternetConnectionController internetController =
      Get.put(InternetConnectionController());

  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var loadingValue = 0.obs;
  var topTextExpand = true.obs;
  var showPrivilegeButton = false.obs;
  var dotPosition=0.obs;

  //var url="https://themallbd.com/api/v3/app-home-api/".obs;

  final endPoint = AppStrings.homePageDataEndPoint;
  var searchKey = "0".obs;

  var offerPopupData = OfferPopupModel().obs;

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    checkAppVersion();
    getNotice();
    checkVipPrivilege();
    fetchData();
    super.onInit();
  }


  Future<void> initDynamicLinks() async {
    try {
      final appLinks = AppLinks();  // Create an instance of AppLinks
      // Handle initial link
      var initialLink = await appLinks.getInitialLink();


      if (initialLink != null) {
        handleDeepLink(initialLink);
        initialLink=null;
      }

      // Listen for incoming links while app is running
      appLinks.stringLinkStream.listen(( link) {
        handleDeepLink(Uri.parse(link));
            },

          onError: (err) {
        debugPrint('Error in app links: $err');
      });
    } catch (e) {
      debugPrint('Failed to initialize app links: $e');
    }
  }

  void handleDeepLink(Uri deepLink) async {
    if (kDebugMode) {
      print('Deep Link..........: $deepLink');
    }

    // Extract path segments
    final pathSegments = deepLink.pathSegments;

    print(pathSegments);

    if (pathSegments.isEmpty) {
      debugPrint("Deep link has no path segments.");
      return;
    }

    // Handle "sale" links
    if (pathSegments.first == "sale") {
      Get.toNamed(
        '/test',
        arguments: [
          "${AppStrings.searchOfferEndPoint}${""}",
          "Offers".toUpperCase(),
        ],
      );
      return;
    }

    // Handle "offer" links
    if (pathSegments.first == "offer") {
      Get.toNamed(
        '/test',
        arguments: [
          "${AppStrings.searchOfferWithSlugEndPoint}${pathSegments.last}",
          pathSegments.last.toUpperCase(),
        ],
      );
      return;
    }

    // Handle "category" links
    if (pathSegments.first == "category") {
      Get.toNamed(
        '/test',
        arguments: [
          "${AppStrings.searchByCategoryWithSlugEndPoint}${pathSegments.last}",
          pathSegments.last.toUpperCase(),
        ],
      );
      return;
    }
    // Handle "brand" links
    if (pathSegments.first == "brand") {
      Get.toNamed(
        '/test',
        arguments: [
          "${AppStrings.searchBrandWithSlugEndPoint}${pathSegments.last}",
          pathSegments.last.toUpperCase(),
        ],
      );
      return;
    }
    // Handle "blog" links
    if (pathSegments.first == "blog") {

      const CircularProgressIndicator();

      await Future.delayed(const Duration(seconds: 1)).then((value){
        Get.back();
        Get.put(BlogViewController()).key.value=pathSegments.last;
        Get.find<BlogViewController>().fetchData();
         Get.toNamed('/blog_view');
      });
      return;
    }

    // Handle "product" links
    if (pathSegments.first == "product") {
      final params = deepLink.queryParameters;
      // Check for null or missing "type"
      final productType = params["type"];
      if (productType == null) {
        debugPrint("Missing 'type' parameter in product deep link.");
        return;
      }

      final parameters = <String, String>{
        "name": "",
        'descriptionText': "",
        'regularPrice': "",
        'appPrice': "",
        'rating': "",
        'isBestSeller': "",
        'isFavourite': "",
        'isBackInStock': "",
        'isNewArrival': "",
        'review': "",
        'imageUrl': "",
        'groupId': "",
      };

     await Future.delayed(const Duration(seconds: 1)).then((value){
       final productDetailsController = Get.put(ProductDetailsController());
       productDetailsController.reLoading.value = true;
       productDetailsController.proId.value = pathSegments.last;

       // Navigate based on product type
       if (productType == "life-style") {
         Get.toNamed(
           '/product_details_page',
           arguments: [
             pathSegments.last,
             "",
           ],
           parameters: parameters,
         );
       }
       else {
         debugPrint("Unhandled product type: $productType");
         Get.toNamed(
           '/product_details_page',
           arguments: [
             pathSegments.last,
             "",
           ],
           parameters: parameters,
         );
       }
     });


    }
  }



  void fetchData() async {
    try {
      //getNotice();

      var data = await RemoteServices.fetchHomePageData(
          endPoint.toString() + searchKey.toString());
      if (data != null) {
        homePageDataModel.value = data;
        //image slider
        if (data.slider != null) {
          sliderImageList.value = data.slider ?? [];
          sliderImages = [];
          for (var element in sliderImageList.value) {
            sliderImages.add(element.image.toString());
          }
        }
        //skin type
        if (data.skinTypes != null) {
          homePageSkinTypeList.value = data.skinTypes ?? [];
        }
        //brand
        if (data.brand != null) {
          brands = data.brand!;
          //brands.value = data.brand!;
        }

        //category
        if (data.category != null) {
          homePageCategoryList.value = data.category ?? [];
        }
        //back in stock
        if (data.backInStock != null) {
          homePageBackInStock.value = data.backInStock!;
        }
        //New Arrival
        if (data.newArrival != null) {
          newArrival.value = data.newArrival!;
        }

        //Best Seller
        if (data.bestSeller != null) {
          bestSeller.value = data.bestSeller!;
        }
        //Baby Care
        if (data.babyCare != null) {
          babyCare.value = data.babyCare!;
        }
        //Life Style
        if (data.lifestyle != null) {
          lifeStyle.value = data.lifestyle!;
        }
        //Exclusive Sale
        if (data.exclusiveSale != null) {
          exclusiveSale.value = data.exclusiveSale!;
        }
        //Featured Products
        if (data.featured != null) {
          featuredProduct.value = data.featured!;
        }

        //Blog list
        if (data.blogs != null) {
          homePageBlogList.value = data.blogs ?? [];
        }
        if(data.offerPopup!=null){
          offerPopupData.value=data.offerPopup??OfferPopupModel();
          if(offerPopupData.value.appStatus??false)openPopupOffer();
        }
      }

    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreData() {
    // homePageDataController.isLoadingMore.value = false;

    loadingValue.value++;
    isLoadingMore.value = true;
    searchKey.value = loadingValue.toString();
    fetchData();
  }



  void fetchAutoScrollSliderData() async {
    // isLoading.value=true;
    const String endPoint = AppStrings.getBlogAutoScrollSliderEndPoint;
    try {
      var data = await RemoteServices.fetchBlogAutoScrollData(endPoint);
      if (data != null) {
        autoScrollSliderData.value = data;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getNotice() async {
    const endPoint = AppStrings.noticeEndPoint;
    var response = await RemoteServices.getRequest(endPoint, {"": ""});
    if (response != null) {
      noticeData.value = noticeModelFromJson(response);
      AppStrings.getNoticeMsg.value = noticeData.value.title ?? "";
    }
  }

  void checkVipPrivilege() async {
    var endPoint = AppStrings.chekVipPrivilegeEndPoint;
    var response = await RemoteServices.getRequest(endPoint, {"": ""});
    if (response != null) {
      var data = jsonDecode(response);
      showPrivilegeButton.value=data["status"]??false;
      await LocalServices.storeVipPrivilege(data["status"]??false);
    }
  }

  void checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var currentAppVersion = packageInfo.version;
    var previousAppVersion = await LocalServices.getPreviousAppVersion() ?? "";

    // print("Current app version: $currentAppVersion    previous app version: ${previousAppVersion.toString()}");

    if (previousAppVersion.toString().isNotEmpty) {
      if (previousAppVersion != currentAppVersion) {
        // print("Version is not matched~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        _deleteCacheDir(currentAppVersion);
      } else {
        //_deleteCacheDir(currentAppVersion);
        // print("Cached Not Cleared~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
    } else {
      LocalServices.storeAppVersion(currentAppVersion);
      // print("AppVersion Updated~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    }

    const endPoint = AppStrings.getVersionEndPoint;
    var data = await RemoteServices.getRequest(endPoint, {"": ""});


    if (data != null && Platform.isAndroid) {
      appVersionData.value = appVersionModelFromJson(data);
      if (appVersionData.value.version != currentAppVersion &&
          appVersionData.value.androidTestVersion != currentAppVersion &&
          appVersionData.value.androidTestVersion!="10.1.12"
      ) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                  color: AppColors.mainColorRed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: HeaderText(
                      text: appVersionData.value.majorMsg?.title ?? "",
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                content: BodyText(
                  text: appVersionData.value.majorMsg?.msg ?? "",
                  maxLine: 10,
                  size: 14,
                ),
                actions: <Widget>[
                  MaterialButton(
                    autofocus: true,
                    textColor: AppColors.mainColorRed,
                    focusColor: AppColors.mainColorRed,
                    splashColor: AppColors.mainColorRed,
                    focusElevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.mainColorRed),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // color: AppColors.mainColorRed,
                    onPressed: () {
                      if (Platform.isAndroid) {
                        final appId = appVersionData.value.majorMsg!.url!.apk!
                            .split("id")[1];
                        final url = Uri.parse("market://details?id$appId");
                        launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: const Text(
                      "Update",
                    ),
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.mainColorRed),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textColor: AppColors.mainColorRed,
                      splashColor: AppColors.mainColorRed,
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("Cancel"))
                ],
              ),
            );
          },
        );
      }
    }

    else if (data != null && Platform.isIOS) {
      appVersionData.value = appVersionModelFromJson(data);

      if (appVersionData.value.iosVersion != currentAppVersion &&
          appVersionData.value.iosTestVersion != currentAppVersion) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                titlePadding: const EdgeInsets.all(0),
                title: Container(
                  color: AppColors.mainColorRed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: HeaderText(
                      text: appVersionData.value.majorMsg?.title ?? "",
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                content: BodyText(
                  text: appVersionData.value.majorMsg?.msg ?? "",
                  maxLine: 10,
                  size: 14,
                ),
                actions: <Widget>[
                  MaterialButton(
                    autofocus: true,
                    textColor: AppColors.mainColorRed,
                    focusColor: AppColors.mainColorRed,
                    splashColor: AppColors.mainColorRed,
                    focusElevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.mainColorRed),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // color: AppColors.mainColorRed,
                    onPressed: () {

                      /*if (Platform.isAndroid) {
                          final appId = appVersionData.value.majorMsg!.url!.apk!
                              .split("id")[1];
                          final url = Uri.parse("market://details?id$appId");
                          launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }*/

                      if (Platform.isIOS) {
                        // final appId=appVersionData.value.majorMsg!.url!.apk!.split("id")[1];
                        final url = Uri.parse(
                            appVersionData.value.majorMsg!.url!.ios.toString());
                        launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }

                      /*if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid ? 'YOUR_ANDROID_PACKAGE_ID' : 'YOUR_IOS_APP_ID';
                    final url = Uri.parse(
                      Platform.isAndroid
                           "market://details?id=$appId"
                          ? "market://details?id=com.themallbd.mobileapp&hl=en-GB"
                          : "https://apps.apple.com/app/id$appId",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
              },
             */
                    },
                    child: const Text(
                      "Update",
                    ),
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.mainColorRed),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textColor: AppColors.mainColorRed,
                      splashColor: AppColors.mainColorRed,
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("Cancel"))
                ],
              ),
            );
          },
        );
      }
    }
  }




  Future<void> _deleteCacheDir(String currentAppVersion) async {
    isLoading.value = true;

    try {
      // print("Cache deleting.......................................................................");

      /*var _appDir = (await getTemporaryDirectory()).path;
       Directory(_appDir).delete(recursive: true);*/

      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        //  print("Cache deleted.......................................................................");
      }
      final appDir = await getApplicationSupportDirectory();
      if (appDir.existsSync()) {
        appDir.deleteSync(recursive: true);
        // print("Data deleted.......................................................................");
      }
      LocalServices.storeAppVersion(currentAppVersion);
    } finally {
      isLoading.value = false;
      LocalServices.deleteData();
      fetchData();
    }
  }

  void controlSliderClick(SliderImagesModel i) async {
    if (i.moduleType == "custom") {
      String url = i.customUrl ?? "";
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $_url';
      }
    } else if (i.moduleType == "offer") {
      Get.toNamed('/test',
          arguments:
          ["${AppStrings.searchOfferEndPoint}${i.moduleId.toString()}",
           i.moduleName??"".toUpperCase(),
          ]
      );
    }else if (i.moduleType == "brand") {
      Get.toNamed('/test', arguments: [
        "${AppStrings.searchBrandEndPoint}${i.moduleId.toString()}",
        i.moduleName??"".toUpperCase()
      ]);
    }else if (i.moduleType == "category") {
      Get.toNamed('/test', arguments: [
        "${AppStrings.searchByCategoryEndPoint}${i.moduleId.toString()}",
        i.moduleName??"".toUpperCase()
      ]);
    }
  }

 void handelRefresh() {
    dotPosition=0.obs;
    homePageSkinTypeList.value =[];
    homePageCategoryList.value = [];
   //var homePageCategoryList = <HomePageCategoryModel>[].obs;
    sliderImageList.value= [];
    sliderImages = [];
    homePageBlogList.value = [];
    homePageBackInStock.value =HomePageProductsBlockModel();
    newArrival.value = HomePageProductsBlockModel();
    bestSeller.value = HomePageProductsBlockModel();

   //var brands = HomePageBrandModel().obs;
    brands = HomePageBrandModel();
    babyCare.value = HomePageProductsBlockModel();
    lifeStyle.value = HomePageProductsBlockModel();
    exclusiveSale.value = HomePageProductsBlockModel();
    featuredProduct = HomePageProductsBlockModel().obs;
    homePageDataModel = HomePageDataModel().obs;
    noticeData = NoticeModel().obs;
    appVersionData = AppVersionModel().obs;
    autoScrollSliderData = <BlogAutoScrollSliderModel>[].obs;

    searchKey.value="0";
    isLoading.value=true;
   // initDynamicLinks();
    checkAppVersion();
    getNotice();
    fetchData();
  }

  Future<void> openPopupOffer()async {
    await LocalServices.getOfferPopupShownStatus().then((value) async {
      if (!value) {
        OfferPopupWidget.show(
            imageUrl: offerPopupData.value.imageUrl??"",
            deeplink: offerPopupData.value.deepLink??"",
            onDeepLink: (value) async {
              await LocalServices.storeOfferPopupShownStatus(true);
              handleDeepLink(Uri.parse(value));
            }
        );
      }
    });

  }


}
