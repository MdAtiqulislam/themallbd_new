import 'package:get/get.dart';


import '../models/reviews_model.dart';
import '../services/remote_services.dart';

class ReviewsController extends GetxController
{
  List <ReviewsModel>? reviewList;
 // var sliderImages=<SliderImagesModel>[].obs;
 // var images=[].obs;
  var isLoading=true.obs;
  var endPoint="product-reviews/";
  var key="".obs;
  @override
  void onInit() {
    // TODO: implement onInit
   // fetchData();
    super.onInit();
  }
  void fetchData() async{
    var data=await RemoteServices.fetchReviewData(endPoint+key.value);
    if(data!=null){
      reviewList=data;
     // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}