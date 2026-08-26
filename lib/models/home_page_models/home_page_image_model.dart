class HomePageImageModel {
  String? url;
  String? thumbnail;
  String? cover;

  HomePageImageModel({this.url, this.thumbnail, this.cover});

  HomePageImageModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnail = json['thumbnail'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    data['thumbnail'] = thumbnail;
    data['cover'] = cover;
    return data;
  }
}