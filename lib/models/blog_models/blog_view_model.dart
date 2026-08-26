// To parse this JSON data, do
//
//     final blogViewModel = blogViewModelFromJson(jsonString);

import 'dart:convert';

import 'blog_model.dart';

BlogViewModel blogViewModelFromJson(String str) => BlogViewModel.fromJson(json.decode(str));

String blogViewModelToJson(BlogViewModel data) => json.encode(data.toJson());

class BlogViewModel {
  BlogViewModel({
    this.blog,
    this.blogImageUrl,
    this.galleries,
    this.shareUrl,
    this.authorName,
    this.authorImage,
  });

  Blog? blog;
  String? blogImageUrl;
  List<dynamic>? galleries;
  String? shareUrl;
  String? authorName;
  String? authorImage;

  factory BlogViewModel.fromJson(Map<String, dynamic> json) => BlogViewModel(
    blog: Blog.fromJson(json["blog"]),
    blogImageUrl: json["blog_image_url"],
    galleries: List<dynamic>.from(json["galleries"].map((x) => x)),
    shareUrl: json["share_url"],
    authorName: json["author_name"],
    authorImage: json["author_image"],
  );

  Map<String, dynamic> toJson() => {
    "blog": blog?.toJson(),
    "blog_image_url": blogImageUrl,
    "galleries": List<dynamic>.from(galleries!.map((x) => x)),
    "share_url": shareUrl,
    "author_name": authorName,
    "author_image": authorImage,
  };
}

class Cover {
  Cover({
    this.id,
    this.postId,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? postId;
  int? type;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
    id: json["id"],
    postId: json["post_id"],
    type: json["type"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "type": type,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
