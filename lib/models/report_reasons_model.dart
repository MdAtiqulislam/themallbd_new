// To parse this JSON data, do
//
//     final reportReasonModel = reportReasonModelFromJson(jsonString);

import 'dart:convert';

List<ReportReasonModel> reportReasonModelFromJson(String str) => List<ReportReasonModel>.from(json.decode(str).map((x) => ReportReasonModel.fromJson(x)));

String reportReasonModelToJson(List<ReportReasonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportReasonModel {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final dynamic updatedAt;

  ReportReasonModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory ReportReasonModel.fromJson(Map<String, dynamic> json) => ReportReasonModel(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}
