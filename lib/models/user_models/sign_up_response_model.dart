
import 'dart:convert';

import 'package:themallbd_new/models/user_models/user_model.dart';



SignUpResponseModel responseModelFromJson(String str) => SignUpResponseModel.fromJson(json.decode(str));

String responseModelToJson(SignUpResponseModel data) => json.encode(data.toJson());

class SignUpResponseModel {
  SignUpResponseModel({
    this.msg,
    this.data,
  });

  String? msg;
  ResponseData? data;

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) => SignUpResponseModel(
    msg: json["msg"],
    data: ResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": data!.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.token,
    this.user,
  });

  String? token;
  UserModel? user;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    token: json["token"],
    user: UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}


