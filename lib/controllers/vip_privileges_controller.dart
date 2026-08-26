import 'package:get/get.dart';
import '../constraints/app_strings.dart';
import '../models/vip_privilege_category_shop_model.dart';
import '../models/vip_privilege_trending_offer_model.dart';
import '../models/vip_privileges_category_model.dart';
import '../services/local_services.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';

class VIPPrivilegesController extends GetxController{
  var isLoading=false.obs;
  var isLoadingTrendingOffers=true.obs;
  var isLoadingShop=false.obs;
  var categoryList=<VipPrivilegesCategoryModel>[].obs;
  var categoryShopList=<VipPrivilegesCategoryShopModel>[].obs;
  var trendingOffersList=<TrendingOffersModel>[].obs;
  var allPrivilegesList=<TrendingOffersModel>[].obs;
  var token="";
  var selectedCategory=(-1).obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    getToken();
    getCategory();
   // getCategoryShop();
    super.onInit();
  }

  void getToken() async{
    token= await LocalServices.getToken()??"";
  }
  void getCategory()async{
    isLoading.value=true;
    const endPoint=AppStrings.vipPrivilegesCategoryEndPoint;
    var header={'Authorization': 'Bearer $token'};

    try{
      var data=await RemoteServices.getRequest(endPoint, header);
      if(data!=null){
        categoryList.value=vipPrivilegesCategoryModelFromJson(data);
        //selectedCategory.value=-1;
        getAllPrivileges();
        isLoading.value=false;
      }else{
        ShowSnackBar(isSuccess:false,msg: AppStrings.httpResponseMSG.value).showSnackBar();
      }
    }finally{
      isLoading.value=false;
    }
  }

  void getCategoryShop()async{
    isLoadingShop.value=true;
    const endPoint=AppStrings.vipPrivilegesCategoryShopEndPoint;
    var header={'Authorization': 'Bearer $token'};
    try{
      var data=await RemoteServices.getRequest(endPoint+selectedCategory.value.toString(), header);
      if(data!=null){
        categoryShopList.value=vipPrivilegesCategoryShopModelFromJson(data);
       // selectedCategory.value=categoryList.value[0].id!;
        isLoadingShop.value=false;
        if(trendingOffersList.isEmpty)getTrendingOffers();
      }else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    }finally{
      isLoadingShop.value=false;
    }
  }


  void getAllPrivileges()async{
    isLoadingShop.value=true;
    const endPoint=AppStrings.vipPrivilegesAllCategoryShopEndPoint;
    var header={'': ''};
    try{
      var data=await RemoteServices.getRequest(endPoint.toString(), header);
      if(data!=null){
        allPrivilegesList.value=trendingOffersModelFromJson(data);
       // selectedCategory.value=categoryList.value[0].id!;
        isLoadingShop.value=false;
       if(trendingOffersList.isEmpty)getTrendingOffers();
      }else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    }finally{
      isLoadingShop.value=false;
    }
  }



  void getTrendingOffers()async{
    const endPoint=AppStrings.vipPrivilegesTrendingOffersEndpoint;
    var header={'': ''};
    try{
      var data=await RemoteServices.getRequest(endPoint, header);
      if(data!=null){
        trendingOffersList.value=trendingOffersModelFromJson(data);
        isLoadingTrendingOffers.value=false;
      }else{
        ShowSnackBar(msg: AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
    }finally{
      isLoadingTrendingOffers.value=false;
    }
  }
}