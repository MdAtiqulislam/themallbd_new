// To parse this JSON data, do
//
//     final deliveryAddressModel = deliveryAddressModelFromJson(jsonString);

import 'dart:convert';

List<DeliveryAddressModel> deliveryAddressModelFromJson(String str) => List<DeliveryAddressModel>.from(json.decode(str).map((x) => DeliveryAddressModel.fromJson(x)));

String deliveryAddressModelToJson(List<DeliveryAddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryAddressModel {
  DeliveryAddressModel({
    this.id,
    this.firstName,
    this.customerId,
    this.lastName,
    this.phone,
    this.type,
    this.primaryAddress,
    this.address,
    this.country,
    this.district,
    this.area,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? firstName;
  int? customerId;
  String? lastName;
  String? phone;
  int? type;
  int? primaryAddress;
  String? address;
  String? country;
  int? district;
  int? area;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) => DeliveryAddressModel(
    id: json["id"],
    firstName: json["first_name"],
    customerId: json["customer_id"],
    lastName: json["last_name"],
    phone: json["phone"],
    type: json["type"],
    primaryAddress: json["primary_address"],
    address: json["address"],
    country: json["country"],
    district: json["district"],
    area: json["area"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "customer_id": customerId,
    "last_name": lastName,
    "phone": phone,
    "type": type,
    "primary_address": primaryAddress,
    "address": address,
    "country": country,
    "district": district,
    "area": area,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
