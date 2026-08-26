import 'single_search_product_model.dart';

class SearchProductsModel {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  String? prevPageUrl;
  String? path;
  int? from;
  int? to;
  List<SingleSearchProductModel>? data;

  SearchProductsModel(
      {this.total,
        this.perPage,
        this.currentPage,
        this.lastPage,
        this.firstPageUrl,
        this.lastPageUrl,
        this.nextPageUrl,
        this.prevPageUrl,
        this.path,
        this.from,
        this.to,
        this.data});

  SearchProductsModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    firstPageUrl = json['first_page_url'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
    path = json['path'];
    from = json['from'];
    to = json['to'];
    if (json['data'] != null) {
      data = <SingleSearchProductModel>[];
      json['data'].forEach((v) {
        data!.add(new SingleSearchProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['first_page_url'] = this.firstPageUrl;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['prev_page_url'] = this.prevPageUrl;
    data['path'] = this.path;
    data['from'] = this.from;
    data['to'] = this.to;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


