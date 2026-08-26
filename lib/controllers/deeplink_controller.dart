/*


import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:themallbd_new/controllers/product_details_controller.dart';
import '../constraints/app_strings.dart';
import 'blogs/blog_view_controller.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLink();

      print("Initial Link: $initialLink");

      if (initialLink != null) {
        handleDeepLink(initialLink);
      }

      _appLinks.stringLinkStream.listen(
            (link) {
              print("Deep link:$link");

          if (link != null && link.isNotEmpty) {
            handleDeepLink(Uri.parse(link));
          }
        },
        onError: (err) {
          debugPrint('AppLinks error: $err');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }

  void handleDeepLink(Uri deepLink) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final pathSegments = deepLink.pathSegments;
      if (pathSegments.isEmpty) {
        debugPrint("Deep link has no path segments.");
        return;
      }

      /// Handle 'sale' link
      if (pathSegments.first == "sale") {
        Get.toNamed(
          '/test',
          arguments: [
            "${AppStrings.searchOfferEndPoint}${""}",
            "OFFERS",
          ],
        );
        return;
      }

      // Handle "blog" links
      if (pathSegments.first == "blog") {
        await Future.delayed(const Duration(seconds: 1)).then((value){
          Get.back();
          Get.put(BlogViewController()).key.value=pathSegments.last;
          Get.find<BlogViewController>().fetchData();
          Get.toNamed('/blog_view');
        });
        return;
      }

      /// Handle 'product' link
      if (pathSegments.first == "product") {
        final productId = pathSegments.last;
        final params = deepLink.queryParameters;
        final productType = params["type"];

        if (productType == null) {
          debugPrint("Missing 'type' query parameter.");
          return;
        }

        // Avoid navigating again if already on same product page
        if (Get.currentRoute == '/product_details_page') {
          final existing = Get.isRegistered<ProductDetailsController>()
              ? Get.find<ProductDetailsController>()
              : null;

          if (existing?.proId.value == productId) {
            debugPrint("Already on this product page.");
            return;
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));

        final productDetailsController = Get.isRegistered<ProductDetailsController>()
            ? Get.find<ProductDetailsController>()
            : Get.put(ProductDetailsController());

        productDetailsController.reLoading.value = true;
        productDetailsController.proId.value = productId;

        final parameters = <String, String>{
          "name": "",
          "descriptionText": "",
          "regularPrice": "",
          "appPrice": "",
          "rating": "",
          "isBestSeller": "",
          "isFavourite": "",
          "isBackInStock": "",
          "isNewArrival": "",
          "review": "",
          "imageUrl": "",
          "groupId": "",
        };

        Get.toNamed(
          '/product_details_page',
          arguments: [productId, ""],
          parameters: parameters,
        );
      }
    } catch (e) {
      debugPrint("Deep link error: $e");
    } finally {
      // Prevent re-entry for a short time
      Future.delayed(const Duration(seconds: 2), () {
        _isNavigating = false;
      });
    }
  }
}
*/


import 'dart:async';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../constraints/app_strings.dart';
import 'blogs/blog_view_controller.dart';
import 'package:themallbd_new/controllers/product_details_controller.dart';

class DeepLinkController extends GetxController {
  final AppLinks _appLinks = AppLinks();
  static const MethodChannel _channel = MethodChannel('com.themallbd.deeplink/channel');
  bool _isNavigating = false;
  StreamSubscription<String>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
    _initNativeDeepLinkListener();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initDeepLinks() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      print("Initial Link: $initialLink");

      if (initialLink != null) {
        handleDeepLink(initialLink);
      }

      _linkSubscription = _appLinks.stringLinkStream.listen(
            (link) {
          print("🔗 Deep link (stream): $link");
          if (link.isNotEmpty) {
            handleDeepLink(Uri.parse(link));
          }
        },
        onError: (err) {
          debugPrint('AppLinks error: $err');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize deep links: $e');
    }
  }

