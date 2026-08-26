import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/controllers/user_controllers/review_list_controller.dart';


import '../../constraints/app_strings.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';


class AddReviewController extends GetxController{
  var proId="".obs;
  var isLoading=false.obs;
  var rating = 5.obs;

  final titleController = TextEditingController();
  final reviewController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    reviewController.dispose();
  }


  void addReview({String? page}) async {
    isLoading.value = true;
   final token = await LocalServices.getToken() ?? "";
    const endPoint = AppStrings.addReviewEndpoint;
    var header = {'Authorization': 'Bearer $token'};

    var body = {
      'product_id': proId.value.toString(),
      'title': titleController.text,
      'review': reviewController.text,
      'rating': rating.value.toString(),
    };

    try {
      var response = await RemoteServices.postRequest(endPoint, body, header);
      if (response != null) {
        //print(response);
        isLoading.value = false;
        titleController.text="";
        reviewController.text="";
        rating.value=5;
        if(page=="ReviewPage"){
          final ReviewListController reviewListController=Get.put(ReviewListController());
          reviewListController.fetchReviewData();
          Get.offAndToNamed("/user_reviews_page");
        }
        ShowSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }
}



