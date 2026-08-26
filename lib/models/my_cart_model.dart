// To parse this JSON data, do
//
//     final myCartModel = myCartModelFromJson(jsonString);

import 'dart:convert';

MyCartModel myCartModelFromJson(String str) => MyCartModel.fromJson(json.decode(str));

String myCartModelToJson(MyCartModel data) => json.encode(data.toJson());

class MyCartModel {
  MyCartModel({
    this.cart,
    this.couponData,
    this.cartRules,
    this.selectedCartRules,
    this.partialPaymentStatus,
    this.partialPaymentAmount,
  });

  List<Cart>? cart;
  CouponData? couponData;
  List<CartRule>? cartRules;
  List<CartRule>? selectedCartRules;
  int ? partialPaymentStatus;
  int ? partialPaymentAmount;

  factory MyCartModel.fromJson(Map<String, dynamic> json) => MyCartModel(
    cart: json["cart"] == null ? [] : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
    couponData: json["coupon_data"] == null ? null : CouponData.fromJson(json["coupon_data"]),
    cartRules: json["cart_rules"] == null ? [] : List<CartRule>.from(json["cart_rules"]!.map((x) => CartRule.fromJson(x))),
    selectedCartRules: json["selected_cart_rules"] == null ? [] : List<CartRule>.from(json["selected_cart_rules"]!.map((x) => CartRule.fromJson(x))),
    partialPaymentStatus: json["partial_payment_status"],
    partialPaymentAmount: json["partial_payment_amount"],
  );

  Map<String, dynamic> toJson() => {
    "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x.toJson())),
    "coupon_data": couponData?.toJson(),
    "cart_rules": cartRules == null ? [] : List<dynamic>.from(cartRules!.map((x) => x.toJson())),
    "selected_cart_rules": selectedCartRules == null ? [] : List<dynamic>.from(selectedCartRules!.map((x) => x.toJson())),
    "partial_payment_status": partialPaymentStatus,
    "partial_payment_amount": partialPaymentAmount,
  };
}

class Cart {
  Cart({
    this.cartId,
    this.productId,
    this.name,
    this.quantity,
    this.colour,
    this.size,
    this.url,
    this.image,
    this.oldPriceStatus,
    this.price,
    this.pPrice,
    this.appPrice,
    this.available,
    this.status,
    this.cartRuleTitle,
  });

  int? cartId;
  int? productId;
  String? name;
  int? quantity;
  dynamic colour;
  dynamic size;
  String? url;
  String? image;
  dynamic oldPriceStatus;
  dynamic price;
  dynamic pPrice;
  dynamic appPrice;
  int? available;
  int? status;
  String? cartRuleTitle;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    cartId: json["cart_id"],
    productId: json["product_id"],
    name: json["name"],
    quantity: json["quantity"],
    colour: json["colour"],
    size: json["size"],
    url: json["url"],
    image: json["image"],
    oldPriceStatus: json["old_price_status"],
    price: json["price"],
    pPrice: json["p_price"],
    appPrice: json["app_price"],
    available: json["available"],
    status: json["status"],
    cartRuleTitle: json["cart_rule_title"],
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "product_id": productId,
    "name": name,
    "quantity": quantity,
    "colour": colour,
    "size": size,
    "url": url,
    "image": image,
    "old_price_status": oldPriceStatus,
    "price": price,
    "p_price": pPrice,
    "app_price": appPrice,
    "available": available,
    "status": status,
    "cart_rule_title": cartRuleTitle,
  };
}

class CartRule {
  CartRule({
    this.id,
    this.title,
    this.code,
    this.module,
    this.moduleId,
    this.targetModule,
    this.productId,
    this.quantity,
    this.priceTaxInc,
    this.salesPrice,
    this.afterDiscountPrice,
    this.image,
    this.url,
    this.name,
  });

  int? id;
  String? title;
  String? code;
  String? module;
  int? moduleId;
  String? targetModule;
  int? productId;
  int? quantity;
  int? priceTaxInc;
  dynamic salesPrice;
  dynamic afterDiscountPrice;
  String? image;
  String? url;
  String? name;

  factory CartRule.fromJson(Map<String, dynamic> json) => CartRule(
    id: json["id"],
    title: json["title"],
    code: json["code"],
    module: json["module"],
    moduleId: json["module_id"],
    targetModule: json["target_module"],
    productId: json["product_id"],
    quantity: json["quantity"],
    priceTaxInc: json["price_tax_inc"],
    salesPrice: json["sales_price"],
    afterDiscountPrice: json["after_discount_price"],
    image: json["image"],
    url: json["url"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "code": code,
    "module": module,
    "module_id": moduleId,
    "target_module": targetModule,
    "product_id": productId,
    "quantity": quantity,
    "price_tax_inc": priceTaxInc,
    "sales_price": salesPrice,
    "after_discount_price": afterDiscountPrice,
    "image": image,
    "url": url,
    "name": name,
  };
}

class CouponData {
  CouponData({
    this.vip,
    this.loyal,
    this.image,
    this.name,
    this.url,
    this.colour,
    this.size,
    this.couponDiscount,
    this.subTotal,
    this.shipping,
    this.mobileAppSpecialDiscount,
    this.regularDiscount,
    this.couponTotal,
    this.total,
  });

  int? vip;
  int? loyal;
  String? image;
  String? name;
  String? url;
  String? colour;
  String? size;
  dynamic couponDiscount;
  dynamic subTotal;
  dynamic shipping;
  dynamic mobileAppSpecialDiscount;
  dynamic regularDiscount;
  dynamic couponTotal;
  dynamic total;

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
    vip: json["vip"],
    loyal: json["loyal"],
    image: json["image"],
    name: json["name"],
    url: json["url"],
    colour: json["colour"],
    size: json["size"],
    couponDiscount: json["coupon_discount"],
    subTotal: json["sub_total"],
    shipping: json["shipping"],
    mobileAppSpecialDiscount: json["mobile_app_special_discount"]?.toDouble(),
    regularDiscount: json["regular_discount"],
    couponTotal: json["coupon_total"]?.toDouble(),
    total: json["total"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "vip": vip,
    "loyal": loyal,
    "image": image,
    "name": name,
    "url": url,
    "colour": colour,
    "size": size,
    "coupon_discount": couponDiscount,
    "sub_total": subTotal,
    "shipping": shipping,
    "mobile_app_special_discount": mobileAppSpecialDiscount,
    "regular_discount": regularDiscount,
    "coupon_total": couponTotal,
    "total": total,
  };
}
