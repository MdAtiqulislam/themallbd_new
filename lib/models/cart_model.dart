// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  CartModel({
    this.product_id,
    this.product_quantity,
  });

  String? product_id;
  String? product_quantity;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    product_id: json["product_id"],
    product_quantity: json["product_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "product_quantity": product_quantity,
  };
}
