import 'package:get/get.dart';
import '../../constraints/app_strings.dart';
import '../../models/blog_models/blog_auto_scroo_slider_model.dart';
import '../../models/blog_models/blog_categories_model.dart';
import '../../models/blog_models/blog_pagination_model.dart';
import '../../models/blog_models/get_blogs_model.dart';
import '../../services/remote_services.dart';

class BeautyFeedPaginationController extends GetxController{
  var isLoadingBlogData=true.obs;
  var isLoadingBlogCategoryData=true.obs;
  var isLoadingBlogAutoScrollData=true.obs;
  var key="".obs;
  var isLoadingMore=false.obs;

  var blogData =<GetBlogsModel>[].obs;
  List<BlogAutoScrollSliderModel>? autoScrollSliderData;
  List<BlogCategoriesModel>? blogCategoriesData;
  var blogPaginationModel=BlogPaginationModel().obs;
  @override
  void onInit() {
    fetchBlogData();
    fetchBlogCategoriesData();
    fetchAutoScrollSliderData();
    super.onInit();
  }

  void fetchBlogData() async{
    isLoadingBlogData.value=true;
    const endPoint=AppStrings.getBlogPaginationEndPoint;
    try{
      var data =await RemoteServices.getRequest(endPoint,{"":""});
      if(data!=null){

        blogPaginationModel.value=blogPaginationModelFromJson(data);
        blogData.value=blogPaginationModel.value.data??[];
        isLoadingBlogData.value=false;
      }
    }finally{
      isLoadingBlogData.value=false;
    }
  }

  void fetchFilteredBlogData() async{
    isLoadingBlogData.value=true;
    const endPoint=AppStrings.getFilterBlogPaginationEndPoint;
    try{
      var data =await RemoteServices.getRequest(endPoint+key.value,{"":""});
      if(data!=null){
        blogPaginationModel.value=blogPaginationModelFromJson(data);
        blogData.value=blogPaginationModel.value.data!;
        isLoadingBlogData.value=false;
      }
    }finally{
      isLoadingBlogData.value=false;
    }
  }

  void fetchAutoScrollSliderData() async{
    isLoadingBlogAutoScrollData.value=true;
    const endPoint=AppStrings.getBlogAutoScrollSliderEndPoint;
    try{
      var data=await RemoteServices.fetchBlogAutoScrollData(endPoint);
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
   const endPoint=AppStrings.blogCategoriesEndPoint;
    try{
      var data= await RemoteServices.fetchBlogCategoriesData(endPoint);
      if(data!=null){
        blogCategoriesData=data;
        isLoadingBlogCategoryData.value=false;
      }
    }finally{
      isLoadingBlogCategoryData.value=false;
    }
  }

  void loadMoreData(String url) async{
    var data=await RemoteServices.getRequestLoadMore(url, {"":""});
    if (data != null) {
      blogPaginationModel.value = blogPaginationModelFromJson(data);
      blogData.value = blogData.value + blogPaginationModel.value.data!;
      isLoadingMore.value = false;
    }
  }

}