  void _initNativeDeepLinkListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLinkReceived') {
        final String link = call.arguments;
        debugPrint("📥 Native iOS Deep Link received: $link");
        final uri = Uri.tryParse(link);
        if (uri != null) {
          handleDeepLink(uri);
        }
      }
    });
  }

  void handleDeepLink(Uri deepLink) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final pathSegments = deepLink.pathSegments;
      if (pathSegments.isEmpty) {
        debugPrint("Deep link has no path segments.");
        _isNavigating = false;
        return;
      }

      /// Handle 'sale' link
      if (pathSegments.first == "sale") {
        Get.toNamed(
          '/test',
          arguments: [
            "${AppStrings.searchOfferEndPoint}${""}",
            "OFFERS",
          ],
        );
        _isNavigating = false;
        return;
      }
      /// Handle 'category' link
      if (pathSegments.first == "category") {
        Get.toNamed(
          '/test',
          arguments: [
        "${AppStrings.searchByCategoryWithSlugEndPoint}${pathSegments.last}",
            (pathSegments.last.toUpperCase()),
          ],
        );
        _isNavigating = false;
        return;
      }
      /// Handle 'offer' link
      if (pathSegments.first == "offer") {
        Get.toNamed(
          '/test',
          arguments: [
        "${AppStrings.searchOfferWithSlugEndPoint}${pathSegments.last}",
            (pathSegments.last.toUpperCase()),
          ],
        );
        _isNavigating = false;
        return;
      }

      /// Handle 'brand' link
      if (pathSegments.first == "brand") {
        Get.toNamed(
          '/test',
          arguments: [
            "${AppStrings.searchBrandWithSlugEndPoint}${pathSegments.last}",
            (pathSegments.last.toUpperCase()),
          ],
        );
        _isNavigating = false;
        return;
      }

      /// Handle 'blog' links
      if (pathSegments.first == "blog") {
        await Future.delayed(const Duration(seconds: 1));
        if(Get.isRegistered<BlogViewController>()) {
          Get.find<BlogViewController>().key.value = pathSegments.last;
          Get.find<BlogViewController>().fetchData();
        } else {
          final blogController = Get.put(BlogViewController());
          blogController.key.value = pathSegments.last;
          blogController.fetchData();
        }
        Get.toNamed('/blog_view');
        _isNavigating = false;
        return;
      }

      /// Handle 'product' link
      if (pathSegments.first == "product") {
        final productId = pathSegments.last;
        final params = deepLink.queryParameters;
        final productType = params["type"];

        if (productType == null) {
          debugPrint("Missing 'type' query parameter.");
          _isNavigating = false;
          return;
        }

        // Avoid navigating again if already on same product page
        if (Get.currentRoute == '/product_details_page') {
          final existing = Get.isRegistered<ProductDetailsController>()
              ? Get.find<ProductDetailsController>()
              : null;

          if (existing?.proId.value == productId) {
            debugPrint("Already on this product page.");
            _isNavigating = false;
            return;
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));

        final productDetailsController = Get.isRegistered<ProductDetailsController>()
            ? Get.find<ProductDetailsController>()
            : Get.put(ProductDetailsController());

        productDetailsController.reLoading.value = true;
        productDetailsController.proId.value = productId;

        final parameters = <String, String>{
          "name": "",
          "descriptionText": "",
          "regularPrice": "",
          "appPrice": "",
          "rating": "",
          "isBestSeller": "",
          "isFavourite": "",
          "isBackInStock": "",
          "isNewArrival": "",
          "review": "",
          "imageUrl": "",
          "groupId": "",
        };

        Get.toNamed(
          '/product_details_page',
          arguments: [productId, ""],
          parameters: parameters,
        );
        _isNavigating = false;
        return;
      }
      // If none matched, reset _isNavigating
      _isNavigating = false;
    } catch (e) {
      debugPrint("Deep link error: $e");
      _isNavigating = false;
    }
  }
}

