// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.id,
    this.invoiceId,
    this.date,
    this.source,
    this.zoneType,
    this.grandTotal,
    this.discount,
    this.specialDiscount,
    this.couponDiscount,
    this.shippingCost,
    this.netTotal,
    this.note,
    this.description,
    this.status,
    this.paymentStatus,
    this.paymentMedia,
    this.shippingMethod,
    this.shippingAddress,
    this.billingAddress,
    this.orderDetails,
    this.timeline,
    this.timelineStatus,
  });

  int? id;
  String? invoiceId;
  DateTime? date;
  int? source;
  int? zoneType;
  dynamic? grandTotal;
  dynamic? discount;
  dynamic specialDiscount;
  dynamic? couponDiscount;
  dynamic? shippingCost;
  dynamic? netTotal;
  String? note;
  String? description;
  int? status;
  int? paymentStatus;
  int? paymentMedia;
  int? shippingMethod;
  Address? shippingAddress;
  Address? billingAddress;
  List<OrderedProduct>? orderDetails;
  List<Timeline>? timeline;
  int? timelineStatus;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    id: json["id"],
    invoiceId: json["invoice_id"],
    date: DateTime.parse(json["date"]),
    source: json["source"],
    zoneType: json["zone_type"],
    grandTotal: json["grand_total"],
    discount: json["discount"],
    specialDiscount: json["special_discount"],
    couponDiscount: json["coupon_discount"],
    shippingCost: json["shipping_cost"],
    netTotal: json["net_total"],
    note: json["note"],
    description: json["description"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    paymentMedia: json["payment_media"],
    shippingMethod: json["shipping_method"],
    shippingAddress: Address.fromJson(json["shipping_address"]),
    billingAddress: Address.fromJson(json["billing_address"]),
    orderDetails: List<OrderedProduct>.from(json["order_details"].map((x) => OrderedProduct.fromJson(x))),
    timeline: List<Timeline>.from(json["timeline"].map((x) => Timeline.fromJson(x))),
    timelineStatus: json["timeline_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_id": invoiceId,
    "date": date!.toIso8601String(),
    "source": source,
    "zone_type": zoneType,
    "grand_total": grandTotal,
    "discount": discount,
    "special_discount": specialDiscount,
    "coupon_discount": couponDiscount,
    "shipping_cost": shippingCost,
    "net_total": netTotal,
    "note": note,
    "description": description,
    "status": status,
    "payment_status": paymentStatus,
    "payment_media": paymentMedia,
    "shipping_method": shippingMethod,
    "shipping_address": shippingAddress?.toJson(),
    "billing_address": billingAddress?.toJson(),
    "order_details": List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
    "timeline": List<dynamic>.from(timeline!.map((x) => x.toJson())),
    "timeline_status": timelineStatus,
  };
}

class Address {
  Address({
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.area,
  });

  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? area;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    area: json["area"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "email":email,
    "address": address,
    "city": city,
    "area": area,
  };
}

class OrderedProduct {
  OrderedProduct({
    this.id,
    this.productName,
    this.imageUrl,
    this.image,
    this.quantity,
    this.regularPrice,
    this.salesPrice,
  });

  int? id;
  String? productName;
  String? imageUrl;
  String? image;
  int? quantity;
  String? regularPrice;
  String? salesPrice;

  factory OrderedProduct.fromJson(Map<String, dynamic> json) => OrderedProduct(
    id: json["id"],
    productName: json["product_name"],
    imageUrl: json["image_url"],
    image: json["image"],
    quantity: json["quantity"],
    regularPrice: json["regular_price"],
    salesPrice: json["sales_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "image_url": imageUrl,
    "image": image,
    "quantity": quantity,
    "regular_price": regularPrice,
    "sales_price": salesPrice,
  };
}

class Timeline {
  Timeline({
    this.status,
    this.date,
    this.time,
    this.desc,
    this.colorCode,
    this.button,
  });

  String? status;
  String? date;
  String? time;
  String? desc;
  String? colorCode;
  TimeLineButton? button;

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
    status: json["status"],
    date: json["date"],
    time: json["time"],
    desc: json["desc"],
    colorCode: json["color_code"],
    button: TimeLineButton.fromJson(json["button"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "date": date,
    "time": time,
    "desc": desc,
    "color_code": colorCode,
    "button": button!.toJson(),
  };
}

class TimeLineButton {
  TimeLineButton({
    this.name,
    this.value,
  });

  String? name;
  dynamic? value;

  factory TimeLineButton.fromJson(Map<String, dynamic> json) => TimeLineButton(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}
