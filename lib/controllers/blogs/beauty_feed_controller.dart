import 'package:get/get.dart';


import '../../constraints/app_strings.dart';
import '../../models/blog_models/blog_auto_scroo_slider_model.dart';
import '../../models/blog_models/blog_categories_model.dart';
import '../../models/blog_models/get_blogs_model.dart';
import '../../services/remote_services.dart';

class BeautyFeedController extends GetxController{
  var isLoadingBlogData=true.obs;
  var isLoadingBlogCategoryData=true.obs;
  var isLoadingBlogAutoScrollData=true.obs;
  var endPoint="".obs;
  var key="".obs;
  List<GetBlogsModel>? blogData;
  List<BlogAutoScrollSliderModel>? autoScrollSliderData;
  List<BlogCategoriesModel>? blogCategoriesData;

  @override
  void onInit() {
    fetchBlogData();
    fetchBlogCategoriesData();
    fetchAutoScrollSliderData();
    super.onInit();
  }

  void fetchBlogData() async{
    isLoadingBlogData.value=true;
    endPoint.value=AppStrings.getBlogEndPoint;
    try{
      var data =await RemoteServices.fetchGetBlogsData(endPoint.value);
      if(data!=null){
        blogData=data;
        isLoadingBlogData.value=false;
      }
    }finally{
      isLoadingBlogData.value=false;
    }
  }

  void fetchFilteredBlogData() async{
    isLoadingBlogData.value=true;
    endPoint.value=AppStrings.getFilterBlogEndPoint;
    try{
      var data =await RemoteServices.fetchGetBlogsData(endPoint.value+key.value);
      if(data!=null){
        blogData=data;
        isLoadingBlogData.value=false;
      }
    }finally{
      isLoadingBlogData.value=false;
    }
  }

  void fetchAutoScrollSliderData() async{
    isLoadingBlogAutoScrollData.value=true;
    endPoint.value=AppStrings.getBlogAutoScrollSliderEndPoint;
    try{
      var data=await RemoteServices.fetchBlogAutoScrollData(endPoint.value);
      if(data!=null){
        autoScrollSliderData=data;
        isLoadingBlogAutoScrollData.value=false;
      }
    }finally{
      isLoadingBlogAutoScrollData.value=false;
    }

  }

  void fetchBlogCategoriesData() async{
    isLoadingBlogCategoryData.value=true;
    endPoint.value=AppStrings.blogCategoriesEndPoint;
    try{
      var data= await RemoteServices.fetchBlogCategoriesData(endPoint.value);
      if(data!=null){
        blogCategoriesData=data;
        isLoadingBlogCategoryData.value=false;
      }
    }finally{
      isLoadingBlogCategoryData.value=false;
    }
  }

}