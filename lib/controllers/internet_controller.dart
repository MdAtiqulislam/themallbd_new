import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InternetConnectionController extends GetxController {
  var connectionStatus = [ConnectivityResult.wifi].obs;
  var previousConnectionStatus = [ConnectivityResult.none].obs;
  var currentConnectionStatus = [ConnectivityResult.none].obs;
  var shouldReload = true.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      connectionStatus.value = result;
      previousConnectionStatus.value = result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Could not check connectivity status error: $e');
      }
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus.value = result;
    currentConnectionStatus.value = result;

    if (kDebugMode) {
      print("Previous Status: $previousConnectionStatus");
    }
    if (kDebugMode) {
      print("Current Status: $currentConnectionStatus");
    }
    if (previousConnectionStatus.value.contains(ConnectivityResult.none)&&
        currentConnectionStatus.value.contains(ConnectivityResult.none)) {
      shouldReload.value = true;
      previousConnectionStatus.value = currentConnectionStatus.value;
    } else {
      shouldReload.value = false;
      previousConnectionStatus.value = currentConnectionStatus.value;
    }
  }
}
