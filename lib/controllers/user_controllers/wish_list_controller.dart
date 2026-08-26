import 'dart:convert';

import 'package:get/get.dart';

import '../../constraints/app_strings.dart';
import '../../models/home_page_models/home_page_product_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';


class WishListController extends GetxController {
  var isLoading = true.obs;
  var token = "".obs;
  final endPoint = AppStrings.wishListEndpoint;
  //List<WishListModel>? wishListModel;
  List<ProductsModel>? wishListModel;

  @override
  void onInit() async {
    // TODO: implement onInit
    token.value = await LocalServices.getToken() ?? "";
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    // final token=await LocalServices.getToken();
    isLoading.value=true;
    try {
      var data = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (data != null) {
        wishListModel = productsModelFromJson(data);
        isLoading.value = false;

      }
    } finally {
      isLoading.value = false;
    }
  }

  void deleteFromWishList(proId) async {
    if (token.value.isNotEmpty) {
      const endPoint = AppStrings.deleteWishListEndpoint;
      var response = await RemoteServices.getRequest(
          endPoint + proId, {'Authorization': 'Bearer $token'});

      if (response != null) {
        // print(response);
        ShowSnackBar(msg: json.decode(response)["msg"],isSuccess: true)
            .showSnackBar();
           fetchData();
      }else{
        ShowSnackBar(msg:AppStrings.httpResponseMSG.value,isSuccess: false)
            .showSnackBar();
      }
    }
  }
}
