import 'dart:async';
import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/controllers/home_page_data_controller.dart';
import 'package:themallbd_new/services/local_services.dart';
import 'package:themallbd_new/services/notification_services.dart';
import 'package:themallbd_new/views/pages/home_page.dart';
import 'package:themallbd_new/views/pages/search_category_product_page.dart';
import 'package:themallbd_new/views/pages/search_page.dart';
import 'package:themallbd_new/views/pages/splash_screen.dart';
import 'constraints/app_colors.dart';
import 'controllers/deeplink_controller.dart';
import 'views/pages/blog/beauty_feed_pagination.dart';
import 'views/pages/blog/blog_view.dart';
import 'views/pages/check_out_page.dart';
import 'views/pages/dynamic_page_details.dart';
import 'views/pages/dynamic_page_list.dart';
import 'views/pages/life_style_product_details_page.dart';
import 'views/pages/multiple_search.dart';
import 'views/pages/my_cart_page.dart';
import 'views/pages/privilege_details_page.dart';
import 'views/pages/product_details_page.dart';
import 'views/pages/ssl_commerz_page.dart';
import 'views/pages/test.dart';
import 'views/pages/user/add_delivery_address.dart';
import 'views/pages/user/add_review_page.dart';
import 'views/pages/user/how_to_become_vip_page.dart';
import 'views/pages/user/login_email.dart';
import 'views/pages/user/login_phone_page.dart';
import 'views/pages/user/loyalty_card_page.dart';
import 'views/pages/user/notification_screen.dart';
import 'views/pages/user/order_details_page.dart';
import 'views/pages/user/order_history_page.dart';
import 'views/pages/user/otp_page.dart';
import 'views/pages/user/password_reset_page.dart';
import 'views/pages/user/registration_page.dart';
import 'views/pages/user/review_list_page.dart';
import 'views/pages/user/user_details_page.dart';
import 'views/pages/user/user_info_page.dart';
import 'views/pages/user/user_reviews_page.dart';
import 'views/pages/user/wish_list_page.dart';
import 'views/pages/vip_privileges_page.dart';




