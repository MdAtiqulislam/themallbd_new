// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);


// To parse this JSON data, do
//
//     final requestOtpResponseModel = requestOtpResponseModelFromJson(jsonString);

import 'dart:convert';

RequestOtpResponseModel requestOtpResponseModelFromJson(String str) => RequestOtpResponseModel.fromJson(json.decode(str));

String requestOtpResponseModelToJson(RequestOtpResponseModel data) => json.encode(data.toJson());

class RequestOtpResponseModel {
  RequestOtpResponseModel({
    this.msg,
    this.data,
  });

  String? msg;
  dynamic data;

  factory RequestOtpResponseModel.fromJson(Map<String, dynamic> json) => RequestOtpResponseModel(
    msg: json["msg"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": data,
  };
}



