import 'package:get/get.dart';


import '../constraints/app_strings.dart';
import '../models/offer_list_model.dart';
import '../services/remote_services.dart';

class OfferListController extends GetxController
{
  List <OfferListMode>? offerList;
 // var sliderImages=<SliderImagesModel>[].obs;
  var images=[].obs;
  var isLoading=true.obs;
//  var url="https://dev.themallbd.com/api/slider_image";
  final endPoint=AppStrings.offerDataEndPoint;
      //"https://dev.themallbd.com/api/offer_list";
  //var url="slider_image";
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }
  void fetchData() async{
    var data=await RemoteServices.fetchOfferData(endPoint);
    if(data!=null){
      offerList=data;
      for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}