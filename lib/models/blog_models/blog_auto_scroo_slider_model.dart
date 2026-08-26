// To parse this JSON data, do
//
//     final blogAutoScrollSliderModel = blogAutoScrollSliderModelFromJson(jsonString);

import 'dart:convert';

List<BlogAutoScrollSliderModel> blogAutoScrollSliderModelFromJson(String str) => List<BlogAutoScrollSliderModel>.from(json.decode(str).map((x) => BlogAutoScrollSliderModel.fromJson(x)));

String blogAutoScrollSliderModelToJson(List<BlogAutoScrollSliderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogAutoScrollSliderModel {
  BlogAutoScrollSliderModel({
    this.id,
    this.linkType,
    this.likes,
    this.comments,
    this.url,
    this.image,
  });

  int? id;
  int? linkType;
  int? likes;
  int? comments;
  String? url;
  String? image;

  factory BlogAutoScrollSliderModel.fromJson(Map<String, dynamic> json) => BlogAutoScrollSliderModel(
    id: json["id"],
    linkType: json["link_type"],
    likes: json["likes"],
    comments: json["comments"],
    url: json["url"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "link_type": linkType,
    "likes": likes,
    "comments": comments,
    "url": url,
    "image": image,
  };
}
