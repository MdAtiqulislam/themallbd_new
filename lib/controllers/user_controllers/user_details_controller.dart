import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:themallbd_new/controllers/user_controllers/user_info_controller.dart';

import '../../constraints/app_strings.dart';
import '../../models/area_list_model.dart';
import '../../models/district_list_model.dart';
import '../../models/user_models/delivery_address_model.dart';
import '../../models/user_models/user_details_model.dart';
import '../../models/user_models/user_model.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/show_snack_bar.dart';


class UserDetailsController extends GetxController {
  var isLoading = true.obs;
  var isLoadingArea = true.obs;
  var isUpdating = false.obs;
  var isLoadingDistrict = true.obs;
  var isLoadingAddress = false.obs;
  var userData = UserDetailsModel().obs;
  var user =UserModel().obs;
  var areaList = <AreaListModel>[].obs;
  var districtList = <DistrictListModel>[].obs;
  var addressList = <DeliveryAddressModel>[].obs;
  var valueChooseArea = AreaListModel().obs;
  var valueChooseDistrict = DistrictListModel().obs;
  var gender = "".obs;
  String? dob;

  var firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dateInputController = TextEditingController();




  @override
  void dispose() {

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchUserData();
    //fetchAreaData();
    //fetchDistrictData();
   // fetchDeliveryAddress();
    super.onInit();
  }

  void fetchUserData() async {
   // isLoading.value = true;
    const String endPoint = AppStrings.userInfoEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        userData.value = userDetailsModelFromJson(response);
        gender.value=userData.value.gender??"";
        dob=userData.value.dob;
        if(gender.value.isNotEmpty){
          gender.value.toUpperCase();
        }
        firstNameController.text=userData.value.firstName??"";
        lastNameController.text=userData.value.lastName??"";
        emailController.text=userData.value.email??"";
        phoneController.text=userData.value.phone??"";
        addressController.text=userData.value.address??"";
        dateInputController.text=userData.value.dob??"";
        isLoading.value = false;
        fetchDistrictData();

      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchDistrictData() async {
    //isLoadingDistrict.value = true;
    const String endPoint = AppStrings.districtListEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        districtList.value = districtListModelFromJson(response);


        if (userData.value.cityId != null && userData.value.cityId.toString().isNotEmpty) {
          valueChooseDistrict.value = districtList.value[districtList.value
              .indexWhere((element) => element.id == userData.value.cityId)];
        }

        isLoadingDistrict.value = false;
        fetchAreaData();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void fetchAreaData() async {
    //isLoadingArea.value = true;
    const String endPoint = AppStrings.areaListEndpoint;
    final token = await LocalServices.getToken();
    try {
      var response = await RemoteServices.getRequest(
          endPoint, {'Authorization': 'Bearer $token'});
      if (response != null) {
        areaList.value = areaListModelFromJson(response);
        if (userData.value.areaId != null) {
          valueChooseArea.value = areaList.value[areaList.value
              .indexWhere((element) => element.id == userData.value.areaId)];
        }
        isLoadingArea.value = false;
        fetchDeliveryAddress();
      }
    } finally {
      isLoadingArea.value = false;
    }
  }

  void fetchDeliveryAddress() async{
    //isLoadingArea.value=true;
    const String endPoint=AppStrings.deliveryAddressEndPoint;
    final String token=await LocalServices.getToken()??"";
    var header={'Authorization': 'Bearer $token'};

    try{
      var response=await RemoteServices.getRequest(endPoint, header);
      if(response!=null){
        addressList.value=deliveryAddressModelFromJson(response);
        isLoadingArea.value=false;
      }
    }finally{
      isLoadingArea.value=false;
    }

  }

  void pickDate() async{
    DateTime? pickedDate = await showDatePicker(
      helpText: "Select Date of Birth",
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      dob=pickedDate.toIso8601String();
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateInputController.text = formattedDate;
    } else {
      dob=userData.value.dob;
    }
  }

  void updateUserInfo()async{
    isUpdating.value=true;
    const endPoint=AppStrings.updateUserInfoEndpoint;
    final token = await LocalServices.getToken();
    var body={
      'first_name':firstNameController.text,
      'last_name':lastNameController.text,
      'email':emailController.text,
      'mobile_number':phoneController.text,
      'address':addressController.text,
      'city':valueChooseDistrict.value.id==null?"":valueChooseDistrict.value.id.toString(),
      'area':valueChooseArea.value.id==null?"":valueChooseArea.value.id.toString(),
      'gender':gender.value.toLowerCase(),
      'dob':dob??DateTime(1900),
    };
    var header={'Authorization': 'Bearer $token'};

    try{
      var data = await RemoteServices.postRequest(endPoint, body, header);
      if(data!=null){
        ShowSnackBar(msg: data["msg"],isSuccess: true).showSnackBar();

       // print(data);
        user.value.name="${firstNameController.text} ${lastNameController.text}" ;
        user.value.email=emailController.text;

        await LocalServices.storeUser(user.value);

        //UserInfoController userInfoController =Get.put(UserInfoController());
        UserInfoController.getUser();
        isUpdating.value=false;
      }
      else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    }finally{
      isUpdating.value=false;
    }


  }

  void updateDeliveryAddress(DeliveryAddressModel value) async{
    isUpdating.value=true;
    final String token=await LocalServices.getToken()??"";
    var header={'Authorization': 'Bearer $token'};
    var body={
      "first_name":value.firstName??"",
      "last_name":value.lastName??"",
      "address":value.address??"",
      "district":value.district==null?"":value.district.toString(),
      "area":value.area==null?"":value.area.toString(),
      "phone":value.phone,
    };
    const String endPoint=AppStrings.updateDeliveryAddressEndPoint;
    try{
      var response=await RemoteServices.postRequest(endPoint+value.id.toString(), body, header);
      if(response!=null){
        ShowSnackBar(msg: response["msg"],isSuccess: true).showSnackBar();
        isUpdating.value=false;
      }
      else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess:false).showSnackBar();
      }
    }finally{
      isUpdating.value=false;
    }

  }
}
