// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) => OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) => json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
    this.from,
    this.to,
    this.data,
  });

  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  String? prevPageUrl;
  String? path;
  int? from;
  int? to;
  List<SingleOrder>? data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    total: json["total"] ?? 0,
    perPage: json["per_page"] ?? 0,
    currentPage: json["current_page"]??0,
    lastPage: json["last_page"] ?? 0,
    firstPageUrl: json["first_page_url"] ?? "",
    lastPageUrl: json["last_page_url"] ?? "",
    nextPageUrl: json["next_page_url"] ?? "",
    prevPageUrl: json["prev_page_url"]??"",
    path: json["path"] ?? "",
    from: json["from"] ?? 0,
    to: json["to"] ?? 0,
    data: json["data"] == null ? null : List<SingleOrder>.from(json["data"].map((x) => SingleOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total ?? 0,
    "per_page": perPage ?? 0,
    "current_page": currentPage ?? 0,
    "last_page": lastPage ?? 0,
    "first_page_url": firstPageUrl ?? "",
    "last_page_url": lastPageUrl ?? "",
    "next_page_url": nextPageUrl ?? "",
    "prev_page_url": prevPageUrl??"",
    "path": path ?? "",
    "from": from ?? 0,
    "to": to ?? 0,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleOrder {
  SingleOrder({
    this.id,
    this.invoiceId,
    this.date,
    this.grandTotal,
    this.status,
    this.statusColor,
    this.subTotal,
    this.discount,
    this.deliveryCharge,
    this.numberOfProducts,
  });

  int? id;
  String? invoiceId;
  DateTime? date;
  String? grandTotal;
  String? status;
  String? statusColor;
  String? subTotal;
  dynamic? discount;
  String? deliveryCharge;
  int? numberOfProducts;

  factory SingleOrder.fromJson(Map<String, dynamic> json) => SingleOrder(
    id: json["id"],
    invoiceId: json["invoice_id"],
    date: DateTime.parse(json["date"]),
    grandTotal: json["grand_total"],
    status: json["status"],
    statusColor: json["status_color"],
    subTotal: json["sub_total"],
    discount: json["discount"],
    deliveryCharge: json["delivery_charge"],
    numberOfProducts: json["number_of_products"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_id": invoiceId,
    "date": date!.toIso8601String(),
    "grand_total": grandTotal,
    "status": status,
    "status_color": statusColor,
    "sub_total": subTotal,
    "discount": discount,
    "delivery_charge": deliveryCharge,
    "number_of_products": numberOfProducts,
  };
}




/*

import 'dart:convert';

List<OrderHistoryModel> orderHistoryModelFromJson(String str) => List<OrderHistoryModel>.from(json.decode(str).map((x) => OrderHistoryModel.fromJson(x)));

String orderHistoryModelToJson(List<OrderHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderHistoryModel {
  OrderHistoryModel({
    this.id,
    this.invoiceId,
    this.date,
    this.grandTotal,
    this.status,
    this.statusColor,
    this.subTotal,
    this.discount,
    this.deliveryCharge,
    this.numberOfProducts,
  });

  int? id;
  String? invoiceId;
  DateTime? date;
  String? grandTotal;
  String? status;
  String? statusColor;
  String? subTotal;
  dynamic? discount;
  String? deliveryCharge;
  int? numberOfProducts;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    id: json["id"],
    invoiceId: json["invoice_id"],
    date: DateTime.parse(json["date"]),
    grandTotal: json["grand_total"],
    status: json["status"],
    statusColor: json["status_color"],
    subTotal: json["sub_total"],
    discount: json["discount"],
    deliveryCharge: json["delivery_charge"],
    numberOfProducts: json["number_of_products"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_id": invoiceId,
    "date": date!.toIso8601String(),
    "grand_total": grandTotal,
    "status": status,
    "status_color": statusColor,
    "sub_total": subTotal,
    "discount": discount,
    "delivery_charge": deliveryCharge,
    "number_of_products": numberOfProducts,
  };
}
*/
