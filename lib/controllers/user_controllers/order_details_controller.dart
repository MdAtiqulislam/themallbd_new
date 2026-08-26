import 'package:get/get.dart';

import '../../constraints/app_strings.dart';
import '../../models/user_models/order_details_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';


class OrderDetailsController extends GetxController{

  var isLoading=false.obs;
  var isHorizontalTimeLine=true.obs;
  var orderDetails=OrderDetailsModel().obs;
  final endPoint=AppStrings.orderDetailsEndPoint;
  var orderId="".obs;


  void fetchData() async {
    final token=await LocalServices.getToken()??"";
    isLoading.value=true;
   var header={'Authorization': 'Bearer $token'};
   try{
     var response=await RemoteServices.getRequest(endPoint+orderId.value, header);
     orderDetails.value=orderDetailsModelFromJson(response);
   }finally{
     isLoading.value=false;
   }
  }
}