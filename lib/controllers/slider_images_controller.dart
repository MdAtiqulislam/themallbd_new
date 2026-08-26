import 'package:get/get.dart';
import '../models/slider_images_model.dart';

import '../services/remote_services.dart';

class SliderImagesController extends GetxController
{
  List <SliderImagesModel>? sliderImages;
 // var sliderImages=<SliderImagesModel>[].obs;
  var images=[].obs;
  var isLoading=true.obs;
//  var url="https://dev.themallbd.com/api/slider_image";
  var url="https://themallbd.com/api/v2/slider-image";
  //var url="slider_image";
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }
  void fetchData() async{
    var data=await RemoteServices.fetchSliderData(url);
    if(data!=null){
      sliderImages=data;
      for (var element in sliderImages!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}