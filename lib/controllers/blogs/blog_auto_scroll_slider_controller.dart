import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../models/blog_models/blog_auto_scroo_slider_model.dart';
import '../../services/remote_services.dart';

class BlogAutoScrollSliderController extends GetxController{
  var isLoading=true.obs;
  var sliderData=<BlogAutoScrollSliderModel>[].obs ;
 // List<BlogAutoScrollSliderModel> sliderData=[].obs;
  final String endPoint=AppStrings.getBlogAutoScrollSliderEndPoint;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    var data=await RemoteServices.fetchBlogAutoScrollData(endPoint);
    if(data!=null){
      sliderData.value=data;
      // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}