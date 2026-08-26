
import 'dart:convert';

List<SliderImagesModel> sliderImagesModelFromJson(String str) => List<SliderImagesModel>.from(json.decode(str).map((x) => SliderImagesModel.fromJson(x)));

String sliderImagesModelToJson(List<SliderImagesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class SliderImagesModel {
  int? id;
  String? title;
  String? subTitle;
  dynamic type;
  dynamic url;
  String? appBackground;
  String? appForeground;
  dynamic learnMore;
  int? serial;
  String? appTextPosition;
  dynamic categoryId;
  String? image;
  String? moduleType;
  String? moduleName;
  int? moduleId;
  String? customUrl;

  SliderImagesModel(
      {this.id,
        this.title,
        this.subTitle,
        this.type,
        this.url,
        this.appBackground,
        this.appForeground,
        this.learnMore,
        this.serial,
        this.appTextPosition,
        this.categoryId,
        this.image,
        this.moduleType,
        moduleName,
        this.moduleId,
        this.customUrl

      });

  SliderImagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    type = json['type'];
    url = json['url'];
    appBackground = json['app_background'];
    appForeground = json['app_foreground'];
    learnMore = json['learn_more'];
    serial = json['serial'];
    appTextPosition = json['app_text_position'];
    categoryId = json['category_id'];
    image = json['image'];
    moduleType = json['module_type'];
    moduleName = json['module_name'];
    moduleId = json['module_id'];
    customUrl=json['custom_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['type'] = this.type;
    data['url'] = this.url;
    data['app_background'] = this.appBackground;
    data['app_foreground'] = this.appForeground;
    data['learn_more'] = this.learnMore;
    data['serial'] = this.serial;
    data['app_text_position'] = this.appTextPosition;
    data['category_id'] = this.categoryId;
    data['image'] = this.image;
    data['module_type'] = this.moduleType;
    data['module_name'] = this.moduleName;
    data['module_id'] = this.moduleId;
    data['custom_url'] = this.customUrl;
    return data;
  }
}