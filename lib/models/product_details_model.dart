
/*
import 'dart:convert';

ProductDetailsMode productDetailsModeFromJson(String str) => ProductDetailsMode.fromJson(json.decode(str));

String productDetailsModeToJson(ProductDetailsMode data) => json.encode(data.toJson());

class ProductDetailsMode {
  ProductDetailsMode({
    this.productId,
    this.name,
    this.brandId,
    this.brandName,
    this.shortDesc,
    this.longDesc,
    this.image,
    this.productIn,
    this.regularPrice,
    this.discountPrice,
    this.imageUrl,
    this.regularImages,
    this.avgRating,
    this.quantity,
    this.reviewCount,
    this.categoryId,
    this.category,
    this.appPrice,
    this.isBestSeller,
    this.isFav,
    this.isNew,
    this.isBack,
    this.shareLink,
    this.cartRuleTitle,
    this.cartRuleDescription,
  });

  int? productId;
  String? name;
  int? brandId;
  String? brandName;
  String? shortDesc;
  String? longDesc;
  String? image;
  int? productIn;
  int? regularPrice;
  int? discountPrice;
  String? imageUrl;
  List<String>? regularImages;
  dynamic avgRating;
  int? quantity;
  int? reviewCount;
  int? categoryId;
  int? appPrice;
  int? isBestSeller;
  int? isFav;
  int? isNew;
  int? isBack;
  String? category;
  String? shareLink;
  String? cartRuleDescription;
  dynamic cartRuleTitle;

  factory ProductDetailsMode.fromJson(Map<String, dynamic> json) => ProductDetailsMode(
    productId: json["product_id"],
    name: json["name"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    shortDesc: json["short_desc"],
    longDesc: json["long_desc"],
    image: json["image"],
    productIn: json["product_in"],
    regularPrice: json["regular_price"],
    discountPrice: json["discount_price"],
    imageUrl: json["image_url"],
    regularImages: List<String>.from(json["regular_images"].map((x) => x)),
    avgRating: json["avg_rating"],
    quantity: json["quantity"],
    appPrice: json["app_price"],
    reviewCount: json["review_count"],
    categoryId: json["category_id"],
    category: json["category"],
    isBestSeller: json["is_bestseller"],
    isFav: json["is_fav"],
    isNew: json["is_new"],
    isBack: json["is_back"],
    shareLink: json["share_link"],
    cartRuleDescription: json["cart_rule_description"],
    cartRuleTitle: json["cart_rule_title"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "brand_id": brandId,
    "brand_name": brandName,
    "short_desc": shortDesc,
    "long_desc": longDesc,
    "image": image,
    "product_in": productIn,
    "regular_price": regularPrice,
    "discount_price": discountPrice,
    "image_url": imageUrl,
    "regular_images": List<dynamic>.from(regularImages!.map((x) => x)),
    "avg_rating": avgRating,
    "quantity": quantity,
    "review_count": reviewCount,
    "category_id": categoryId,
    "category": category,
    "app_price": appPrice,
    "is_bestseller": isBestSeller,
    "is_fav": isFav,
    "is_new": isNew,
    "is_back": isBack,
    "share_link": shareLink,
    "cart_rule_description": cartRuleDescription,
    "cart_rule_title": cartRuleTitle,
  };
}

 */
// To parse this JSON data, do
//
//     final productDetailsMode = productDetailsModeFromJson(jsonString);

import 'dart:convert';

ProductDetailsMode productDetailsModeFromJson(String str) => ProductDetailsMode.fromJson(json.decode(str));

String productDetailsModeToJson(ProductDetailsMode data) => json.encode(data.toJson());

class ProductDetailsMode {
  int? productId;
  String? name;
  int? brandId;
  String? brandName;
  String? shortDesc;
  String? longDesc;
  String? image;
  int? productIn;
  int? regularPrice;
  int? discountPrice;
  String? imageUrl;
  List<String>? regularImages;
  dynamic avgRating;
  int? quantity;
  int? reviewCount;
  int? categoryId;
  int? appPrice;
  int? isBestSeller;
  int? isFav;
  int? isNew;
  int? isBack;
  String? category;
  String? shareLink;
  String? cartRuleDescription;
  dynamic cartRuleTitle;
  final List<Product>? suggestingProducts;
  final List<Product>? alternativeProducts;

