// To parse this JSON data, do
//
//     final dynamicPageDetailModel = dynamicPageDetailModelFromJson(jsonString);

import 'dart:convert';

DynamicPageDetailModel dynamicPageDetailModelFromJson(String str) => DynamicPageDetailModel.fromJson(json.decode(str));

String dynamicPageDetailModelToJson(DynamicPageDetailModel data) => json.encode(data.toJson());

class DynamicPageDetailModel {
  DynamicPageDetailModel({
    this.id,
    this.slug,
    this.header,
    this.content,
    this.status,
    this.pageGroup,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? slug;
  String? header;
  String? content;
  int? status;
  dynamic pageGroup;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DynamicPageDetailModel.fromJson(Map<String, dynamic> json) => DynamicPageDetailModel(
    id: json["id"],
    slug: json["slug"],
    header: json["header"],
    content: json["content"],
    status: json["status"],
    pageGroup: json["page_group"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "header": header,
    "content": content,
    "status": status,
    "page_group": pageGroup,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
