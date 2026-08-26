// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  UserDetailsModel({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.areaId,
    this.cityId,
    this.gender,
    this.dob,

    /*this.region,
    this.facebookId,
    this.oldFbId,
    this.facebookIdDeleted,
    this.googleId,
    this.appleId,
    this.provider,
    this.totalBuy,
    this.credit,
    this.totalBuy2,
    this.isVipCard,
    this.getVipCard,
    this.cardIssueDate,
    this.cardExpiryDate,
    this.timeOfPurchase,
    this.timeOfPurchase2,
    this.validity,
    this.endDate,
    this.cardNumber,
    this.providerId,
    this.pin,
    this.pinExpireTime,
    this.alterEmail,
    this.nickName,
    this.phone2,
    this.zipCode,
    this.countryId,
    this.mobileNoOutside,
    this.callingCode,
    this.company,
    this.vatNumber,
    this.image,
    this.type,
    this.status,
    this.birthStatus,
    this.emailVerifiedAt,
    this.lastPurchaseDate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.purchasePoints,
    this.customerQuality,
    this.customerNote,

    this.suspiciousCount,*/
    this.prepayEnabled,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;
  String? address;
  dynamic areaId;
  dynamic cityId;
  dynamic region;
  dynamic gender;
  dynamic dob;
 /* dynamic facebookId;
  dynamic oldFbId;
  dynamic facebookIdDeleted;
  dynamic googleId;
  dynamic appleId;
  dynamic provider;
  dynamic totalBuy;
  dynamic credit;
  dynamic totalBuy2;
  int? isVipCard;
  int? getVipCard;
  dynamic cardIssueDate;
  DateTime? cardExpiryDate;
  dynamic timeOfPurchase;
 int? timeOfPurchase2;
  dynamic validity;
  dynamic endDate;
  dynamic cardNumber;
  dynamic providerId;

 int? pin;
 DateTime? pinExpireTime;

  dynamic alterEmail;
 dynamic nickName;
 String? phone2;
 dynamic zipCode;


  dynamic countryId;
  dynamic mobileNoOutside;
 int? callingCode;

 dynamic company;

 dynamic vatNumber;
 dynamic image;
 dynamic type;
 int? status;
 int? birthStatus;
 dynamic emailVerifiedAt;
 DateTime? lastPurchaseDate;
 dynamic createdBy;
 int? updatedBy;
 DateTime? createdAt;
 DateTime? updatedAt;
 int? purchasePoints;
 int? customerQuality;
 String? customerNote;

 int? suspiciousCount;*/
  dynamic prepayEnabled;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    areaId: json["area_id"],
    cityId: json["city_id"],
    gender: json["gender"],
    dob: json["dob"],

    /*facebookId: json["facebook_id"],
    oldFbId: json["old_fb_id"],
    facebookIdDeleted: json["facebook_id_deleted"],
    googleId: json["google_id"],
    appleId: json["apple_id"],
    provider: json["provider"],
    totalBuy: json["total_buy"],
    credit: json["credit"],
    totalBuy2: json["total_buy2"],
    isVipCard: json["is_vip_card"],
    getVipCard: json["get_vip_card"],
    cardIssueDate: json["card_issue_date"],
    cardExpiryDate: DateTime.parse(json["card_expiry_date"]??DateTime(1990).toString()),
    timeOfPurchase: json["time_of_purchase"],
    timeOfPurchase2: json["time_of_purchase2"],
    validity: json["validity"],
    endDate: json["end_date"],
    cardNumber: json["card_number"],
    providerId: json["provider_id"],
    pin: json["pin"],
    pinExpireTime: DateTime.parse(json["pin_expire_time"]??DateTime(1999).toString()),
    alterEmail: json["alter_email"],
    nickName: json["nick_name"],
    phone2: json["phone2"],
    zipCode: json["zip_code"],
    countryId: json["country_id"],
    mobileNoOutside: json["mobile_no_outside"],
    callingCode: json["calling_code"],
    region: json["region"],
    company: json["company"],
    vatNumber: json["vat_number"],
    image: json["image"],
    type: json["type"],
    status: json["status"],
    birthStatus: json["birth_status"],
    emailVerifiedAt: json["email_verified_at"],
    lastPurchaseDate: DateTime.parse(json["last_purchase_date"]??DateTime(1999).toString()),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]??DateTime(1999).toString()),
    updatedAt: DateTime.parse(json["updated_at"]??DateTime(1999).toString()),
    purchasePoints: json["purchase_points"],
    customerQuality: json["customer_quality"],
    customerNote: json["customer_note"],

    suspiciousCount: json["suspicious_count"],*/
    prepayEnabled: json["prepay_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
    "email": email,
    "phone": phone,
    "city_id": cityId,
    "area_id": areaId,
    "dob": dob,
    "address": address,
    "region": region,
    "gender": gender,

    /*"facebook_id": facebookId,
    "old_fb_id": oldFbId,
    "facebook_id_deleted": facebookIdDeleted,
    "google_id": googleId,
    "apple_id": appleId,
    "provider": provider,
    "total_buy": totalBuy,
    "credit": credit,
    "total_buy2": totalBuy2,
    "is_vip_card": isVipCard,
    "get_vip_card": getVipCard,
    "card_issue_date": cardIssueDate,
    "card_expiry_date": "${cardExpiryDate!.year.toString().padLeft(4, '0')}-${cardExpiryDate!.month.toString().padLeft(2, '0')}-${cardExpiryDate!.day.toString().padLeft(2, '0')}",
    "time_of_purchase": timeOfPurchase,
    "time_of_purchase2": timeOfPurchase2,
    "validity": validity,
    "end_date": endDate,
    "card_number": cardNumber,
    "provider_id": providerId,
    "pin": pin,
    "pin_expire_time": pinExpireTime!.toIso8601String(),
    "alter_email": alterEmail,
    "nick_name": nickName,
    "phone2": phone2,
    "zip_code": zipCode,
    "country_id": countryId,
    "mobile_no_outside": mobileNoOutside,
    "calling_code": callingCode,
    "company": company,
    "vat_number": vatNumber,
    "image": image,
    "type": type,
    "status": status,
    "birth_status": birthStatus,
    "email_verified_at": emailVerifiedAt,
    "last_purchase_date": lastPurchaseDate!.toIso8601String(),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "purchase_points": purchasePoints,
    "customer_quality": customerQuality,
    "customer_note": customerNote,

    "suspicious_count": suspiciousCount,*/
    "prepay_enabled": prepayEnabled,
  };
}
