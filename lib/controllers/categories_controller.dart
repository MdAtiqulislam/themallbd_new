import 'package:get/get.dart';

import '../constraints/app_strings.dart';
import '../models/categories_model.dart';
import '../services/remote_services.dart';

class CategoriesController extends GetxController
{
  List <CategoriesModel>? categoryList;
 // var categoryList=<CategoriesModel>[].obs ;
 // var searchProductsModel=SearchProductsModel().obs;
  var isLoading=true.obs;
  var isLoadingMore=false.obs;
  //var url="https://dev.themallbd.com/api/get_category";
  final endPoint=AppStrings.categoryEndpoint;
      //"https://dev.themallbd.com/api/get_category";
 // var searchKey="bangladesh".obs;
  //var url=(baseurl.value+searchKey.value).obs;
  @override
  void onInit() {
    // TODO: implement onInit
    fetchData();
    super.onInit();
  }
  void fetchData() async{
    var data=await RemoteServices.fetchCategoryData(endPoint);
    if(data!=null){
      categoryList=data;

      isLoading.value=false;
    }
  }
}