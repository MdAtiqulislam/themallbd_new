import 'blog_view_model.dart';

class Blog {
  Blog({
    this.id,
    this.categoryId,
    this.subCatId,
    this.offerId,
    this.title,
    this.slug,
    this.description,
    this.status,
    this.isFeature,
    this.showWebsite,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.galleries,
    this.cover,
  });

  int? id;
  int? categoryId;
  dynamic subCatId;
  dynamic offerId;
  String? title;
  String? slug;
  String? description;
  int? status;
  int? isFeature;
  int? showWebsite;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? galleries;
  Cover? cover;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    id: json["id"],
    categoryId: json["category_id"],
    subCatId: json["sub_cat_id"],
    offerId: json["offer_id"],
    title: json["title"],
    slug: json["slug"],
    description: json["description"],
    status: json["status"],
    isFeature: json["is_feature"],
    showWebsite: json["show_website"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    galleries: List<dynamic>.from(json["galleries"].map((x) => x)),
    cover: Cover.fromJson(json["cover"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_cat_id": subCatId,
    "offer_id": offerId,
    "title": title,
    "slug": slug,
    "description": description,
    "status": status,
    "is_feature": isFeature,
    "show_website": showWebsite,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "galleries": List<dynamic>.from(galleries!.map((x) => x)),
    "cover": cover?.toJson(),
  };
}