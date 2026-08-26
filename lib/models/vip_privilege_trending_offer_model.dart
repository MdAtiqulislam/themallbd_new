// To parse this JSON data, do
//
//     final trendingOffersModel = trendingOffersModelFromJson(jsonString);

import 'dart:convert';

List<TrendingOffersModel> trendingOffersModelFromJson(String str) => List<TrendingOffersModel>.from(json.decode(str).map((x) => TrendingOffersModel.fromJson(x)));

String trendingOffersModelToJson(List<TrendingOffersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrendingOffersModel {
  TrendingOffersModel({
    this.id,
    this.name,
    this.discountText,
    this.details,
    this.imageUrl,
    this.category,
    this.categoryLogo,
  });

  int? id;
  String? name;
  String? discountText;
  dynamic details;
  String? imageUrl;
  TrendingOffersCategory? category;
  String? categoryLogo;

  factory TrendingOffersModel.fromJson(Map<String, dynamic> json) => TrendingOffersModel(
    id: json["id"],
    name: json["name"],
    discountText: json["discount_text"],
    details: json["details"],
    imageUrl: json["image_url"],
    category: TrendingOffersCategory.fromJson(json["category"]),
    categoryLogo: json["category_logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "discount_text": discountText,
    "details": details,
    "image_url": imageUrl,
    "category": category?.toJson(),
    "category_logo": categoryLogo,
  };
}

class TrendingOffersCategory {
  TrendingOffersCategory({
    this.id,
    this.name,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? logo;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  factory TrendingOffersCategory.fromJson(Map<String, dynamic> json) => TrendingOffersCategory(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
