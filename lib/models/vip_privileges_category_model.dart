// To parse this JSON data, do
//
//     final vipPrivilegesCategoryModel = vipPrivilegesCategoryModelFromJson(jsonString);

import 'dart:convert';

List<VipPrivilegesCategoryModel> vipPrivilegesCategoryModelFromJson(String str) => List<VipPrivilegesCategoryModel>.from(json.decode(str).map((x) => VipPrivilegesCategoryModel.fromJson(x)));

String vipPrivilegesCategoryModelToJson(List<VipPrivilegesCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VipPrivilegesCategoryModel {
  VipPrivilegesCategoryModel({
    this.id,
    this.name,
    this.image,
  });

  int? id;
  String? name;
  String? image;

  factory VipPrivilegesCategoryModel.fromJson(Map<String, dynamic> json) => VipPrivilegesCategoryModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}
