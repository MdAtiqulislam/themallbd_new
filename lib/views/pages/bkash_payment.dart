/*

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../../constraints/header_text.dart';
import '../../controllers/check_out_controller.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/my_cart_controller.dart';
import '../../models/my_cart_model.dart';
import '../../models/payment_request.dart';
import '../../services/app_review_service.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';

import '../../utils/js_interface.dart';
import 'no_internet_page.dart';

class BkashPayment extends StatefulWidget {
  String? amount;
  String token;
  String orderId;
  double? total;
  var body;

  BkashPayment(
      {super.key,
      this.amount,
      required this.token,
      required this.orderId,
      this.total,
      this.body});

  @override
  _BkashPaymentState createState() => _BkashPaymentState();
}

class _BkashPaymentState extends State<BkashPayment> {
  late WebViewController _controller;
  late JavaScriptInterface _javaScriptInterface;

  final InternetConnectionController internetConnectionController =
      Get.put(InternetConnectionController());
  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  bool isLoading = true;
  var paymentRequest = "";

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebViewWidget.platform = SurfaceAndroidWebView();

    var request = PaymentRequest(widget.amount, "sale");

    paymentRequest = "{paymentRequest: ${jsonEncode(request)}}";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _controller.runJavaScript("javascript:clickPayButton()");
            setState(() => isLoading = false);

            _controller.currentUrl().then(
              (url) {
                if (kDebugMode) {
                  print(url);
                }
                if (url!.contains("cancel")) {
                  Get.back();
                }
              },
            );
          },
          onWebResourceError: (WebResourceError error) {
            if (kDebugMode) {
              print("Web resource error: $error");
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains("order_id")) {
              _handleOrderSuccess(request.url);
            } else if (request.url.contains("fail")) {
              Get.back();
            }

            return NavigationDecision.navigate;
          },
        ),
      )..addJavaScriptChannel(
        'MessageInvoker',
        onMessageReceived: (JavaScriptMessage message) async {
          if (message.message.contains("order_id")) {
            facebookAppEvents.logPurchase(
              amount: widget.total??0,
              currency: "BDT",
              parameters: widget.body,
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
      ..loadRequest(Uri.parse(
          '${RemoteServices.bkashBaseURL}${widget.orderId}/${widget.token}'));
      //..addJavaScriptChannel(name, onMessageReceived: onMessageReceived);
  }

  void _handleOrderSuccess(String url) async {
    var data = json.decode(url);

    facebookAppEvents.logPurchase(
        amount: widget.total ?? 0.0, currency: "BDT", parameters: widget.body);

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

    await LocalServices.storeCartItem([]).then((value) {
      final MyCartController myCartController = Get.put(MyCartController());
      myCartController.myCartList.value = MyCartModel();
      myCartController.fetchMyCartData();
      CheckOutController checkoutController = Get.put(CheckOutController());
      checkoutController.resetFields();
      AppReviewService.openRatingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: HeaderText(
            text: 'bKash Payment',
            color: Colors.white,
          ),
        ),
        body: Obx(
          () => internetConnectionController.connectionStatus.value ==
                  ConnectivityResult.none
              ? const NoInternetConnectionPage()
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
        ),
      ),
    );
  }
}
*/

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constraints/header_text.dart';
import '../../controllers/check_out_controller.dart';
import '../../controllers/internet_controller.dart';
import '../../controllers/my_cart_controller.dart';
import '../../models/my_cart_model.dart';
import '../../models/payment_request.dart';
import '../../services/app_review_service.dart';
import '../../services/local_services.dart';
import '../../services/remote_services.dart';
import '../../utils/js_interface.dart';
import 'no_internet_page.dart';

class BkashPayment extends StatefulWidget {
  final String? amount;
  final String token;
  final String orderId;
  final double? total;
  final dynamic body;

  const BkashPayment({
    super.key,
    this.amount,
    required this.token,
    required this.orderId,
    this.total,
    this.body,
  });

  @override
  State<BkashPayment> createState() => _BkashPaymentState();
}

class _BkashPaymentState extends State<BkashPayment> {
  late final WebViewController _controller;
  late final JavaScriptInterface _javaScriptInterface;

  final InternetConnectionController internetConnectionController =
  Get.put(InternetConnectionController());

  final FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  bool isLoading = true;
  bool _paymentHandled = false;

  String paymentRequest = '';

  @override
  void initState() {
    super.initState();

    final request = PaymentRequest(
      widget.amount,
      "sale",
    );

    paymentRequest = "{paymentRequest: ${jsonEncode(request)}}";

    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )

