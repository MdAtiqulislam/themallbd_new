

import 'home_page_image_model.dart';

class HomePageSkinTypesModel {
  String? name;
  String? type;
  HomePageImageModel? image;

  HomePageSkinTypesModel({this.name, this.type, this.image});

  HomePageSkinTypesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    image = json['image'] != null ? new HomePageImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}