import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:themallbd_new/services/remote_services.dart';
import '../constraints/app_strings.dart';
import '../models/app_review_image_model.dart';
import '../models/app_review_status_model.dart';
import '../widgets/rate_us_dialog.dart';
import 'local_services.dart';

class AppReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;
  static AppReviewStatusModel appReviewStatusModel = AppReviewStatusModel();

  static Future<void> openRatingDialog() async {
    AppReviewImageModel appReviewImageModel = AppReviewImageModel();
    var data = await RemoteServices.getRequest(
        AppStrings.getAppReviewImageEndPoint, {});
    if (data != null) {
      appReviewImageModel = appReviewImageModelFromJson(data);
    }
    await LocalServices.getAppReviewStatus().then((value) async {
      appReviewStatusModel = value ?? AppReviewStatusModel();
    });

    if (kDebugMode) {
      print("Is Reviewed: ${appReviewStatusModel.isReviewed}");
      print("Is Open: ${appReviewStatusModel.isOpen}");
      print("Is Later: ${appReviewStatusModel.isLater}");
      print("Review Date: ${appReviewStatusModel.reviewDate}");
    }

    if ((appReviewStatusModel.isLater ?? true) ||
        !(appReviewStatusModel.isReviewed ?? false)) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (buildContext) {
            return RateUsDialog(
              image: appReviewImageModel.image ?? "",
              onTapAlreadyRated: () => _handelAlreadyRated(),
              onTapLater: () => _handelLater(),
              onTapRateUs: () {
                Get.back();
                _handelRateUs();},
            );
          });
    }
  }

  static Future<void> _requestReview() => _inAppReview.requestReview();

  static Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: "1548101376",
      );

  static _handelRateUs() async {
    await _inAppReview.isAvailable().then((value) {
      if (value && !(appReviewStatusModel.isOpen ?? false)) {
        _requestReview();
      } else {
        _openStoreListing();
      }
    });
    appReviewStatusModel.isOpen = true;
    appReviewStatusModel.isLater = false;
    appReviewStatusModel.isReviewed = false;
    await LocalServices.storeAppReviewStatus(appReviewStatusModel);
  }

  static Future<void> _handelAlreadyRated() async {
    Get.back();
    appReviewStatusModel.isOpen = true;
    appReviewStatusModel.isLater = false;
    appReviewStatusModel.isReviewed = true;
    await LocalServices.storeAppReviewStatus(appReviewStatusModel);
  }

  static Future<void> _handelLater() async {
    Get.back();
    appReviewStatusModel.isLater = true;
    appReviewStatusModel.isReviewed = false;
    await LocalServices.storeAppReviewStatus(appReviewStatusModel);
  }
}
