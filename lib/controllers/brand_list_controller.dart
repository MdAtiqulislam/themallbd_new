import 'package:get/get.dart';


import '../constraints/app_strings.dart';
import '../models/brand_list_model.dart';
import '../services/remote_services.dart';

class BrandListController extends GetxController
{
  List <BrandListMode>? brandList;
 // var sliderImages=<SliderImagesModel>[].obs;
 // var images=[].obs;
  var isLoading=true.obs;
//  var url="https://dev.themallbd.com/api/slider_image";
  //var url="https://dev.themallbd.com/api/get_brand";
  var endPoint=AppStrings.brandListEndPoint;
      //"https://dev.themallbd.com/api/get_brand";
  //var url="slider_image";
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }
  void fetchData() async{
    var data=await RemoteServices.fetchBrandData(endPoint);
    if(data!=null){
      brandList=data;
     // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}