// To parse this JSON data, do
//
//     final appReviewImageModel = appReviewImageModelFromJson(jsonString);

import 'dart:convert';

AppReviewImageModel appReviewImageModelFromJson(String str) => AppReviewImageModel.fromJson(json.decode(str));

String appReviewImageModelToJson(AppReviewImageModel data) => json.encode(data.toJson());

class AppReviewImageModel {
  String? image;

  AppReviewImageModel({
    this.image,
  });

  factory AppReviewImageModel.fromJson(Map<String, dynamic> json) => AppReviewImageModel(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}