  ProductDetailsMode({
    this.productId,
    this.name,
    this.brandId,
    this.brandName,
    this.shortDesc,
    this.longDesc,
    this.image,
    this.productIn,
    this.regularPrice,
    this.discountPrice,
    this.imageUrl,
    this.regularImages,
    this.avgRating,
    this.quantity,
    this.reviewCount,
    this.categoryId,
    this.category,
    this.appPrice,
    this.isBestSeller,
    this.isFav,
    this.isNew,
    this.isBack,
    this.shareLink,
    this.cartRuleTitle,
    this.cartRuleDescription,
    this.suggestingProducts,
    this.alternativeProducts,
  });

  factory ProductDetailsMode.fromJson(Map<String, dynamic> json) => ProductDetailsMode(
    productId: json["product_id"],
    name: json["name"],
    brandId: json["brand_id"],
    brandName: json["brand_name"],
    shortDesc: json["short_desc"],
    longDesc: json["long_desc"],
    image: json["image"],
    productIn: json["product_in"],
    regularPrice: json["regular_price"],
    discountPrice: json["discount_price"],
    imageUrl: json["image_url"],
    regularImages: json["regular_images"] == null ? [] : List<String>.from(json["regular_images"]!.map((x) => x)),
    avgRating: json["avg_rating"],
    quantity: json["quantity"],
    reviewCount: json["review_count"],
    categoryId: json["category_id"],
    category: json["category"],
    appPrice: json["app_price"],
    isBestSeller: json["is_bestseller"],
    isFav: json["is_fav"],
    isNew: json["is_new"],
    isBack: json["is_back"],
    shareLink: json["share_link"],
    cartRuleTitle: json["cart_rule_title"],
    cartRuleDescription: json["cart_rule_description"],
    suggestingProducts: json["suggesting_products"] == null ? [] : List<Product>.from(json["suggesting_products"]!.map((x) => Product.fromJson(x))),
    alternativeProducts: json["alternative_products"] == null ? [] : List<Product>.from(json["alternative_products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "brand_id": brandId,
    "brand_name": brandName,
    "short_desc": shortDesc,
    "long_desc": longDesc,
    "image": image,
    "product_in": productIn,
    "regular_price": regularPrice,
    "discount_price": discountPrice,
    "image_url": imageUrl,
    "regular_images": regularImages == null ? [] : List<dynamic>.from(regularImages!.map((x) => x)),
    "avg_rating": avgRating,
    "quantity": quantity,
    "review_count": reviewCount,
    "category_id": categoryId,
    "category": category,
    "app_price": appPrice,
    "is_bestseller": isBestSeller,
    "is_fav": isFav,
    "is_new": isNew,
    "is_back": isBack,
    "share_link": shareLink,
    "cart_rule_title": cartRuleTitle,
    "cart_rule_description": cartRuleDescription,
    "suggesting_products": suggestingProducts == null ? [] : List<dynamic>.from(suggestingProducts!.map((x) => x.toJson())),
    "alternative_products": alternativeProducts == null ? [] : List<dynamic>.from(alternativeProducts!.map((x) => x.toJson())),
  };
}

class Product {
  final int? productId;
  final String? slug;
  final String? name;
  final int? brandId;
  final String? brandName;
  final String? image;
  final int? productIn;
  final int? regularPrice;
  final int? discountPrice;
  final int? appPrice;
  final int? isBestseller;
  final int? isFav;
  final int? isNew;
  final int? isBack;
  final String? productFrom;
  final int? groupId;
  final int? reviewCount;
  final int? reviewRate;
  final String? cartRuleTitle;

  Product({
    this.productId,
    this.slug,
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
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    slug: json["slug"],
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
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "slug": slug,
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
  };
}
