import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../constraints/header_text.dart';
import '../../controllers/dynamic_page_details_controller.dart';
import '../../controllers/internet_controller.dart';
import 'no_internet_page.dart';

class DynamicPageList extends StatelessWidget {
  DynamicPageList({Key? key}) : super(key: key);
  final DynamicPageController dynamicPageController = Get.put(DynamicPageController());
  final InternetConnectionController internetConnectionController=Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    if (dynamicPageController.dynamicPageList.isEmpty) {
      dynamicPageController.fetchDynamicPageList();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
         /* backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "Need Help",
            color: Colors.white,
          ),
        ),
        body: Obx(() => internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
            ?const NoInternetConnectionPage()
            : dynamicPageController.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : bodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (buildContext, index) {
              return InkWell(
                onTap: () {

                  if(dynamicPageController.dynamicPageList.value[index].id==13){
                    Get.toNamed("/vip_privileges_page");
                  }
                  else{
                    Get.toNamed("/dynamic_page_details", arguments: [
                      dynamicPageController.dynamicPageList.value[index].id,
                      dynamicPageController.dynamicPageList.value[index].header,
                    ]);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: HeaderText(
                    text:
                        "${dynamicPageController.dynamicPageList.value[index].header}",
                    align: TextAlign.start,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            },
            separatorBuilder: (buildContext, index) {
              return const Divider(
                thickness: .5,
                color: Colors.grey,
              );
            },
            itemCount: dynamicPageController.dynamicPageList.value.length),
      ),
    );
  }
}
