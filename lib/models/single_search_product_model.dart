class SingleSearchProductModel {
  int? id;
  String? productName;
  String? thumbnailImage;
  int? productIn;
  int? isBestseller;
  int? isFav;
  int? isNew;
  int? isBack;

  SingleSearchProductModel(
      {this.id,
        this.productName,
        this.thumbnailImage,
        this.productIn,
        this.isBestseller,
        this.isFav,
        this.isNew,
        this.isBack});

  SingleSearchProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    thumbnailImage = json['thumbnail_image'];
    productIn = json['product_in'];
    isBestseller = json['is_bestseller'];
    isFav = json['is_fav'];
    isNew = json['is_new'];
    isBack = json['is_back'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['thumbnail_image'] = thumbnailImage;
    data['product_in'] = productIn;
    data['is_bestseller'] = isBestseller;
    data['is_fav'] = isFav;
    data['is_new'] = isNew;
    data['is_back'] = isBack;
    return data;
  }
}