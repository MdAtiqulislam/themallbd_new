import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../models/blog_models/get_blogs_model.dart';
import '../../services/remote_services.dart';

class GetBlogController extends GetxController{
  var endPoint=AppStrings.getBlogEndPoint.obs;
  var isLoading=true.obs;
  List<GetBlogsModel>? blogData;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async{
    var data=await RemoteServices.fetchGetBlogsData(endPoint.value);
    if(data!=null){
      blogData=data;
      // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}