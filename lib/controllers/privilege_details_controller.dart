import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../constraints/app_strings.dart';
import '../models/privilege_details_model.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';

class PrivilegeDetailsController extends GetxController{
  var isLoading=true.obs;
  var isReLoading=true.obs;
  var detailsData=PrivilegesDetailsModel().obs;
  var privilegeID="".obs;

  //late WebViewController wvController;

  @override
  void onInit() {
    // TODO: implement onInit
    //fetchData();
    super.onInit();
  }

  void fetchData() async{
  //  isLoading.value=true;
    isReLoading.value=true;
    var endPoint=AppStrings.privilegeDetailsEndpoint;
    var header={"":""};

    var data=await RemoteServices.getRequest(endPoint+privilegeID.value, header);

    try {
      if(data!=null){
        detailsData.value=privilegesDetailsModelFromJson(data);
        isLoading.value=false;
        isReLoading.value=false;
       // wvController.loadHtmlString('<html><meta name="viewport" content="width=device-width, initial-scale=1"><body>${detailsData.value.locations![0]}</body></html>').toString();
      }else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false);
      }
    } finally {
      // TODO
      isLoading.value=false;
    }
  }

  reLoadMap(WebViewController webViewController) {
    webViewController.reload();
  }
}