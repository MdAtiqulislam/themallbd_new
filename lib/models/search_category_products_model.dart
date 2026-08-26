
import 'home_page_models/home_page_product_model.dart';

class SearchCategoryProductsModel {
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
  List<ProductsModel>? data;

  SearchCategoryProductsModel(
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

  SearchCategoryProductsModel.fromJson(Map<String, dynamic> json) {
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
      data = <ProductsModel>[];
      json['data'].forEach((v) {
        data!.add(ProductsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['first_page_url'] = firstPageUrl;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    data['path'] = path;
    data['from'] = from;
    data['to'] = to;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
