// To parse this JSON data, do
//
//     final vipPrivilegesCategoryShopModel = vipPrivilegesCategoryShopModelFromJson(jsonString);

import 'dart:convert';

List<VipPrivilegesCategoryShopModel> vipPrivilegesCategoryShopModelFromJson(String str) => List<VipPrivilegesCategoryShopModel>.from(json.decode(str).map((x) => VipPrivilegesCategoryShopModel.fromJson(x)));

String vipPrivilegesCategoryShopModelToJson(List<VipPrivilegesCategoryShopModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VipPrivilegesCategoryShopModel {
  VipPrivilegesCategoryShopModel({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
    this.discountText,
    this.description,
    this.logo,
  });

  int? id;
  String? name;
  int? categoryId;
  String? categoryName;
  String? discountText;
  String? description;
  String? logo;

  factory VipPrivilegesCategoryShopModel.fromJson(Map<String, dynamic> json) => VipPrivilegesCategoryShopModel(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    discountText: json["discount_text"],
    description: json["description"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "category_name": categoryName,
    "discount_text": discountText,
    "description": description,
    "logo": logo,
  };
}
