// To parse this JSON data, do
//
//     final offerListMode = offerListModeFromJson(jsonString);

import 'dart:convert';

List<OfferListMode> offerListModeFromJson(String str) => List<OfferListMode>.from(json.decode(str).map((x) => OfferListMode.fromJson(x)));

String offerListModeToJson(List<OfferListMode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferListMode {

  int? id;
  String? name;
  String? description;
  String? image;

  OfferListMode({
    this.id,
    this.name,
    this.description,
    this.image,
  });



  factory OfferListMode.fromJson(Map<String, dynamic> json) => OfferListMode(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
  };
}
