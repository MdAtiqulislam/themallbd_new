/*
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/app_review_status_model.dart';
import '../models/cart_model.dart';
import '../models/user_models/user_model.dart';



class LocalServices {
  static const _localStorage = FlutterSecureStorage();
  static const _keyToken = 'token';
  static const _keyMyMessages = 'myMessages';
  static const _keyUser = 'user';
  static const _keyCartItem = 'cartItem';
  static const _keyPreviousVersion= 'previousVersion';
  static const _keyReviewStatus= 'reviewStatus';


  //write token
 static Future storeToken(String token) async =>
      await _localStorage.write(key: _keyToken, value: token);

//read token
  static Future<String?> getToken() async =>
      await _localStorage.read(key: _keyToken);



  //write version
 static Future storeAppVersion(String appVersion) async =>
      await _localStorage.write(key: _keyPreviousVersion, value: appVersion);

//read version
  static Future<String?> getPreviousAppVersion() async =>
      await _localStorage.read(key: _keyPreviousVersion);


  //write app review status
 static Future storeAppReviewStatus(AppReviewStatusModel appReviewStatus) async {
   final value=json.encode(appReviewStatus);
   await _localStorage.write(key: _keyReviewStatus, value: value);

 }

//read app review status
  static Future<AppReviewStatusModel?> getAppReviewStatus() async {
    final value=await _localStorage.read(key: _keyReviewStatus);
    return value==null?null:AppReviewStatusModel.fromJson(json.decode(value));
  }



*/
/*  //write Items on Cart
 static Future storeItemsOnCart(String itemsOnCart) async =>
      await _localStorage.write(key: _keyItemsOnCart, value: itemsOnCart);
//read Items on Cart
  static Future<String?> getItemsOnCart() async =>
      await _localStorage.read(key: _keyItemsOnCart);*//*



  //store user
  Future storeUser(UserModel user) async {
    final value=json.encode(user);
    await _localStorage.write(key: _keyUser, value: value);
  }
  //read user
  static Future<UserModel?> getUser() async {
    final value=await _localStorage.read(key: _keyUser);
    return value==null?null:UserModel.fromJson(json.decode(value));
  }


  //store Cart Item
 static Future storeCartItem(List<CartModel>? cartItems) async {
    final value=cartModelToJson(cartItems!);
    await _localStorage.write(key: _keyCartItem, value: value);
  }
  //read Cart Item
  static Future <List<CartModel>?> getCartItems() async {
    final value=await _localStorage.read(key: _keyCartItem);
    return value==null?null:cartModelFromJson(value);
  }


  //store Cart Item
 static Future storeMyMessages(List<RemoteMessage>? myMessages) async {
    final value=json.encode(List<dynamic>.from(myMessages!.map((x) => x.toMap())));
    await _localStorage.write(key: _keyMyMessages, value: value);
  }
  //read Cart Item
  static Future <List<RemoteMessage>?> getMyMessages() async {
    final value=await _localStorage.read(key: _keyMyMessages);
    return value==null?null:List<RemoteMessage>.from(json.decode(value).map((x) => RemoteMessage.fromMap(x)));
  }



  static Future deleteData() async => await _localStorage.deleteAll();
}
*/
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/app_review_status_model.dart';
import '../models/cart_model.dart';
import '../models/user_models/user_model.dart';

class LocalServices {
  static const _keyToken = 'token';
  static const _keyMyMessages = 'myMessages';
  static const _keyUser = 'user';
  static const _keyCartItem = 'cartItem';
  static const _keyPreviousVersion = 'previousVersion';
  static const _keyReviewStatus = 'reviewStatus';
  static const _keyVipPrivilege = 'vipPrivilege';
  static const _keyShowOfferPopup = 'showOfferPopup';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Write token
  static Future<void> storeToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_keyToken, token);
  }

  // Read token
  static Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_keyToken);
  }

  static Future<void> storeVipPrivilege(bool status) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyVipPrivilege, status);
  }

  static Future<bool> getVipPrivilege() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyVipPrivilege) ?? false;
  }

  static Future<void> storeOfferPopupShownStatus(bool status) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyShowOfferPopup, status);
  }

  static Future<bool> getOfferPopupShownStatus() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyShowOfferPopup) ?? false;
  }

  // Write version
  static Future<void> storeAppVersion(String appVersion) async {
    final prefs = await _prefs;
    await prefs.setString(_keyPreviousVersion, appVersion);
  }

  // Read version
  static Future<String?> getPreviousAppVersion() async {
    final prefs = await _prefs;
    return prefs.getString(_keyPreviousVersion);
  }

  // Write app review status
  static Future<void> storeAppReviewStatus(AppReviewStatusModel appReviewStatus) async {
    final prefs = await _prefs;
    final value = json.encode(appReviewStatus);
    await prefs.setString(_keyReviewStatus, value);
  }

  // Read app review status
  static Future<AppReviewStatusModel?> getAppReviewStatus() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyReviewStatus);
    return value == null ? null : AppReviewStatusModel.fromJson(json.decode(value));
  }

  // Store user
  static Future<void> storeUser(UserModel user) async {
    final prefs = await _prefs;
    final value = json.encode(user);
    await prefs.setString(_keyUser, value);
  }

  // Read user
  static Future<UserModel?> getUser() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyUser);
    return value == null ? null : UserModel.fromJson(json.decode(value));
  }

  // Store cart items
  static Future<void> storeCartItem(List<CartModel>? cartItems) async {
    final prefs = await _prefs;
    final value = cartModelToJson(cartItems!);
    await prefs.setString(_keyCartItem, value);
  }

  // Read cart items
  static Future<List<CartModel>?> getCartItems() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyCartItem);
    return value == null ? null : cartModelFromJson(value);
  }

  // Store messages
  static Future<void> storeMyMessages(List<RemoteMessage>? myMessages) async {
    final prefs = await _prefs;
    final value = json.encode(List<dynamic>.from(myMessages!.map((x) => x.toMap())));
    await prefs.setString(_keyMyMessages, value);
  }

  // Read messages
  static Future<List<RemoteMessage>?> getMyMessages() async {
    final prefs = await _prefs;
    final value = prefs.getString(_keyMyMessages);
    return value == null ? null : List<RemoteMessage>.from(json.decode(value).map((x) => RemoteMessage.fromMap(x)));
  }

  // Delete all data
  static Future<void> deleteData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
