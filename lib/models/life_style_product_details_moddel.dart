// To parse this JSON data, do
//
//     final shippingMethodModel = shippingMethodModelFromJson(jsonString);

import 'dart:convert';

import 'package:themallbd_new/models/product_details_model.dart';

LifeStyleProductDetailsModel lifeStyleProductDetailsModelFromJson(String str) => LifeStyleProductDetailsModel.fromJson(json.decode(str));

String lifeStyleProductDetailsModelToJson(LifeStyleProductDetailsModel data) => json.encode(data.toJson());

class LifeStyleProductDetailsModel {
  LifeStyleProductDetailsModel({
    this.productDetails,
    this.colorGroup,
  });

  ProductDetailsMode? productDetails;
  List<ColorGroup>? colorGroup;

  factory LifeStyleProductDetailsModel.fromJson(Map<String, dynamic> json) => LifeStyleProductDetailsModel(
    productDetails: json["product_details"] == null ? null : ProductDetailsMode.fromJson(json["product_details"]),
    colorGroup: json["color_group"] == null ? null : List<ColorGroup>.from(json["color_group"].map((x) => ColorGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_details": productDetails?.toJson(),
    "color_group": colorGroup == null ? null : List<dynamic>.from(colorGroup!.map((x) => x.toJson())),
  };
}

class ColorGroup {
  ColorGroup({
    this.color,
    this.colorCode,
    this.images,
    this.data,
  });

  String? color;
  String? colorCode;
  List<String>? images;
  List<LifeStyleData>? data;

  factory ColorGroup.fromJson(Map<String, dynamic> json) => ColorGroup(
    color: json["color"],
    colorCode: json["color_code"],
    images: json["images"] == null ? null : List<String>.from(json["images"].map((x) => x)),
    data: json["data"] == null ? null : List<LifeStyleData>.from(json["data"].map((x) => LifeStyleData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "color": color,
    "color_code": colorCode,
    "images": images == null ? null : List<dynamic>.from(images!.map((x) => x)),
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LifeStyleData {
  LifeStyleData({
    this.productId,
    this.name,
    this.size,
    this.regularPrice,
    this.discountPrice,
    this.appPrice,
    this.productIn,
    this.cartRuleTitle,
    this.cartRuleDescription,
  });

  int? productId;
  String? name;
  String? size;
  dynamic regularPrice;
  dynamic discountPrice;
  dynamic appPrice;
  dynamic productIn;
  dynamic cartRuleTitle;
  dynamic cartRuleDescription;

  factory LifeStyleData.fromJson(Map<String, dynamic> json) => LifeStyleData(
    productId: json["product_id"],
    name: json["name"],
    size: json["size"],
    regularPrice: json["regular_price"],
    discountPrice: json["discount_price"],
    appPrice: json["app_price"],
    productIn: json["product_in"],
    cartRuleTitle: json["cart_rule_title"],
    cartRuleDescription: json["cart_rule_description"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name ,
    "size": size ,
    "regular_price": regularPrice,
    "discount_price": discountPrice,
    "app_price": appPrice ,
    "product_in": productIn,
    "cart_rule_title": cartRuleTitle,
    "cart_rule_description": cartRuleDescription,
  };
}

