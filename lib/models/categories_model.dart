import 'dart:convert';

List<CategoriesModel>? categoriesFromJson(String str) => List<CategoriesModel>.from(json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesToJson(List<CategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  CategoriesModel({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.serial,
    this.frontendShow,
    this.thumbnail,
    this.cartRuleTitle,
    this.cover,
    this.children,
  });

  int? id;
  String? name;
  String? slug;
  int? parentId;
  int? serial;
  int? frontendShow;
  String? thumbnail;
  String? cartRuleTitle;
  String? cover;
  List<CategoriesModel>? children;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    parentId: json["parent_id"],
    serial: json["serial"] ,
    frontendShow: json["frontend_show"],
    thumbnail: json["thumbnail"],
    cartRuleTitle: json["cart_rule_title"],
    cover: json["cover"],
    children: json["children"] == null ? null : List<CategoriesModel>.from(json["children"].map((x) => CategoriesModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "parent_id": parentId,
    "serial": serial,
    "frontend_show": frontendShow,
    "thumbnail": thumbnail,
    "cart_rule_title": cartRuleTitle,
    "cover": cover,
    "children": children == List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}
