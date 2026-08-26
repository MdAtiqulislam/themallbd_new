

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constraints/app_strings.dart';
import '../models/user_models/sign_up_response_model.dart';
import '../services/local_services.dart';
import '../services/remote_services.dart';
import '../utils/show_snack_bar.dart';
import '../views/pages/user/user_info_page.dart';
import 'my_cart_controller.dart';

class SocialLoginController extends GetxController{

  var response=SignUpResponseModel().obs;

  var isLoading=false.obs;

  void facebookLogin() async{

    try {
      isLoading.value=true;
      final result = await FacebookAuth.i.login(
        permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      );


      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();

        const endPoint=AppStrings.socialLoginEndpoint;
        var header = {"": ""};
        var email=(userData.toString().contains("email"))?userData['email']:"";
        var body = {
          'facebook_id': userData['id'].toString(),
          'google_id': "",
          'apple_id': "",
          'first_name': userData['name'],
          'last_name': "",
          'email':email,
          'phone': "",
        };

        var data=await RemoteServices.postRequest(endPoint, body, header);
        if(data!=null){
          response.value = SignUpResponseModel.fromJson(data);
          // AppStrings.httpResponseMSG.value = response.value.msg!;
          isLoading.value = false;
          await LocalServices.storeToken(response.value.data?.token??"");
          await LocalServices.storeUser(response.value.data!.user!);
          ShowSnackBar( msg:response.value.msg!,isSuccess: true).showSnackBar();
          openUserInfoScreen();
        }else{
          ShowSnackBar( msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
        }


       // await FacebookAuth.instance.logOut();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }finally{
      isLoading.value=false;
    }
  }

/*  void googleLogin() async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    isLoading.value=true;

      try {
        var result=await googleSignIn.signIn();
        if(result!=null){
          if (kDebugMode) {
            print(result);
          }

            const endPoint=AppStrings.socialLoginEndpoint;
            var header = {"": ""};
            var body = {
              'facebook_id':"",
              'google_id': result.id.toString(),
              'apple_id': "",
              'first_name': result.displayName.toString(),
              'last_name': "",
              'email':result.email,
              'phone': "",
            };

            var data=await RemoteServices.postRequest(endPoint, body, header);
            if(data!=null){
              response.value = SignUpResponseModel.fromJson(data);
              // AppStrings.httpResponseMSG.value = response.value.msg!;
              isLoading.value = false;
              await LocalServices.storeToken(response.value.data?.token??"");
              await LocalServices.storeUser(response.value.data!.user!);
              ShowSnackBar( msg:response.value.msg!,isSuccess: true).showSnackBar();
              openUserInfoScreen();
            }else{
              ShowSnackBar( msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
            }
           await FacebookAuth.instance.logOut();
          }
          await googleSignIn.signOut();

    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }finally{
      isLoading.value=false;

    }
  }*/


  Future<void> googleLogin() async {
    isLoading.value = true;

    try {
      // Disconnect old sessions first
      await GoogleSignIn.instance.disconnect();
      await GoogleSignIn.instance.signOut();

      // Optional: if required for web or custom clientId usage
      await GoogleSignIn.instance.initialize(
        // clientId: "YOUR_CLIENT_ID.apps.googleusercontent.com",
      );

      final completer = Completer<GoogleSignInAccount>();

      // Listen for sign-in event
      final subscription = GoogleSignIn.instance.authenticationEvents.listen(
            (event) {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            completer.complete(event.user);
          }
        },
        onError: (error) {
          completer.completeError(Exception("Google Sign-In Error: $error"));
        },
      );

      // Trigger the sign-in prompt
      await GoogleSignIn.instance.authenticate();

      // Wait for result
      final result = await completer.future;

      if (kDebugMode) {
        print(result);
      }

      const endPoint=AppStrings.socialLoginEndpoint;
      var header = {"": ""};
      var body = {
        'facebook_id':"",
        'google_id': result.id.toString(),
        'apple_id': "",
        'first_name': result.displayName.toString(),
        'last_name': "",
        'email':result.email,
        'phone': "",
      };

      var data=await RemoteServices.postRequest(endPoint, body, header);
      if(data!=null){
        response.value = SignUpResponseModel.fromJson(data);
        // AppStrings.httpResponseMSG.value = response.value.msg!;
        isLoading.value = false;
        await LocalServices.storeToken(response.value.data?.token??"");
        await LocalServices.storeUser(response.value.data!.user!);
        ShowSnackBar( msg:response.value.msg!,isSuccess: true).showSnackBar();
        openUserInfoScreen();
      }else{
        ShowSnackBar( msg:AppStrings.httpResponseMSG.value,isSuccess: false).showSnackBar();
      }
      await FacebookAuth.instance.logOut();


      // Cleanup listener
      await subscription.cancel();

      if (kDebugMode) {
        print("Google user info: ${result.displayName}, ${result.email}");
      }


    } catch (e) {
      if (kDebugMode) {
        print("Google Login Error: $e");
      }

    } finally {
      isLoading.value = false;
    }
  }




