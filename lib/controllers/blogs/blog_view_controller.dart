import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constraints/app_strings.dart';
import '../../models/blog_models/blog_view_model.dart';
import '../../services/remote_services.dart';

class BlogViewController extends GetxController{
  var isLoading=true.obs;
  var blogViewData=BlogViewModel().obs;
  final String endPoint=AppStrings.blogViewEndPoint;
  var key="".obs;


  void fetchData() async{
    var data=await RemoteServices.fetchBlogViewData(endPoint+key.value);
    if(data!=null){
      blogViewData.value=data;
      // for (var element in offerList!) {images.add(element.image.toString());}
      isLoading.value=false;
    }
  }

  void shareWith({required String btnClicked}) async{
    if(btnClicked=="facebook"){


      String url="fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=${blogViewData.value.shareUrl}";
      final Uri _url = Uri.parse(url);
      try {
        if (!await launchUrl(_url,)) {
          throw 'Could not launch $_url';
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        String url="https://www.facebook.com/sharer/sharer.php?u=${blogViewData.value.shareUrl}";
        final Uri _url = Uri.parse(url);
        if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
          throw 'Could not launch $_url';
        }
      }



     /* String url="https://www.facebook.com/sharer/sharer.php?u=${blogViewData.value.shareUrl}";
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
    }
*/
     /* if (await canLaunchUrl(_url)){
        await launchUrl(_url);
      } else {
        // can't launch url
      }*/
    }
  }

}