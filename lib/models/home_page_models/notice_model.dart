// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

NoticeModel noticeModelFromJson(String str) => NoticeModel.fromJson(json.decode(str));

String noticeModelToJson(NoticeModel data) => json.encode(data.toJson());

class NoticeModel {
  NoticeModel({
    this.title,
  });

  String? title;



  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
    title: json["title"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "title": title ?? "",
  };
}
