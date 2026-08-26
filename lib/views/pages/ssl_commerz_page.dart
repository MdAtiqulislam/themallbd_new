/*
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:themallbd/constraints/header_text.dart';
import 'package:themallbd/controllers/check_out_controller.dart';
import 'package:themallbd/services/app_review_service.dart';
import 'package:themallbd/services/local_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/internet_controller.dart';
import '../../controllers/my_cart_controller.dart';
import '../../models/my_cart_model.dart';
import 'no_internet_page.dart';

class SSLCommerzPage extends StatelessWidget {
  String url = Get.arguments[0];

  var body = Get.arguments[1];
  var total = Get.arguments[2];

  SSLCommerzPage({Key? key}) : super(key: key);
  late WebViewController _webViewController;
  //final BottomNavigationBarController bottomNavigationBarController = Get.put(BottomNavigationBarController());
  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());

  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          /*backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),*/
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "Card Payment",
            color: Colors.white,
          ),
        ),
        body: Obx(
          () => internetConnectionController.connectionStatus.value ==
                  ConnectivityResult.none
              ? const NoInternetConnectionPage()
              : WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    _webViewController = webViewController;
                    _webViewController.clearCache();
                  },
                  onPageFinished: (_) {
                    //_webViewController.runJavascriptReturningResult(javaScriptString)
                    readJS();

                    _webViewController.currentUrl().then(
                      (url) {
                        if (url!.contains("cancel")) {
                          Get.back();
                          // print(msg);
                        }
                      },
                    );
                    //_webViewController.runJavascript("javascript:clickPayButton()");
                  },
                  javascriptChannels: <JavascriptChannel>{
                    JavascriptChannel(
                        name: 'MessageInvoker',
                        onMessageReceived: (s) async {
                          if (s.message.contains("order_id")) {
                            facebookAppEvents.logPurchase(
                                amount: total,
                                currency: "BDT",
                                parameters: body);

                            var data = json.decode(s.message);
                            Get.back();
                            Get.back();
                            Get.offAndToNamed("/order_details", arguments: [
                              data["order_id"].toString(),
                              "0.0",
                              DateTime.now(),
                              "0.0",
                              "0.0",
                              "0.0",
                              "0.0",
                              "0.0",
                              1,
                            ]);
                          //  await LocalServices.storeItemsOnCart("0");
                          //  bottomNavigationBarController.itemsOnCart.value = 0;

                            await LocalServices.storeCartItem([]).then((value) {
                              final MyCartController myCartController = Get.put(MyCartController());
                              myCartController.myCartList.value=MyCartModel();
                              myCartController.fetchMyCartData();
                              CheckOutController checkoutController=Get.put(CheckOutController());
                              checkoutController.resetFields();
                              AppReviewService.openRatingDialog();
                            });




                          }
                          if (s.message.contains("fail")) {
                            //var data=json.decode(s.message);
                            Get.back();
                          }
                        }),
                  },
                ),
        ));
  }

  Future<void> readJS() async {}
}


 */

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../constraints/header_text.dart';
import '../../controllers/check_out_controller.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/my_cart_controller.dart';
import '../../models/my_cart_model.dart';
import '../../services/app_review_service.dart';
import '../../services/local_services.dart';
import 'no_internet_page.dart';

class SSLCommerzPage extends StatelessWidget {
  String url = Get.arguments[0];
  var body = Get.arguments[1];
  var total = Get.arguments[2];

  SSLCommerzPage({super.key});

  final InternetConnectionController internetConnectionController = Get.put(InternetConnectionController());
  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: HeaderText(
            text: "Card Payment",
            color: Colors.white,
          ),
        ),
        body: Obx(
              () => internetConnectionController.connectionStatus.value.contains(ConnectivityResult.none)
              ? const NoInternetConnectionPage()
              : WebViewWidget(
            controller: webViewController
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageFinished: (String url) async {
                    await readJS();
                    webViewController.currentUrl().then((url) {
                      if (url != null && url.contains("cancel")) {
                        Get.back();
                      }
                    });
                  },
                ),
              )
              ..addJavaScriptChannel(
                'MessageInvoker',
                onMessageReceived: (JavaScriptMessage message) async {
                  if (message.message.contains("order_id")) {
                    facebookAppEvents.logPurchase(
                      amount: total,
                      currency: "BDT",
                      parameters: body,
                    );

                    await LocalServices.storeCartItem([]).then((value) {
                      final MyCartController myCartController = Get.put(MyCartController());
                      myCartController.myCartList.value = MyCartModel();
                      myCartController.fetchMyCartData();
                      CheckOutController checkoutController = Get.put(CheckOutController());
                      checkoutController.clearCart();
                      checkoutController.resetFields();
                      AppReviewService.openRatingDialog();
                    });

                    var data = json.decode(message.message);
                    Get.back();
                    Get.back();
                    Get.offAndToNamed("/order_details", arguments: [
                      data["order_id"].toString(),
                      "0.0",
                      DateTime.now(),
                      "0.0",
                      "0.0",
                      "0.0",
                      "0.0",
                      "0.0",
                      1,
                    ]);
      

                  }
                  if (message.message.contains("fail")) {
                    Get.back();
                  }
                },
              )
              ..loadRequest(Uri.parse(url)),
          ),
        ),
      ),
    );
  }

  Future<void> readJS() async {}
}
