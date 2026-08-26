// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

List<ProductsModel> productsModelFromJson(String str) => List<ProductsModel>.from(json.decode(str).map((x) => ProductsModel.fromJson(x)));

String productsModelToJson(List<ProductsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsModel {
  ProductsModel({
    this.productId,
    this.name,
    this.brandId,
    this.brandName,
    this.image,
    this.productIn,
    this.regularPrice,
    this.discountPrice,
    this.appPrice,
    this.isBestseller,
    this.isFav,
    this.isNew,
    this.isBack,
    this.productFrom,
    this.groupId,
    this.reviewCount,
    this.reviewRate,
    this.cartRuleTitle,
    this.slug
  });

  int? productId;
  String? name;
  int? brandId;
  String? brandName;
  String? image;
  int? productIn;
  dynamic regularPrice;
  dynamic discountPrice;
  dynamic appPrice;
  int? isBestseller;
  int? isFav;
  int? isNew;
  int? isBack;
  String? productFrom;
  int? groupId;
  int? reviewCount;
  dynamic reviewRate;
  dynamic cartRuleTitle;
  String? slug;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    productId: json["product_id"],
    name: json["name"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    image: json["image"],
    productIn: json["product_in"],
    regularPrice: json["regular_price"],
    discountPrice: json["discount_price"],
    appPrice: json["app_price"],
    isBestseller: json["is_bestseller"],
    isFav: json["is_fav"],
    isNew: json["is_new"],
    isBack: json["is_back"],
    productFrom: json["product_from"],
    groupId: json["group_id"],
    reviewCount: json["review_count"],
    reviewRate: json["review_rate"],
    cartRuleTitle: json["cart_rule_title"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "brand_id": brandId,
    "brand_name": brandName,
    "image": image,
    "product_in": productIn,
    "regular_price": regularPrice,
    "discount_price": discountPrice,
    "app_price": appPrice,
    "is_bestseller": isBestseller,
    "is_fav": isFav,
    "is_new": isNew,
    "is_back": isBack,
    "product_from": productFrom,
    "group_id": groupId,
    "review_count": reviewCount,
    "review_rate": reviewRate,
    "cart_rule_title": cartRuleTitle,
    "slug": slug,
  };
}



/*class ProductsModel {
  int? productId;
  String? name;
  int? brandId;
  String? brandName;
  String? image;
  int? productIn;
  int? regularPrice;
  int? discountPrice;
  int? appPrice;
  int? isBestseller;
  int? isFav;
  int? isNew;
  int? isBack;
  String? productFrom;
  int? groupId;
  int? reviewCount;
  dynamic reviewRate;

  ProductsModel(
      {this.productId,
      this.name,
      this.brandId,
      this.brandName,
      this.image,
      this.productIn,
      this.regularPrice,
      this.discountPrice,
      this.appPrice,
      this.isBestseller,
      this.isFav,
      this.isNew,
      this.isBack,
      this.productFrom,
      this.groupId,
      this.reviewCount,
      this.reviewRate});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    image = json['image'];
    productIn = json['product_in'];
    regularPrice = json['regular_price'];
    discountPrice = json['discount_price'];
    appPrice = json['app_price'];
    isBestseller = json['is_bestseller'];
    isFav = json['is_fav'];
    isNew = json['is_new'];
    isBack = json['is_back'];
    productFrom = json['product_from'];
    groupId = json['group_id'];
    reviewCount = json['review_count'];
    reviewRate = json['review_rate'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['brand_id'] = brandId;
    data['brand_name'] = brandName;
    data['image'] = image;
    data['product_in'] = productIn;
    data['regular_price'] = regularPrice;
    data['discount_price'] = discountPrice;
    data['app_price'] = appPrice;
    data['is_bestseller'] = isBestseller;
    data['is_fav'] = isFav;
    data['is_new'] = isNew;
    data['is_back'] = isBack;
    data['product_from'] = productFrom;
    data['group_id'] = groupId;
    data['review_count'] = reviewCount;
    data['review_rate'] = reviewRate;
    return data;
  }
}*/
