// To parse this JSON data, do
//
//     final brandListMode = brandListModeFromJson(jsonString);

import 'dart:convert';

List<BrandListMode> brandListModeFromJson(String str) => List<BrandListMode>.from(json.decode(str).map((x) => BrandListMode.fromJson(x)));

String brandListModeToJson(List<BrandListMode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandListMode {

  int? id;
  String? name;
  String? cartRuleTitle;
   String? slug;
  // String? metaDescription;
  // String? image;
   int? status;
  // int? isFeatured;
  // int? serial;
  // int? storeId;
  // int? createdBy;
  // int? updatedBy;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // DateTime? deletedAt;

  BrandListMode({
    this.id,
    this.name,
     this.slug,
    this.cartRuleTitle,
    // this.metaDescription,
    // this.image,
     this.status,
    // this.isFeatured,
    // this.serial,
    // this.storeId,
    // this.createdBy,
    // this.updatedBy,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
  });



  factory BrandListMode.fromJson(Map<String, dynamic> json) => BrandListMode(
    id: json["id"],
    name: json["name"],
     slug: json["slug"],
     cartRuleTitle: json["cart_rule_title"],
    // metaDescription: json["meta_description"],
    // image: json["image"],
     status: json["status"],
    // isFeatured: json["is_featured"],
    // serial: json["serial"],
    // storeId: json["store_id"],
    // createdBy: json["created_by"],
    // updatedBy: json["updated_by"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    // deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "cart_rule_title": cartRuleTitle,
    // "meta_description": metaDescription,
    // "image": image,
     "status": status,
    // "is_featured": isFeatured,
    // "serial": serial,
    // "store_id": storeId,
    // "created_by": createdBy,
    // "updated_by": updatedBy,
    // "created_at": createdAt?.toIso8601String(),
    // "updated_at": updatedAt?.toIso8601String(),
    // "deleted_at": deletedAt,
  };
}
