

import 'home_page_image_model.dart';

class HomePageCategoryModel {
  int? id;
  String? type;
  String? name;
  String? slug;
  int? serial;
  int? frontendShow;
  HomePageImageModel? image;

  HomePageCategoryModel(
      {this.id,
        this.type,
        this.name,
        this.slug,
        this.serial,
        this.frontendShow,
        this.image});

  HomePageCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    slug = json['slug'];
    serial = json['serial'];
    frontendShow = json['frontend_show'];
    image = json['image'] != null ? new HomePageImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['serial'] = this.serial;
    data['frontend_show'] = this.frontendShow;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}
