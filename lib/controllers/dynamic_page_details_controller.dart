import 'package:get/get.dart';
import '../constraints/app_strings.dart';
import '../models/dynamic_page_details_model.dart';
import '../models/dynamic_page_list_model.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';

class DynamicPageController extends GetxController{
  var isLoading=true.obs;
  var isLoadingDetails=true.obs;
  var detailsData=DynamicPageDetailModel().obs;
  var pageId="".obs;
  var dynamicPageList=<DynamicPageListModel>[].obs;


  @override
  void onInit() {
    fetchDynamicPageList();
    super.onInit();
  }

  void fetchData() async{
    isLoadingDetails.value=true;
    detailsData.value=DynamicPageDetailModel();
    var endPoint=AppStrings.dynamicPageDetailsEndPoint;
    var data=await RemoteServices.getRequest(endPoint+pageId.value, {"":""});
    try {
      if(data!=null){
        detailsData.value=dynamicPageDetailModelFromJson(data);
        //isLoadingDetails.value=true;
      }else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    } finally {
      // TODO
      isLoadingDetails.value=false;
    }

  }

  void fetchDynamicPageList() async{
    // isLoading.value=true;
    var endPoint=AppStrings.dynamicPageListEndPoint;
    var data=await RemoteServices.getRequest(endPoint, {"":""});
    try {
      if(data!=null){
        dynamicPageList.value=dynamicPageListModelFromJson(data);
         isLoading.value=false;
      }
      else{
        ShowSnackBar(msg:(AppStrings.httpResponseMSG.value).isEmpty?"Too Many Request!":AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    } finally {
       isLoading.value=false;
    }
  }
}