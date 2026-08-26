// To parse this JSON data, do
//
//     final userPrivilegesModel = userPrivilegesModelFromJson(jsonString);

import 'dart:convert';

UserPrivilegesModel userPrivilegesModelFromJson(String str) => UserPrivilegesModel.fromJson(json.decode(str));

String userPrivilegesModelToJson(UserPrivilegesModel data) => json.encode(data.toJson());

class UserPrivilegesModel {
  UserPrivilegesModel({
    this.vipPrivilege,
    this.loyaltyCard,
    this.images,
  });

  UserVipPrivilege? vipPrivilege;
  LoyaltyCard? loyaltyCard;
  PrivilegesImages? images;

  factory UserPrivilegesModel.fromJson(Map<String, dynamic> json) => UserPrivilegesModel(
    vipPrivilege: UserVipPrivilege.fromJson(json["vip_privilege"]),
    loyaltyCard: LoyaltyCard.fromJson(json["loyalty_card"]),
    images: json["images"] == null ? null : PrivilegesImages.fromJson(json["images"]),
  );

  Map<String, dynamic> toJson() => {
    "vip_privilege": vipPrivilege!.toJson(),
    "loyalty_card": loyaltyCard!.toJson(),
    "images": images == null ? null : images!.toJson(),
  };
}

class LoyaltyCard {
  LoyaltyCard({
    this.rulesAndRegulations,
  });

  List<String>? rulesAndRegulations;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) => LoyaltyCard(
    rulesAndRegulations: List<String>.from(json["rules_and_regulations"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rules_and_regulations": List<dynamic>.from(rulesAndRegulations!.map((x) => x)),
  };
}

class PrivilegesImages {
  PrivilegesImages({
    this.loyalty,
    this.loyaltyText,
    this.vip,
  });

  LoyaltyImages? loyalty;
  LoyaltyText? loyaltyText;
  VipImages? vip;

  factory PrivilegesImages.fromJson(Map<String, dynamic> json) => PrivilegesImages(
    loyalty: json["loyalty"] == null ? null : LoyaltyImages.fromJson(json["loyalty"]),
    loyaltyText: json["loyalty_text"] == null ? null : LoyaltyText.fromJson(json["loyalty_text"]),
    vip: json["vip"] == null ? null : VipImages.fromJson(json["vip"]),
  );

  Map<String, dynamic> toJson() => {
    "loyalty": loyalty == null ? null : loyalty!.toJson(),
    "loyalty_text": loyaltyText == null ? null : loyaltyText!.toJson(),
    "vip": vip == null ? null : vip!.toJson(),
  };
}
class LoyaltyImages {
  LoyaltyImages({
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
  });

  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;

  factory LoyaltyImages.fromJson(Map<String, dynamic> json) => LoyaltyImages(
    image1: json["image_1"] == null ? null : json["image_1"],
    image2: json["image_2"] == null ? null : json["image_2"],
    image3: json["image_3"] == null ? null : json["image_3"],
    image4: json["image_4"] == null ? null : json["image_4"],
    image5: json["image_5"] == null ? null : json["image_5"],
  );

  Map<String, dynamic> toJson() => {
    "image_1": image1 == null ? null : image1,
    "image_2": image2 == null ? null : image2,
    "image_3": image3 == null ? null : image3,
    "image_4": image4 == null ? null : image4,
    "image_5": image5 == null ? null : image5,
  };
}

class LoyaltyText {
  LoyaltyText({
    this.text1,
    this.text2,
    this.text3,
  });

  String? text1;
  String? text2;
  String? text3;

  factory LoyaltyText.fromJson(Map<String, dynamic> json) => LoyaltyText(
    text1: json["text_1"] == null ? null : json["text_1"],
    text2: json["text_2"] == null ? null : json["text_2"],
    text3: json["text_3"] == null ? null : json["text_3"],
  );

  Map<String, dynamic> toJson() => {
    "text_1": text1 == null ? null : text1,
    "text_2": text2 == null ? null : text2,
    "text_3": text3 == null ? null : text3,
  };
}

class VipImages {
  VipImages({
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.image6
  });

  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  String? image6;

  factory VipImages.fromJson(Map<String, dynamic> json) => VipImages(
    image1: json["image_1"] == null ? null : json["image_1"],
    image2: json["image_2"] == null ? null : json["image_2"],
    image3: json["image_3"] == null ? null : json["image_3"],
    image4: json["image_4"] == null ? null : json["image_4"],
    image5: json["image_5"] == null ? null : json["image_5"],
    image6: json["image_6"] == null ? null : json["image_6"],
  );

  Map<String, dynamic> toJson() => {
    "image_1": image1 == null ? null : image1,
    "image_2": image2 == null ? null : image2,
    "image_3": image3 == null ? null : image3,
    "image_4": image4 == null ? null : image4,
    "image_5": image5 == null ? null : image5,
    "image_6": image6 == null ? null : image6,
  };
}


class UserVipPrivilege {
  UserVipPrivilege({
    this.customerName,
    this.isVip,
    this.timeOfPurchase,
    this.privilegeType,
    this.vipDiscountPercentage,
    this.loyaltyDiscountPercentage,
    this.purchasePoint,
    this.instruction,
    this.rulesAndRegulations,
    this.memberBenefits,
  });

  String? customerName;
  int? isVip;
  dynamic timeOfPurchase;
  String? privilegeType;
  int? vipDiscountPercentage;
  int? loyaltyDiscountPercentage;
  int? purchasePoint;
  String? instruction;
  List<String>? rulesAndRegulations;
  List<MemberBenefit>? memberBenefits;

  factory UserVipPrivilege.fromJson(Map<String, dynamic> json) => UserVipPrivilege(
    customerName: json["customer_name"],
    isVip: json["is_vip"],
    timeOfPurchase: json["time_of_purchase"],
    privilegeType: json["privilege_type"],
    vipDiscountPercentage: json["vip_discount_percentage"],
    loyaltyDiscountPercentage: json["loyalty_discount_percentage"],
    purchasePoint: json["purchase_point"],
    instruction: json["instruction"],
    rulesAndRegulations: List<String>.from(json["rules_and_regulations"].map((x) => x)),
    memberBenefits: List<MemberBenefit>.from(json["member_benefits"].map((x) => MemberBenefit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "is_vip": isVip,
    "time_of_purchase": timeOfPurchase,
    "privilege_type": privilegeType,
    "vip_discount_percentage": vipDiscountPercentage,
    "loyalty_discount_percentage": loyaltyDiscountPercentage,
    "purchase_point": purchasePoint,
    "instruction": instruction,
    "rules_and_regulations": List<dynamic>.from(rulesAndRegulations!.map((x) => x)),
    "member_benefits": List<dynamic>.from(memberBenefits!.map((x) => x.toJson())),
  };
}

class MemberBenefit {
  MemberBenefit({
    this.name,
    this.icon,
    this.general,
    this.loyalty,
    this.vip,
  });

  String? name;
  String? icon;
  dynamic general;
  dynamic loyalty;
  dynamic vip;

  factory MemberBenefit.fromJson(Map<String, dynamic> json) => MemberBenefit(
    name: json["name"],
    icon: json["icon"],
    general: json["general"],
    loyalty: json["loyalty"],
    vip: json["vip"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "icon": icon,
    "general": general,
    "loyalty": loyalty,
    "vip": vip,
  };
}
