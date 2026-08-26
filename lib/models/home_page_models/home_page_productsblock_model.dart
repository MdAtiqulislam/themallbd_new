

import 'home_page_product_model.dart';

class HomePageProductsBlockModel {
  String? banner;
  List<ProductsModel>? products;

  HomePageProductsBlockModel({this.banner, this.products});

  HomePageProductsBlockModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    if (json['products'] != null) {
      products = <ProductsModel>[];
      json['products'].forEach((v) {
        products!.add(ProductsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}