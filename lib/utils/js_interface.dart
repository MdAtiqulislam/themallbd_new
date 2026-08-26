import 'package:flutter/material.dart';


class JavaScriptInterface {

  BuildContext? context;

  JavaScriptInterface(context){
    this.context = context;
  }

  void onPaymentSuccess(String message) {
    // close BkashCheckout page
    Navigator.of(context!).pop();

 /*   Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
        backgroundColor: Colors.pink,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG);*/
  }
}