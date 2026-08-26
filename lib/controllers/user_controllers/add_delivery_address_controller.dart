import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/controllers/user_controllers/user_details_controller.dart';
import '../../constraints/app_strings.dart';
import '../../models/area_list_model.dart';
import '../../models/district_list_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';
import '../check_out_controller.dart';

class AddDeliveryAddressController extends GetxController{
  var isLoading=false.obs;
  var isLoadingDistrict=false.obs;
  var isLoadingArea=false.obs;
  var areaList = <AreaListModel>[].obs;
  var districtList = <DistrictListModel>[].obs;
  var valueChooseDistrict = DistrictListModel().obs;
  var valueChooseArea = AreaListModel().obs;

  final UserDetailsController userDetailsController=Get.put(UserDetailsController());
  final CheckOutController checkOutController=Get.put(CheckOutController());


  final firstNameController=TextEditingController();
  final lastNameController=TextEditingController();
  final phoneController=TextEditingController();
  final addressController=TextEditingController();


  @override
  void onInit() async{
    fetchAreaData();
    fetchDistrictData();
    super.onInit();
  }

  void addAddress() async{
    isLoading.value=true;
    final token=await LocalServices.getToken();
    const endPoint=AppStrings.addDeliveryAddressEndPoint;
    var body={
      "first_name":firstNameController.text,
      "last_name":lastNameController.text,
      "address":addressController.text,
      "phone":phoneController.text,
      "district":valueChooseDistrict.value.id==null?"":valueChooseDistrict.value.id.toString(),
      "area":valueChooseDistrict.value.id==1?(valueChooseArea.value.id==null?"":valueChooseArea.value.id.toString()):"",

    };
    var header={'Authorization': 'Bearer $token'};
    
    try{
      var response=await RemoteServices.postRequest(endPoint, body, header);
      if(response!=null){
        userDetailsController.fetchDeliveryAddress();
        checkOutController.fetchDeliveryAddress();
        Get.back();
        ShowSnackBar(msg: response["msg"],isSuccess: true).showSnackBar();
        isLoading.value=false;
      }
      else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
      
    }finally{
      isLoading.value=false;
    }

  }

  void fetchDistrictData() async {
    isLoadingDistrict.value = true;
    const String endPoint = AppStrings.districtListEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        districtList.value = districtListModelFromJson(response);
       /* if (userData.value.cityId != null) {
          valueChooseDistrict.value = districtList.value[districtList.value
              .indexWhere((element) => element.id == userData.value.cityId)];
        }*/

        isLoadingDistrict.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchAreaData() async {
    isLoadingArea.value = true;
    const String endPoint = AppStrings.areaListEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        areaList.value = areaListModelFromJson(response);
      /*  if (userData.value.areaId != null) {
          valueChooseArea.value = areaList.value[areaList.value
              .indexWhere((element) => element.id == userData.value.areaId)];
        }*/
        isLoadingArea.value = false;
      }
    } finally {
      isLoadingArea.value = false;
    }
  }

}