void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  // Create the channel here
  Get.put(DeepLinkController());


  await Firebase.initializeApp(
    name: "TheMallBd", // Consider removing this if you don't need a named instance
    options: (Platform.isIOS || Platform.isMacOS)
        ? const FirebaseOptions(
        apiKey: "AIzaSyAZaZjkPjAiYtHClcW61tSFa8pliszzh7o",
        appId: "1:174086628924:ios:5ad4260d24f34d262d8539",
        messagingSenderId: "174086628924",
        projectId: "themall-361715")
        :const FirebaseOptions(
      apiKey: 'AIzaSyCjvZ1rFoAu6glMq32p-YKDlDhNgxgRUi0',
      appId: '1:174086628924:android:361b0a08dc9846442d8539',
      messagingSenderId: '174086628924',
      projectId: "themall-361715",
    ),
  );
 // await Get.put(HomePageDataController()).initDynamicLinks();
 // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);

  runApp(const MyApp());




}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{


  FacebookAppEvents facebookAppEvents=FacebookAppEvents();
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();

    LocalServices.storeOfferPopupShownStatus(false);
    if(Platform.isIOS){
      facebookAppEvents.setAdvertiserTracking(enabled: true);
    }

    messaging.subscribeToTopic("general_push_notification");
   // messaging.subscribeToTopic("test");
    Get.put(HomePageDataController());
    NotificationServices().requestNotificationPermission();
    NotificationServices().createNotificationChannel();
    NotificationServices.firebaseInit(context);
    NotificationServices().setupInterruptMessage(context);
    NotificationServices().getDeviceToken().then((value) {
      if (kDebugMode) {
        print("FCM token: $value");
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(384, 784),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            //  showPerformanceOverlay: true,
            title: 'The Mall',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              focusColor: AppColors.mainColorRed,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: AppColors.scaffoldBGColorWhite,
              fontFamily: 'Cabin',
              dialogTheme: const DialogThemeData(backgroundColor: Colors.white,),
              radioTheme: const RadioThemeData(
                fillColor: WidgetStatePropertyAll(Colors.blue)
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.mainColorRed),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 5,
                shadowColor: Colors.black,
                scrolledUnderElevation: 5,

                iconTheme: IconThemeData(color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
              cardTheme: const CardThemeData(color: Colors.white,),
              snackBarTheme:
              const SnackBarThemeData(backgroundColor: Colors.green),
            ),

            getPages: [
              // Hone Page
              GetPage(
                name: '/',
                page: () => HomePage(),
              ),
              GetPage(
                name: '/splashScreen',
                page: () => const SplashScreen(),
              ),
              GetPage(
                name: '/home_page',
                page: () => HomePage(),
              ),
              //Search Page
              GetPage(
                name: '/search_page',
                page: () => SearchPage(),
              ),
              //Search Category Product
              GetPage(
                name: '/search_category_product',
                page: () => SearchCategoryProduct(),
              ),
              // Product Details Pag
              GetPage(
                name: '/product_details_page',
                page: () => ProductDetailsPage(),
              ),
              //multiple search
              GetPage(
                name: '/multiple_search',
                page: () => MultipleSearch(),
              ),
              //login phone
              GetPage(
                name: '/login_page',
                page: () => LoginPhonePage(),
              ),
              //registration
              GetPage(
                name: '/registration_page',
                page: () => Registration(),
              ),
              //login Email
              GetPage(
                name: '/login_email_page',
                page: () => LoginEmail(),
              ),
              //otp Screen
              GetPage(
                name: '/otp_screen',
                page: () => OtpPage(),
              ),
              //password Reset
              GetPage(
                name: '/password_reset_page',
                page: () => PasswordResetPage(),
              ),
              //user Info
              GetPage(
                name: '/user_info_page',
                page: () => UserInfoPage(),
              ),
              //blog View
              GetPage(
                name: '/blog_view',
                page: () => BlogView(),
              ),
              //beauty feed
              GetPage(
                name: '/beauty_feed',
                page: () => BeautyFeedPagination(),
              ),
              //order history
              GetPage(
                name: '/order_history',
                page: () => OrderHistoryPage(),
              ),
              //wish list
              GetPage(
                name: '/wish_list',
                page: () => WishListPage(),
              ),
              //review list
              GetPage(
                name: '/review_list',
                page: () => ReviewListPage(),
              ),
              //Order Details
              GetPage(
                name: '/order_details',
                page: () => OrderDetailsPage(),
              ),
              //user_details
              GetPage(
                name: '/user_details',
                page: () => UserDetailsPage(),
              ),
              //Add Delivery Address
              GetPage(
                name: '/add_delivery_address',
                page: () => AddDeliveryAddressPage(),
              ),
              //VIP Privileges Page
              GetPage(
                name: '/vip_privileges_page',
                page: () => VIPPrivilegesPage(),
              ),
              //Loyalty Card Page
              GetPage(
                name: '/loyalty_card',
                page: () => LoyaltyCardPage(),
              ),
              //How to be a VIP Page
              GetPage(
                name: '/how_to_be_vip',
                page: () => HowToBecomeVipPage(),
              ),

              //Privilege Details
              GetPage(
                name: '/privilege_details',
                page: () => PrivilegeDetailsPage(),
              ),

              //Dynamic page List
              GetPage(
                name: '/dynamic_page_list',
                page: () => DynamicPageList(),
              ),

              //Dynamic page Details
              GetPage(
                name: '/dynamic_page_details',
                page: () => DynamicPageDetails(),
              ),

              GetPage(
                name: '/test',
                page: () => TestPage(),
              ),
              //My Cart Page
              GetPage(
                name: '/my_cart',
                page: () => MyCartPage(),
              ),
              GetPage(
                name: '/check_out_page',
                page: () => CheckOutPage(),
              ),
              GetPage(
                name: '/life_style_product_details_page',
                page: () => LifeStyleProductDetailsPage(),
              ),
              GetPage(
                name: '/ssl_commerz_page',
                page: () => SSLCommerzPage(),
              ),
              GetPage(
                name: '/user_reviews_page',
                page: () => UserReviewsPage(),
              ),
              GetPage(
                name: '/add_review_page',
                page: () => AddReviewPage(),
              ),
              GetPage(
                name: '/my_notification_page',
                page: () => NotificationScreen(),
              ),
            ],
            initialRoute: "/",
            //  initialRoute: "/splashScreen",
          );
        });
  }
}


@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessagingHandler(RemoteMessage message) async {
  try {
    // Ensure LocalServices methods are isolate-safe
    var storedMessages = await LocalServices.getMyMessages();
    var myMessages = <RemoteMessage>[];

    if (storedMessages != null) {
      myMessages = storedMessages;
    }

    myMessages.add(message);

    // Safely store updated messages
    await LocalServices.storeMyMessages(myMessages);

    if (kDebugMode) {
      print('Background message received: ${message.toMap()}');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error in background message handler: $e');
      print('Stack trace: $stackTrace');
    }
    // Optionally, log the error to a monitoring service like Crashlytics
  }
}

