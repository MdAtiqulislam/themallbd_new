import 'dart:convert';

List<ReviewsModel> reviewsModelFromJson(String str) => List<ReviewsModel>.from(json.decode(str).map((x) => ReviewsModel.fromJson(x)));

String reviewsModelToJson(List<ReviewsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewsModel {
  ReviewsModel({
    this.id,
    this.userId,
    this.productId,
    this.title,
    this.review,
    this.rating,
    this.reply,
    this.replyBy,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.source,
    this.reviewBy,
  });

  int? id;
  int? userId;
  int? productId;
  String? title;
  String? review;
  int? rating;
  String? reply;
  int? replyBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
  int? source;
  ReviewBy? reviewBy;

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    title: json["title"],
    review: json["review"],
    rating: json["rating"],
    reply: json["reply"],
    replyBy: json["reply_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    status: json["status"],
    source: json["source"],
    reviewBy: ReviewBy.fromJson(json["review_by"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "title": title,
    "review": review,
    "rating": rating,
    "reply": reply,
    "reply_by": replyBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "source": source,
    "review_by": reviewBy?.toJson(),
  };
}

class ReviewBy {
  ReviewBy({
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.alterEmail,
    this.nickName,
    this.phone2,

  });
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? alterEmail;
  String? nickName;
  String? phone2;

  factory ReviewBy.fromJson(Map<String, dynamic> json) => ReviewBy(

    firstName: json["first_name"],
    lastName: json["last_name"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],

    address: json["address"],
    alterEmail: json["alter_email"],
    nickName: json["nick_name"],
    phone2: json["phone2"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "alter_email": alterEmail,
    "nick_name": nickName,
    "phone2": phone2,
  };
}
