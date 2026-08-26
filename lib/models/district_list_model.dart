// To parse this JSON data, do
//
//     final districtListModel = districtListModelFromJson(jsonString);

import 'dart:convert';

List<DistrictListModel> districtListModelFromJson(String str) => List<DistrictListModel>.from(json.decode(str).map((x) => DistrictListModel.fromJson(x)));

String districtListModelToJson(List<DistrictListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistrictListModel {
  DistrictListModel({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory DistrictListModel.fromJson(Map<String, dynamic> json) => DistrictListModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
