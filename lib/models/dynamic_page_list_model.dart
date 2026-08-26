// To parse this JSON data, do
//
//     final dynamicPageListModel = dynamicPageListModelFromJson(jsonString);

import 'dart:convert';

List<DynamicPageListModel> dynamicPageListModelFromJson(String str) => List<DynamicPageListModel>.from(json.decode(str).map((x) => DynamicPageListModel.fromJson(x)));

String dynamicPageListModelToJson(List<DynamicPageListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DynamicPageListModel {
  DynamicPageListModel({
    this.id,
    this.slug,
    this.header,
    this.pageGroup,
  });

  int? id;
  String? slug;
  String? header;
  dynamic pageGroup;

  factory DynamicPageListModel.fromJson(Map<String, dynamic> json) => DynamicPageListModel(
    id: json["id"],
    slug: json["slug"],
    header: json["header"],
    pageGroup: json["page_group"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "header": header,
    "page_group": pageGroup,
  };
}
