

import 'home_page_image_model.dart';

class HomePageOffersModel {
  int? rowId;
  int? id;
  String? type;
  String? title;
  String? description;
  HomePageImageModel? image;

  HomePageOffersModel(
      {this.rowId,
        this.id,
        this.type,
        this.title,
        this.description,
        this.image});

  HomePageOffersModel.fromJson(Map<String, dynamic> json) {
    rowId = json['row_id'];
    id = json['id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    image = json['image'] != null ? new HomePageImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_id'] = rowId;
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['description'] = description;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}