    // ------------------------------------------------------------
    // Navigation Delegate
    // ------------------------------------------------------------

      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint(
              'bKash WebView Progress: $progress%',
            );
          },

          onPageStarted: (String url) {
            debugPrint(
              'bKash PAGE STARTED: $url',
            );

            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },

          onPageFinished: (String url) async {
            debugPrint(
              'bKash PAGE FINISHED: $url',
            );

            if (url.toLowerCase().contains('cancel')) {
              debugPrint(
                'bKash payment cancelled.',
              );

              if (mounted) {
                Get.back();
              }

              return;
            }

            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }

            // ------------------------------------------------------
            // Execute bKash JavaScript
            // ------------------------------------------------------

            try {
              await Future.delayed(
                const Duration(
                  milliseconds: 500,
                ),
              );

              final result = await _controller.runJavaScriptReturningResult(
                'typeof clickPayButton === "function"',
              );

              debugPrint(
                'clickPayButton available: $result',
              );

              if (result.toString() == 'true') {
                await _controller.runJavaScript(
                  'clickPayButton();',
                );

                debugPrint(
                  'clickPayButton() executed successfully.',
                );
              } else {
                debugPrint(
                  'clickPayButton() is not available on this page.',
                );
              }
            } catch (e) {
              debugPrint(
                'Error executing clickPayButton(): $e',
              );
            }
          },

          // --------------------------------------------------------
          // Web Resource Error
          // --------------------------------------------------------

          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '''
====================================================
bKash WEBVIEW ERROR
====================================================
Error Code       : ${error.errorCode}
Description      : ${error.description}
Error Type       : ${error.errorType}
Main Frame       : ${error.isForMainFrame}
URL              : ${error.url}
====================================================
''',
            );
          },

          // --------------------------------------------------------
          // Navigation Request
          // --------------------------------------------------------

          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            debugPrint(
              'bKash NAVIGATION REQUEST: $url',
            );

            final lowerUrl = url.toLowerCase();

            // ------------------------------------------------------
            // SUCCESS
            // ------------------------------------------------------

            if (lowerUrl.contains('order_id')) {
              debugPrint(
                'bKash SUCCESS URL detected: $url',
              );

              _handleOrderSuccess(url);

              return NavigationDecision.prevent;
            }

            // ------------------------------------------------------
            // FAILED
            // ------------------------------------------------------

            if (lowerUrl.contains('fail')) {
              debugPrint(
                'bKash FAILED URL detected: $url',
              );

              if (!_paymentHandled && mounted) {
                _paymentHandled = true;
                Get.back();
              }

              return NavigationDecision.prevent;
            }

            // ------------------------------------------------------
            // CANCELLED
            // ------------------------------------------------------

            if (lowerUrl.contains('cancel')) {
              debugPrint(
                'bKash CANCEL URL detected: $url',
              );

              if (!_paymentHandled && mounted) {
                _paymentHandled = true;
                Get.back();
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )

    // ------------------------------------------------------------
    // JavaScript Channel
    // ------------------------------------------------------------

      ..addJavaScriptChannel(
        'MessageInvoker',
        onMessageReceived: (JavaScriptMessage message) async {
          final messageText = message.message;

          debugPrint(
            'bKash JS MESSAGE: $messageText',
          );

          // --------------------------------------------------------
          // SUCCESS
          // --------------------------------------------------------

          if (messageText.contains('order_id')) {
            await _handleJavaScriptSuccess(
              messageText,
            );

            return;
          }

          // --------------------------------------------------------
          // FAILED
          // --------------------------------------------------------

          if (messageText.contains('fail')) {
            debugPrint(
              'bKash JS payment failed.',
            );

            if (!_paymentHandled && mounted) {
              _paymentHandled = true;
              Get.back();
            }
          }
        },
      )

    // ------------------------------------------------------------
    // Load bKash URL
    // ------------------------------------------------------------

      ..loadRequest(
        Uri.parse(
          '${RemoteServices.bkashBaseURL}'
              '${widget.orderId}/'
              '${widget.token}',
        ),
      );
  }

  // ================================================================
  // JS SUCCESS HANDLER
  // ================================================================

  Future<void> _handleJavaScriptSuccess(
      String message,
      ) async {
    if (_paymentHandled) {
      return;
    }

    _paymentHandled = true;

    try {
      final data = _decodePaymentResponse(
        message,
      );

      if (data == null) {
        debugPrint(
          'Unable to decode bKash JS response: $message',
        );

        _paymentHandled = false;
        return;
      }

      await _completePayment(
        data,
      );
    } catch (e, stackTrace) {
      debugPrint(
        'bKash JS success handling error: $e',
      );

      debugPrint(
        stackTrace.toString(),
      );

      _paymentHandled = false;
    }
  }

  // ================================================================
  // NAVIGATION SUCCESS HANDLER
  // ================================================================

  Future<void> _handleOrderSuccess(
      String url,
      ) async {
    if (_paymentHandled) {
      return;
    }

    _paymentHandled = true;

    try {
      debugPrint(
        'Processing bKash success URL: $url',
      );

      final data = _decodePaymentResponse(
        url,
      );

      if (data == null) {
        debugPrint(
          'Unable to decode bKash success URL.',
        );

        _paymentHandled = false;
        return;
      }

      await _completePayment(
        data,
      );
    } catch (e, stackTrace) {
      debugPrint(
        'bKash order success error: $e',
      );

      debugPrint(
        stackTrace.toString(),
      );

      _paymentHandled = false;
    }
  }

  // ================================================================
  // PAYMENT RESPONSE DECODER
  // ================================================================

  Map<String, dynamic>? _decodePaymentResponse(
      String value,
      ) {
    // --------------------------------------------------------------
    // First try JSON
    // --------------------------------------------------------------

    try {
      final decoded = json.decode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(
          decoded,
        );
      }
    } catch (_) {
      // Not JSON.
    }

    // --------------------------------------------------------------
    // Then try URL
    // --------------------------------------------------------------

    try {
      final uri = Uri.tryParse(value);

      if (uri != null) {
        final queryParameters = uri.queryParameters;

        if (queryParameters.containsKey('order_id')) {
          return {
            'order_id': queryParameters['order_id'],
          };
        }

        // Some APIs may return path based order ID.
        for (final segment in uri.pathSegments) {
          if (segment.isNotEmpty &&
              segment.toLowerCase().contains('order')) {
            return {
              'order_id': segment,
            };
          }
        }
      }
    } catch (_) {
      // Ignore invalid URL.
    }

    return null;
  }

  // ================================================================
  // COMPLETE PAYMENT
  // ================================================================

  Future<void> _completePayment(
      Map<String, dynamic> data,
      ) async {
    final orderId = data['order_id']?.toString();

    if (orderId == null || orderId.isEmpty) {
      debugPrint(
        'bKash response does not contain order_id.',
      );

      _paymentHandled = false;
      return;
    }

    debugPrint(
      'bKash Order ID: $orderId',
    );

    // --------------------------------------------------------------
    // Facebook Purchase Event
    // --------------------------------------------------------------

    try {
      await facebookAppEvents.logPurchase(
        amount: widget.total ?? 0.0,
        currency: 'BDT',
        parameters: widget.body,
      );
    } catch (e) {
      debugPrint(
        'Facebook purchase event error: $e',
      );
    }

    // --------------------------------------------------------------
    // Clear Local Cart
    // --------------------------------------------------------------

    try {
      await LocalServices.storeCartItem(
        [],
      );

      final MyCartController myCartController =
      Get.put(MyCartController());

      myCartController.myCartList.value =
          MyCartModel();

      myCartController.fetchMyCartData();

      final CheckOutController checkoutController =
      Get.put(CheckOutController());

      checkoutController.clearCart();
      checkoutController.resetFields();

      AppReviewService.openRatingDialog();
    } catch (e) {
      debugPrint(
        'Cart cleanup error: $e',
      );
    }

    // --------------------------------------------------------------
    // Navigate to Order Details
    // --------------------------------------------------------------

    if (!mounted) {
      return;
    }

    Get.back();
    Get.back();

    Get.offAndToNamed(
      '/order_details',
      arguments: [
        orderId,
        '0.0',
        DateTime.now(),
        '0.0',
        '0.0',
        '0.0',
        '0.0',
        '0.0',
        1,
      ],
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: HeaderText(
            text: 'bKash Payment',
            color: Colors.white,
          ),
        ),
        body: Obx(
              () {
            final isOffline =
                internetConnectionController
                    .connectionStatus
                    .value ==
                    ConnectivityResult.none;

            if (isOffline) {
              return const NoInternetConnectionPage();
            }

            return Stack(
              children: [
                WebViewWidget(
                  controller: _controller,
                ),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
