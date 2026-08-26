// To parse this JSON data, do
//
//     final privilegesDetailsModel = privilegesDetailsModelFromJson(jsonString);

import 'dart:convert';

PrivilegesDetailsModel privilegesDetailsModelFromJson(String str) => PrivilegesDetailsModel.fromJson(json.decode(str));

String privilegesDetailsModelToJson(PrivilegesDetailsModel data) => json.encode(data.toJson());

class PrivilegesDetailsModel {
  PrivilegesDetailsModel({
    this.logo,
    this.name,
    this.categoryName,
    this.address,
    this.offerForVipCustomer,
    this.typeOneOffers,
    this.typeTwoOffers,
    this.galleries,
    this.timing,
    this.specialties,
    this.mobile,
    this.facebook,
    this.locations,
    this.childs,
  });

  String? logo;
  String? name;
  String? categoryName;
  String? address;
  OfferForVipCustomerModel? offerForVipCustomer;
  List<dynamic>? typeOneOffers;
  List<dynamic>? typeTwoOffers;
  List<String>? galleries;
  dynamic timing;
  String? specialties;
  String? mobile;
  String? facebook;
  List<String>? locations;
  List<PrivilegeetailsChildModel>? childs;

  factory PrivilegesDetailsModel.fromJson(Map<String, dynamic> json) => PrivilegesDetailsModel(
    logo: json["logo"],
    name: json["name"],
    categoryName: json["category_name"],
    address: json["address"],
    offerForVipCustomer: OfferForVipCustomerModel.fromJson(json["offer_for_vip_customer"]),
    typeOneOffers: List<dynamic>.from(json["type_one_offers"].map((x) => x)),
    typeTwoOffers: List<dynamic>.from(json["type_two_offers"].map((x) => x)),
    galleries: List<String>.from(json["galleries"].map((x) => x)),
    timing: json["timing"],
    specialties: json["specialties"],
    mobile: json["mobile"],
    facebook: json["facebook"],
    locations: List<String>.from(json["locations"].map((x) => x)),
    childs: List<PrivilegeetailsChildModel>.from(json["childs"].map((x) => PrivilegeetailsChildModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "logo": logo,
    "name": name,
    "category_name": categoryName,
    "address": address,
    "offer_for_vip_customer": offerForVipCustomer!.toJson(),
    "type_one_offers": List<dynamic>.from(typeOneOffers!.map((x) => x)),
    "type_two_offers": List<dynamic>.from(typeTwoOffers!.map((x) => x)),
    "galleries": List<dynamic>.from(galleries!.map((x) => x)),
    "timing": timing,
    "specialties": specialties,
    "mobile": mobile,
    "facebook": facebook,
    "locations": List<dynamic>.from(locations!.map((x) => x)),
    "childs": List<dynamic>.from(childs!.map((x) => x.toJson())),
  };
}

class PrivilegeetailsChildModel {
  PrivilegeetailsChildModel({
    this.id,
    this.url,
    this.logo,
    this.name,
    this.categoryName,
    this.discountText,
  });

  int? id;
  String? url;
  String? logo;
  String? name;
  String? categoryName;
  String? discountText;

  factory PrivilegeetailsChildModel.fromJson(Map<String, dynamic> json) => PrivilegeetailsChildModel(
    id: json["id"],
    url: json["url"],
    logo: json["logo"],
    name: json["name"],
    categoryName: json["category_name"],
    discountText: json["discount_text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "logo": logo,
    "name": name,
    "category_name": categoryName,
    "discount_text": discountText,
  };
}

class OfferForVipCustomerModel {
  OfferForVipCustomerModel({
    this.discountText,
    this.bannerImage,
    this.validFor,
    this.validTill,
    this.discountDetails,
    this.discountTermsAndConditions,
  });

  String? discountText;
  String? bannerImage;
  String? validFor;
  String? validTill;
  String? discountDetails;
  String? discountTermsAndConditions;

  factory OfferForVipCustomerModel.fromJson(Map<String, dynamic> json) => OfferForVipCustomerModel(
    discountText: json["discount_text"],
    bannerImage: json["banner_image"],
    validFor: json["valid_for"],
    validTill: json["valid_till"],
    discountDetails: json["discount_details"],
    discountTermsAndConditions: json["discount_terms_and_conditions"],
  );

  Map<String, dynamic> toJson() => {
    "discount_text": discountText,
    "banner_image": bannerImage,
    "valid_for": validFor,
    "valid_till": validTill,
    "discount_details": discountDetails,
    "discount_terms_and_conditions": discountTermsAndConditions,
  };
}
