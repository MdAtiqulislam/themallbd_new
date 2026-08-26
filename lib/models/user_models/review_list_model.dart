import 'dart:convert';

import '../home_page_models/home_page_product_model.dart';


List<ReviewListModel> reviewListModelFromJson(String str) => List<ReviewListModel>.from(json.decode(str).map((x) => ReviewListModel.fromJson(x)));

String reviewListModelToJson(List<ReviewListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewListModel {
  ReviewListModel({
    this.title,
    this.review,
    this.rating,
    this.product,
  });

  String? title;
  String? review;
  int? rating;
  ProductsModel? product;

  factory ReviewListModel.fromJson(Map<String, dynamic> json) => ReviewListModel(
    title: json["title"],
    review: json["review"],
    rating: json["rating"],
    product: ProductsModel.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "review": review,
    "rating": rating,
    "product": product!.toJson(),
  };
}

