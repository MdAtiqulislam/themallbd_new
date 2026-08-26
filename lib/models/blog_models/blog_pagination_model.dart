
import 'dart:convert';

import 'get_blogs_model.dart';

BlogPaginationModel blogPaginationModelFromJson(String str) => BlogPaginationModel.fromJson(json.decode(str));

String blogPaginationModelToJson(BlogPaginationModel data) => json.encode(data.toJson());

class BlogPaginationModel {
  BlogPaginationModel({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.from,
    this.to,
    this.data,
  });

  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  dynamic prevPageUrl;
  String? path;
  int? from;
  int? to;
  List<GetBlogsModel>? data;

  factory BlogPaginationModel.fromJson(Map<String, dynamic> json) => BlogPaginationModel(
    total: json["total"] == null ? null : json["total"],
    perPage: json["per_page"] == null ? null : json["per_page"],
    currentPage: json["current_page"] == null ? null : json["current_page"],
    lastPage: json["last_page"] == null ? null : json["last_page"],
    firstPageUrl: json["first_page_url"] == null ? null : json["first_page_url"],
    lastPageUrl: json["last_page_url"] == null ? null : json["last_page_url"],
    nextPageUrl: json["next_page_url"] == null ? null : json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
    path: json["path"] == null ? null : json["path"],
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
    data: json["data"] == null ? null : List<GetBlogsModel>.from(json["data"].map((x) => GetBlogsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total == null ? null : total,
    "per_page": perPage == null ? null : perPage,
    "current_page": currentPage == null ? null : currentPage,
    "last_page": lastPage == null ? null : lastPage,
    "first_page_url": firstPageUrl == null ? null : firstPageUrl,
    "last_page_url": lastPageUrl == null ? null : lastPageUrl,
    "next_page_url": nextPageUrl == null ? null : nextPageUrl,
    "prev_page_url": prevPageUrl,
    "path": path == null ? null : path,
    "from": from == null ? null : from,
    "to": to == null ? null : to,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
