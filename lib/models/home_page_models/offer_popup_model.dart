class OfferPopupModel {
  final bool? appStatus;
  final String? imageUrl;
  final String? deepLink;

  OfferPopupModel({
     this.appStatus,
     this.imageUrl,
     this.deepLink,
  });

  factory OfferPopupModel.fromJson(Map<String, dynamic> json) {
    return OfferPopupModel(
      appStatus: json['app_status'] ?? false,
      imageUrl: json['image_url'] ?? '',
      deepLink: json['deep_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_status': appStatus,
      'image_url': imageUrl,
      'deep_link': deepLink,
    };
  }
}