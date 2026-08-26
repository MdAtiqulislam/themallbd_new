// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

List<WishListModel> wishListModelFromJson(String str) => List<WishListModel>.from(json.decode(str).map((x) => WishListModel.fromJson(x)));

String wishListModelToJson(List<WishListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishListModel {
  WishListModel({
    this.productId,
    this.name,
    this.brandId,
    this.brandName,
    this.image,
    this.ragularPrice,
    this.discountPrice,
  });

  int? productId;
  String? name;
  int? brandId;
  String? brandName;
  String? image;
  int? ragularPrice;
  int? discountPrice;

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    productId: json["product_id"],
    name: json["name"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    image: json["image"],
    ragularPrice: json["ragular_price"],
    discountPrice: json["discount_price"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "brand_id": brandId,
    "brand_name": brandName,
    "image": image,
    "ragular_price": ragularPrice,
    "discount_price": discountPrice,
  };
}
