// To parse this JSON data, do
//
//     final getBlogsModel = getBlogsModelFromJson(jsonString);

import 'dart:convert';

List<GetBlogsModel> getBlogsModelFromJson(String str) => List<GetBlogsModel>.from(json.decode(str).map((x) => GetBlogsModel.fromJson(x)));

String getBlogsModelToJson(List<GetBlogsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetBlogsModel {
  GetBlogsModel({
    this.id,
    this.title,
    this.categoryId,
    this.categoryName,
    this.image,
    this.tags,
    this.author,
    this.slug,
  });

  int? id;
  String? title;
  int? categoryId;
  String? categoryName;
  String? image;
  List<String>? tags;
  String? author;
  String? slug;

  factory GetBlogsModel.fromJson(Map<String, dynamic> json) => GetBlogsModel(
    id: json["id"],
    title: json["title"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    image: json["image"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    author: json["author"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category_id": categoryId,
    "category_name": categoryName,
    "image": image,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "author": author,
    "slug": slug,
  };
}
