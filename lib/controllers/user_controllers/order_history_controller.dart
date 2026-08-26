import 'package:get/get.dart';

import '../../constraints/app_strings.dart';
import '../../models/user_models/order_history_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';

class OrderHistoryController extends GetxController{
  var isLoading=false.obs;
  var isLoadingMore=false.obs;
  var orderHistoryData=OrderHistoryModel().obs;
  var orderHistoryList=<SingleOrder>[].obs;
  var token ="".obs;


  @override
  void onInit() async{
    // TODO: implement onInit
    fetchOrderHistoryData();
    super.onInit();
  }

  void fetchOrderHistoryData() async {
    const endPoint = AppStrings.orderHistoryEndPoint;
    token.value = await LocalServices.getToken() ?? '';
    isLoading.value = true;
    try {
      var data = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer ${token.value}'});
      if (data != null) {
        orderHistoryData.value=orderHistoryModelFromJson(data);
        orderHistoryList.value =orderHistoryData.value.data!;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }


  void loadMore(String url) async {
    token.value = await LocalServices.getToken() ?? '';
    isLoadingMore.value = true;
    try {
      var data = await RemoteServices.getRequestLoadMore(url,{'Authorization': 'Bearer ${token.value}'});
      if (data != null) {
        orderHistoryData.value=orderHistoryModelFromJson(data);
        orderHistoryList.value +=orderHistoryData.value.data!;
        isLoadingMore.value = false;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}