  void appleLogin() async {
    try {
      isLoading.value = true;
      final bool isAvailable = await SignInWithApple.isAvailable();

      if (isAvailable) {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        const endPoint = AppStrings.socialLoginEndpoint;
        var header = {"":""};

        var body = {
          'facebook_id': "",
          'google_id': "",
          'apple_id': credential.userIdentifier, // Correct usage
          'first_name': credential.givenName ?? "",
          'last_name': credential.familyName ?? "",
          'email': credential.email ?? "",
          'phone': "",
        };

        var data = await RemoteServices.postRequest(endPoint, body, header);
        if (data != null) {
          response.value = SignUpResponseModel.fromJson(data);
          isLoading.value = false;

          await LocalServices.storeToken(response.value.data?.token ?? "");
          await LocalServices.storeUser(response.value.data!.user!);

          ShowSnackBar(msg: response.value.msg!, isSuccess: true).showSnackBar();
          openUserInfoScreen();
        } else {
          ShowSnackBar(
            msg: AppStrings.httpResponseMSG.value,
            isSuccess: false,
          ).showSnackBar();
        }
      } else {
        ShowSnackBar(
          msg: "Apple Sign-In is not available on this device.",
          isSuccess: false,
        ).showSnackBar();
      }
    } catch (error) {
      if (kDebugMode) print("Apple login error: $error");
      ShowSnackBar(
        msg: "Something went wrong during Apple login.",
        isSuccess: false,
      ).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }



/*  void appleLogin() async {
    final AuthorizationCredentialAppleID credential;
    try {
      isLoading.value = true;
      final bool isAvailable = await SignInWithApple.isAvailable();
      if (isAvailable) {
        credential = await SignInWithApple.getAppleIDCredential(scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ]);

        *//*  final userData = await FacebookAuth.i.getUserData(); *//*
        const endPoint = AppStrings.socialLoginEndpoint;
        var header = {"": ""};

        var email = (credential.email.toString().contains("email"))
            ? credential.email
            : "";
        var body = {
          'facebook_id': "",
          'google_id': "",
          'apple_id': credential.givenName,
          'first_name': credential.givenName,
          'last_name': "",
          'email': email,
          'phone': "",
        };

        var data = await RemoteServices.postRequest(endPoint, body, header);
        if (data != null) {
          response.value = SignUpResponseModel.fromJson(data);
          // AppStrings.httpResponseMSG.value = response.value.msg!;
          isLoading.value = false;
          await LocalServices.storeToken(response.value.data?.token ?? "");
          await LocalServices.storeUser(response.value.data!.user!);
          ShowSnackBar(msg: response.value.msg!, isSuccess: true)
              .showSnackBar();
          openUserInfoScreen();
        } else {
          ShowSnackBar(msg: AppStrings.httpResponseMSG.value, isSuccess: false)
              .showSnackBar();
        }
      }

      // await FacebookAuth.instance.logOut();

    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    } finally {
      isLoading.value = false;
    }
  }*/

  void upLoadCartItems() async{
      final MyCartController myCartController=Get.put(MyCartController());
    var cartList=await LocalServices.getCartItems()??[];

    if(cartList.isNotEmpty){
      var body={
        for(int i=0;i<cartList.length;i++)'product_id[$i]':cartList[i].product_id ,
        for(int i=0;i<cartList.length;i++)'product_quantity[$i]':cartList[i].product_quantity ,
      };
      String token;
      token=await LocalServices.getToken()??"";
      const endPoint=AppStrings.addAllCartItemsEndPoint;
      var header={'Authorization': 'Bearer $token'};
      var data=await RemoteServices.postRequest(endPoint, body, header);
      if(data!=null){

        await LocalServices.storeCartItem([]);
      }
    }
     myCartController.fetchMyCartData();

  //  BottomNavigationBarController bottomNavigationBarController=Get.put(BottomNavigationBarController());
  //  bottomNavigationBarController.itemsOnCart.value=int.parse(await LocalServices.getItemsOnCart()??"0");

    //storeItemsOnCartToLocal();
  }

  void openUserInfoScreen(){
  upLoadCartItems();
  Navigator.pushAndRemoveUntil(
      Get.context!,
      MaterialPageRoute(builder: (BuildContext context) => UserInfoPage()),
      ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
  );
}

}