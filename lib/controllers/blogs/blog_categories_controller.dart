import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../models/blog_models/blog_categories_model.dart';
import '../../services/remote_services.dart';

class BlogCategoriesController extends GetxController{
  final String endPoint=AppStrings.blogCategoriesEndPoint;
  var isLoading=true.obs;
  List<BlogCategoriesModel>? blogCategoriesData;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async{
    var data=await RemoteServices.fetchBlogCategoriesData(endPoint);
    if(data!=null){
      blogCategoriesData=data;
      // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }
}