import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../services/local_services.dart';
import '../../services/notification_services.dart';

class MyNotificationsController extends GetxController{
 static var isLoading=true.obs;
 static  var myNotifications=<RemoteMessage>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getNotifications();
    super.onInit();
  }

 static void getNotifications()async {
    await LocalServices.getMyMessages().then((value) {
      myNotifications.value=value??[];
     // myNotifications.forEach((element) {print(element.messageId);});
      isLoading.value=false;
    });
  }

  void viewNotification({required RemoteMessage message}) {
    isLoading.value=true;
    NotificationServices.handleMessageClick(Get.context!, message).then((value){
      isLoading.value=false;
    });

  }
}