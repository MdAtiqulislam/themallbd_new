import 'package:get/get.dart';

import '../../constraints/app_strings.dart';
import '../../models/user_models/review_list_model.dart';
import '../../models/user_models/review_product_list_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';



class ReviewListController extends GetxController{
  var isLoading=true.obs;
  final endPoint=AppStrings.reviewListEndpoint;
  var reViewListModel=<ReviewListModel>[].obs;
  var reviewProductListModel=<ReviewProductListModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchReviewData();
    super.onInit();
  }

  void fetchReviewData() async{
     isLoading.value=true;
    final token=await LocalServices.getToken();
    try {
      var data = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (data != null) {
        reViewListModel.value = reviewListModelFromJson(data);
        fetchReviewProductList();
        //isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchReviewProductList() async{
    const endPoint=AppStrings.reviewProductListEndpoint;
    final token=await LocalServices.getToken();
    try {
      var data = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (data != null) {
        reviewProductListModel.value = reviewProductListModelFromJson(data);
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }
}