// To parse this JSON data, do
//
//     final areaListModel = areaListModelFromJson(jsonString);

import 'dart:convert';

List<AreaListModel> areaListModelFromJson(String str) => List<AreaListModel>.from(json.decode(str).map((x) => AreaListModel.fromJson(x)));

String areaListModelToJson(List<AreaListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AreaListModel {
  AreaListModel({
    this.id,
    this.name,
    this.zipCode,
    this.description,
    this.parentId,
    this.status,
    this.createdBy,
    this.updatedBy,
  });

  int? id;
  String? name;
  String? zipCode;
  String? description;
  int? parentId;
  int? status;
  int? createdBy;
  int? updatedBy;


  factory AreaListModel.fromJson(Map<String, dynamic> json) => AreaListModel(
    id: json["id"],
    name: json["name"],
    zipCode: json["zip_code"],
    description: json["description"],
    parentId: json["parent_id"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "zip_code": zipCode,
    "description": description,
    "parent_id": parentId,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
  };
}
