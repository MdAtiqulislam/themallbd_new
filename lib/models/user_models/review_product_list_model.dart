// To parse this JSON data, do
//
//     final reviewProductListModel = reviewProductListModelFromJson(jsonString);

import 'dart:convert';

List<ReviewProductListModel> reviewProductListModelFromJson(String str) => List<ReviewProductListModel>.from(json.decode(str).map((x) => ReviewProductListModel.fromJson(x)));

String reviewProductListModelToJson(List<ReviewProductListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewProductListModel {
  ReviewProductListModel({
    this.productId,
    this.name,
    this.image,
    this.brandId,
    this.brandName,
  });

  int? productId;
  String? name;
  String? image;
  dynamic? brandId;
  dynamic? brandName;

  factory ReviewProductListModel.fromJson(Map<String, dynamic> json) => ReviewProductListModel(
    productId: json["product_id"] == null ? null : json["product_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId == null ? null : productId,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "brand_id": brandId,
    "brand_name": brandName,
  };
}
