// To parse this JSON data, do
//
//     final shippingMethodModel = shippingMethodModelFromJson(jsonString);

import 'dart:convert';

List<ShippingMethodModel> shippingMethodModelFromJson(String str) => List<ShippingMethodModel>.from(json.decode(str).map((x) => ShippingMethodModel.fromJson(x)));

String shippingMethodModelToJson(List<ShippingMethodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingMethodModel {
  ShippingMethodModel({
    this.id,
    this.name,
    this.amount,
    this.title,
  });

  int? id;
  String? name;
  int? amount;
  String? title;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) => ShippingMethodModel(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "title": title,
  };
}
