import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constraints/app_strings.dart';
import '../models/blog_models/blog_auto_scroo_slider_model.dart';
import '../models/blog_models/blog_categories_model.dart';
import '../models/blog_models/blog_view_model.dart';
import '../models/blog_models/get_blogs_model.dart';
import '../models/brand_list_model.dart';
import '../models/categories_model.dart';
import '../models/home_page_models/home_page_data_model.dart';
import '../models/home_page_models/home_page_product_model.dart';
import '../models/offer_list_model.dart';
import '../models/product_details_model.dart';
import '../models/reviews_model.dart';
import '../models/search_category_products_model.dart';
import '../models/slider_images_model.dart';
import '../utils/show_snack_bar.dart';

class RemoteServices {
  static var clint = http.Client();
  //static var baseURL = "https://themallbd.com/api/v3/";
  //static var baseURL = "https://dev.themallbd.com/api/v3/";

  static var baseURL = "https://themallbd.com/api/v4/";
 // static var baseURL = "https://dev.themallbd.com/api/v4/";


  //static var bkashBaseURL="https://dev.themallbd.com/mobile-app-v3-bkash-popup/";
 // static var cardPaymentBaseURL="https://dev.themallbd.com/api/v3/process-ssl-payment/$orderId/$couponId";

  static var bkashBaseURL="https://themallbd.com/mobile-app-v4-bkash-popup/";
 //  static var bkashBaseURL="https://dev.themallbd.com/mobile-app-v4-bkash-popup/";
  //http post request
  static Future<dynamic> postRequest(String endPoint, Map<String, dynamic> body,
      Map<String, String> header) async {
    //var uri = Uri.parse(baseURL+endPoint);
    var uri = Uri.parse(baseURL + endPoint);
    var requestBody = body;
    var requestHeader = header;
    if (kDebugMode) {
      print(baseURL+endPoint);
      print(header);
    }
    if (kDebugMode) {
      print(body);
    }
    try {
      http.Response response = await http.post(
        uri,
        body: requestBody,
        headers: requestHeader,
      );
      if (kDebugMode) {
        print(response.body);
        print(response.statusCode);
      }
      var r = json.decode(response.body);
      if (response.statusCode == 200) {
        return r;
      }else if (response.statusCode == 401) {
        customLogOut();
        return null;
      } else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      }
      else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        AppStrings.httpResponseMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http post request for cardPayment
  static Future<dynamic> postRequestCardPayment(String enPoint) async {
    //var uri = Uri.parse(baseURL+endPoint);
    try {
      var uri = Uri.parse(baseURL+enPoint);
      if (kDebugMode) {
        print(baseURL+enPoint);
      }
      //print(body);
      http.Response response = await http.post(
        uri,
      );
      if (kDebugMode) {
        print("Response:   ${response.body}");
      }
      var r = json.decode(response.body);
      if (response.statusCode == 200) {
        return r;
      } else if (response.statusCode == 401) {
        customLogOut();
        return null;
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        AppStrings.httpResponseMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http get request
  static Future<dynamic> getRequest(
      String endPoint, Map<String, String> header)
  async {
    // var response=await clint.get(Uri.parse(baseURL+endPoint),headers:header);
    try {
      var response =
          await clint.get(Uri.parse(baseURL + endPoint), headers: header);
       if (kDebugMode) {
         print (header);
       }

      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      //print(response.body);
      if (response.statusCode == 200) {
        var r = response.body;
        return r;
      } else if (response.statusCode == 401) {
        customLogOut();
        return null;
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        String message = jsonDecode(response.body).toString().contains("msg")
            ? jsonDecode(response.body)["msg"]
            : "";
        AppStrings.httpResponseMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http get request with full Link
  static Future<dynamic> getRequestLoadMore(
      String url, Map<String, String> header) async {
    // var response=await clint.get(Uri.parse(baseURL+endPoint),headers:header);
    try {
      var response = await clint.get(Uri.parse(url), headers: header);
      // print (header);
       if (kDebugMode) {
         print(url);
       }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return r;
      }else if (response.statusCode == 401) {
        customLogOut();
        return null;
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      }  else {
        String message = jsonDecode(response.body).toString().contains("msg")
            ? jsonDecode(response.body)["msg"]
            : "";
        AppStrings.httpResponseMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

/*  //Order History Data
  static Future <List<OrderHistoryModel>?> fetchOrderHistoryData([ String? endPoint]) async{
    var response=await clint.get(Uri.parse(baseURL+endPoint!),headers: {'Authorization': 'Bearer xaa4iO71Sdup2S2jjiE2fLltEpurhisfmKPjMqdP9lzSTzHMDt9cq7WHXoOlm7A8'});
    if(response.statusCode==200){
      var r = response.body;
      // print(r);
      return orderHistoryModelFromJson(r);
    }else{
      return null;
    }
  }*/

//Search product
  static Future<SearchCategoryProductsModel?> fetchSearchData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(endPoint!));
      if (kDebugMode) {
        print(endPoint);
      }
      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        return SearchCategoryProductsModel.fromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Blog View
  static Future<BlogViewModel?> fetchBlogViewData([String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      //print(response.body);
      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        return BlogViewModel.fromJson(r);
      } else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      }else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  //Search Category product
  static Future<SearchCategoryProductsModel?> fetchSearchCategoryProductData(
      String endPoint) async {
    // var response=await clint.get(Uri.parse(baseURL+endPoint));
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        // print(r);
        return SearchCategoryProductsModel.fromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        // print(response.body);
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }




  static Future<SearchCategoryProductsModel?>
      fetchLoadMoreSearchCategoryProductData(String url) async {
    try {
      var response = await clint.get(Uri.parse(url));
       if (kDebugMode) {
         print(url);
       }
      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        // print(r);
        return SearchCategoryProductsModel.fromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        // print(response.body);
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Product Details
  static Future<ProductDetailsMode?> fetchProductDetailsData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
       if (kDebugMode) {
         print(baseURL+endPoint);
       }
      if (response.statusCode == 200) {
        //   print(response.body);
        var r = json.decode(response.body);
        return ProductDetailsMode.fromJson(r);
      } else if (response.statusCode == 429) {
        Get.back();
        Get.closeAllSnackbars();
        ShowSnackBar(
                msg: "Too many request! please try again later",
                isSuccess: false)
            .showSnackBar();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Categories
  static Future<List<CategoriesModel>?> fetchCategoryData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return categoriesFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Blog Auto Scroll Data
  static Future<List<BlogAutoScrollSliderModel>?> fetchBlogAutoScrollData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      //print(response.body);
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return blogAutoScrollSliderModelFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Blogs Data
  static Future<List<GetBlogsModel>?> fetchGetBlogsData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
       if (kDebugMode) {
         print(baseURL+endPoint);
       }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return getBlogsModelFromJson(r);
      } else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      }else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Blog Categories Data
  static Future<List<BlogCategoriesModel>?> fetchBlogCategoriesData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return blogCategoriesModelFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Slider Images
  static Future<List<SliderImagesModel>?> fetchSliderData(
      [String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(endPoint!));
      if (kDebugMode) {
        print(endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return sliderImagesModelFromJson(r);
      } else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      }else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Offer List
  static Future<List<OfferListMode>?> fetchOfferData([String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return offerListModeFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Brand List
  static Future<List<BrandListMode>?> fetchBrandData([String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return brandListModeFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Related Product List
  static Future<List<ProductsModel>?> fetchRelatedProductData({required String endPoint}) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }

      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return productsModelFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Review List
  static Future<List<ReviewsModel>?> fetchReviewData([String? endPoint]) async {
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }

      if (response.statusCode == 200) {
        var r = response.body;
        // print(r);
        return reviewsModelFromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  //Home Page Data
  static Future<HomePageDataModel?> fetchHomePageData(
      [String? endPoint]) async {
    //var response=await clint.get(Uri.parse(baseURL+endPoint!));
    try {
      var response = await clint.get(Uri.parse(baseURL + endPoint!));
      if (kDebugMode) {
        print(baseURL+endPoint);
      }
      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        return HomePageDataModel.fromJson(r);
      }else if (response.statusCode == 429) {
        Get.closeAllSnackbars();
        ShowSnackBar(
            msg: "Too many request! please try again later",
            isSuccess: false)
            .showSnackBar();
      } else {
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

   static void customLogOut() async {
    ShowSnackBar(
        msg: "Login Required!",
        isWarning: true,
        buttonText: "Go To Login".toUpperCase(),
    ).showSnackBar();
   // final UserInfoController userInfoController=Get.put(UserInfoController());
 //   userInfoController.logOut();
  }
}
