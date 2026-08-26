// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

AppReviewStatusModel appVersionModelFromJson(String str) => AppReviewStatusModel.fromJson(json.decode(str));

String appVersionModelToJson(AppReviewStatusModel data) => json.encode(data.toJson());

class AppReviewStatusModel {
  AppReviewStatusModel({
    this.isOpen,
    this.isLater,
    this.isReviewed,
    this.reviewDate
  });

  bool? isOpen;
  bool? isReviewed;
  bool? isLater;
  DateTime? reviewDate;

  factory AppReviewStatusModel.fromJson(Map<String, dynamic> json) => AppReviewStatusModel(
    isReviewed: json["is_reviewed"] ?? false,
    isLater: json["is_later"] ?? true,
    isOpen: json["is_open"]?? false,
    reviewDate: DateTime.parse(json["review_date"]??DateTime.now().toIso8601String()),
     );

  Map<String, dynamic> toJson() => {
    "is_reviewed": isReviewed ?? false,
    "is_later": isLater ?? true,
    "is_open": isOpen??false,
    "review_date": reviewDate?.toIso8601String(),
  };
}

