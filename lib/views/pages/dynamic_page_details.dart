import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../../constraints/header_text.dart';
import '../../controllers/dynamic_page_details_controller.dart';
import '../../controllers/internet_controller.dart';
import 'no_internet_page.dart';

class DynamicPageDetails extends StatelessWidget {
  DynamicPageDetails({super.key});

  var pageId = Get.arguments[0].toString();
  var pageName = Get.arguments[1].toString();

  final DynamicPageController dynamicPageDetailsController =
      Get.put(DynamicPageController());
  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());

  @override
  Widget build(BuildContext context) {
    dynamicPageDetailsController.pageId.value = pageId;
    dynamicPageDetailsController.fetchData();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          /*backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: pageName,
            color: Colors.white,
          ),
        ),
        body: Obx(() => internetConnectionController.connectionStatus.value.contains(
            ConnectivityResult.none)
            ? const NoInternetConnectionPage()
            : dynamicPageBodyContent()),
      ),
    );
  }

  Widget bodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(
          10.r,
        ),
        child: /*WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller){
            controller.loadHtmlString("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">${dynamicPageDetailsController.detailsData.value.content.toString()}");
          },
        )*/
            Html(
                data: dynamicPageDetailsController.detailsData.value.content
                    .toString(),
                onLinkTap: (String? url,
                   // RenderContext context,
                    Map<String, String> attributes,
                    dom.Element? element) async {
                  final Uri _url = Uri.parse(url!);
                  if (!await launchUrl(_url,
                      mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $_url';
                  }
                }),
      ),
    );
  }

  Widget dynamicPageBodyContent() {
    return dynamicPageDetailsController.isLoadingDetails.value
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : bodyContent();
  }
}
