class HomePageBlogsModel {
  int? id;
  String? title;
  int? categoryId;
  String? categoryName;
  String? image;
  List<dynamic>? tags;
  String? author;

  HomePageBlogsModel(
      {this.id,
        this.title,
        this.categoryId,
        this.categoryName,
        this.image,
        this.tags,
        this.author});

  HomePageBlogsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
    if (json['tags'] != null) {
      tags =  List<dynamic>.from(json["tags"].map((x) => x));
    }
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['image'] = image;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['author'] = author;
    return data;
  }
}
