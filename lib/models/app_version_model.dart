// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

AppVersionModel appVersionModelFromJson(String str) => AppVersionModel.fromJson(json.decode(str));

String appVersionModelToJson(AppVersionModel data) => json.encode(data.toJson());

class AppVersionModel {
  AppVersionModel({
    this.current,
    this.version,
    this.androidTestVersion,
    this.iosVersion,
    this.iosTestVersion,
    this.enable,
    this.majorMsg,
    this.minorMsg,
  });

  dynamic current;
  dynamic version;
  dynamic androidTestVersion;
  dynamic iosVersion;
  dynamic iosTestVersion;
  dynamic enable;
  Messages? majorMsg;
  Messages? minorMsg;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) => AppVersionModel(
    current: json["current"] ?? "",
    version: json["version"] ?? "",
    androidTestVersion: json["android_test_version"],
    iosVersion: json["ios_version"],
    iosTestVersion: json["ios_test_version"],
    enable: json["enable"] ?? "",
    majorMsg: json["majorMsg"] == null ? null : Messages.fromJson(json["majorMsg"]),
    minorMsg: json["minorMsg"] == null ? null : Messages.fromJson(json["minorMsg"]),
  );

  Map<String, dynamic> toJson() => {
    "current": current ?? "",
    "version": version ?? "",
    "android_test_version": androidTestVersion??"",
    "ios_version": iosVersion??"",
    "ios_test_version": iosTestVersion??"",
    "enable": enable ?? "",
    "majorMsg": majorMsg == null ? null : majorMsg!.toJson(),
    "minorMsg": minorMsg == null ? null : minorMsg!.toJson(),
  };
}

class Messages {
  Messages({
    this.title,
    this.msg,
    this.button,
    this.url,
  });

  String? title;
  String? msg;
  String? button;
  Url? url;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    title: json["title"] ?? "",
    msg: json["msg"] ?? "",
    button: json["button"] ?? "",
    url: json["url"] == null ? null : Url.fromJson(json["url"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title ?? "",
    "msg": msg ?? "",
    "button": button ?? "",
    "url": url == null ? null : url!.toJson(),
  };
}

class Url {
  Url({
    this.apk,
    this.ios,
  });

  String? apk;
  String? ios;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    apk: json["apk"] ?? "",
    ios: json["ios"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "apk": apk ?? "",
    "ios": ios ?? "",
  };
}
