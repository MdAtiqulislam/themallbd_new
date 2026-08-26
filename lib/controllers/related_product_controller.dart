

import 'package:get/get.dart';

import '../models/home_page_models/home_page_product_model.dart';
import '../services/remote_services.dart';

class RelatedProductController extends GetxController
{
  var productList=<ProductsModel>[].obs;
 // var sliderImages=<SliderImagesModel>[].obs;
 // var images=[].obs;
  var isLoading=true.obs;
  //var endPoint="related-products/";
  var endPoint="related-products-v2/";
  var key="".obs;


  void fetchData({String? endPointForProId}) async{
    //isLoading.value=true;
    try {
      var data=await RemoteServices.fetchRelatedProductData(endPoint: "${endPointForProId??endPoint}${key.value}");
      if(data!=null){
        productList.value=data;
        isLoading.value=false;
      }
    } finally {
       isLoading.value=false;
    }
  }
}