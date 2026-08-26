

import 'home_page_image_model.dart';

class HomePageBrandModel {
  List<ListElement>? list;
  List<Banners>? banners;

  HomePageBrandModel({this.list, this.banners});

  HomePageBrandModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListElement>[];
      json['list'].forEach((v) {
        list!.add(new ListElement.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListElement {
  String? name;
  String? slug;
  int? id;
  HomePageImageModel? image;

  ListElement({this.name, this.slug, this.id, this.image});

  ListElement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    id = json['id'];
    image = json['image'] != null ? new HomePageImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['id'] = this.id;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Banners {
  int? id;
  String? type;
  HomePageImageModel? image;

  Banners({this.id, this.type, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    image = json['image'] != null ? new HomePageImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}