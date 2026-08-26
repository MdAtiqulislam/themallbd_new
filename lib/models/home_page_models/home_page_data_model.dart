
import 'package:themallbd_new/models/home_page_models/offer_popup_model.dart';

import '../slider_images_model.dart';
import 'home_page_blog_model.dart';
import 'home_page_brand_model.dart';
import 'home_page_category_model.dart';
import 'home_page_offer_model.dart';
import 'home_page_productsblock_model.dart';
import 'home_page_skin_type_model.dart';

class HomePageDataModel {
  List<HomePageCategoryModel>? category;
  List<SliderImagesModel>? slider;
  List<HomePageSkinTypesModel>? skinTypes;
  HomePageBrandModel? brand;
  HomePageProductsBlockModel? newArrival;
  HomePageProductsBlockModel? bestSeller;
  HomePageProductsBlockModel? backInStock;
  HomePageProductsBlockModel? babyCare;
  HomePageProductsBlockModel? exclusiveSale;
  HomePageProductsBlockModel? featured;
  HomePageProductsBlockModel? lifestyle;
  List<HomePageBlogsModel>? blogs;
  List<HomePageOffersModel>? offers;
  OfferPopupModel ? offerPopup;

  HomePageDataModel(
      {this.category,
        this.slider,
        this.skinTypes,
        this.brand,
        this.newArrival,
        this.bestSeller,
        this.backInStock,
        this.babyCare,
        this.exclusiveSale,
        this.featured,
        this.lifestyle,
        this.blogs,
        this.offers,
      this.offerPopup});

  HomePageDataModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = <HomePageCategoryModel>[];
      json['category'].forEach((v) {
        category!.add(new HomePageCategoryModel.fromJson(v));
      });
    }

    if (json['slider'] != null) {
      slider = <SliderImagesModel>[];
      json['slider'].forEach((v) {
        slider!.add(new SliderImagesModel.fromJson(v));
      });
    }



    if (json['skin_types'] != null) {
      skinTypes = <HomePageSkinTypesModel>[];
      json['skin_types'].forEach((v) {
        skinTypes!.add(new HomePageSkinTypesModel.fromJson(v));
      });
    }
    brand = json['brand'] != null ? new HomePageBrandModel.fromJson(json['brand']) : null;
    newArrival = json['new_arrival'] != null
        ? new HomePageProductsBlockModel.fromJson(json['new_arrival'])
        : null;
    bestSeller = json['best_seller'] != null
        ? new HomePageProductsBlockModel.fromJson(json['best_seller'])
        : null;
    backInStock = json['back_in_stock'] != null
        ? new HomePageProductsBlockModel.fromJson(json['back_in_stock'])
        : null;
    babyCare = json['baby_care'] != null
        ? new HomePageProductsBlockModel.fromJson(json['baby_care'])
        : null;
    exclusiveSale = json['exclusive_sale'] != null
        ? new HomePageProductsBlockModel.fromJson(json['exclusive_sale'])
        : null;
    featured = json['featured'] != null
        ? new HomePageProductsBlockModel.fromJson(json['featured'])
        : null;
    lifestyle = json['lifestyle'] != null
        ? new HomePageProductsBlockModel.fromJson(json['lifestyle'])
        : null;
    if (json['blogs'] != null) {
      blogs = <HomePageBlogsModel>[];
      json['blogs'].forEach((v) {
        blogs!.add(new HomePageBlogsModel.fromJson(v));
      });
    }
    if (json['offers'] != null) {
      offers = <HomePageOffersModel>[];
      json['offers'].forEach((v) {
        offers!.add(new HomePageOffersModel.fromJson(v));
      });
    }

    if(json['offerPopup'] != null){
      offerPopup = OfferPopupModel.fromJson(json['offerPopup']);

    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }

    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }

    if (this.skinTypes != null) {
      data['skin_types'] = this.skinTypes!.map((v) => v.toJson()).toList();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.newArrival != null) {
      data['new_arrival'] = this.newArrival!.toJson();
    }
    if (this.bestSeller != null) {
      data['best_seller'] = this.bestSeller!.toJson();
    }
    if (this.backInStock != null) {
      data['back_in_stock'] = this.backInStock!.toJson();
    }
    if (this.babyCare != null) {
      data['baby_care'] = this.babyCare!.toJson();
    }
    if (this.exclusiveSale != null) {
      data['exclusive_sale'] = this.exclusiveSale!.toJson();
    }
    if (this.featured != null) {
      data['featured'] = this.featured!.toJson();
    }
    if (this.lifestyle != null) {
      data['lifestyle'] = this.lifestyle!.toJson();
    }
    if (this.blogs != null) {
      data['blogs'] = this.blogs!.map((v) => v.toJson()).toList();
    }
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
      if (this.offerPopup != null) {
        data['offerPopup'] = this.offerPopup!.toJson();
      }
    return data;
  }
}