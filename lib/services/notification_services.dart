/*

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/controllers/deeplink_controller.dart';

import '../controllers/home_page_data_controller.dart';
import '../controllers/user_controllers/my_notifications_controller.dart';
import '../controllers/user_controllers/user_info_controller.dart';
import 'local_services.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static var myMessages = <RemoteMessage>[].obs;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User granted permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    } else {
      if (kDebugMode) {
        print("User denied permission");
      }
    }
  }

  static void initLocalNotification(BuildContext context,
      RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
        onDidReceiveNotificationResponse: (payload) {
          handleMessageClick(context, message);
        }, settings: initializationSettings);
  }


  Future<void> createNotificationChannel() async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'), // Custom sound
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }



  static Future<void> firebaseInit(BuildContext context) async {
    //messaging.subscribeToTopic("general_push_notification");
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        foregroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
      // addNotificationToLocalStorage(message);
    });
  }

  static Future<void> showNotification(RemoteMessage message) async {

    print(message.data);


    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      importance: Importance.high,
      description: 'This channel is used for important notifications.', // description
    );

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: "channel description",
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: "ticker",
    //  fullScreenIntent: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
           id:  0,
         title:  message.notification!.title.toString(),
         body:  message.notification!.body.toString(),
         notificationDetails:  notificationDetails
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print("FCM Token:$token");
    }
    return token!;
  }

  static Future<void> handleMessageClick(
      BuildContext context, RemoteMessage message) async {
    try {
      await LocalServices.getMyMessages().then((value) async {
        myMessages.value=value??[];
        myMessages.removeWhere((element) => element.messageId==message.messageId);
        await LocalServices.storeMyMessages(myMessages).then((value){
          MyNotificationsController.getNotifications();
          UserInfoController.getUser();
        });
      });


      // Handle the deep link if present
      final deepLinkUrl = message.data["deep_link"];

      print(deepLinkUrl);
      if (deepLinkUrl != null) {
        final Uri deepLink = Uri.parse(deepLinkUrl);

       Get.put(DeepLinkController()).handleDeepLink(deepLink);
      }
    } catch (error) {
      // Log the error for debugging
      if (kDebugMode) {
        print('Error handling message click: $error');
      }
    }
  }


  static Future foregroundMessage()async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInterruptMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.data.isNotEmpty) {
        handleMessageClick(context, initialMessage);
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      handleMessageClick(context, event);
    });
  }
}*/


import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:themallbd_new/controllers/deeplink_controller.dart';

import '../controllers/home_page_data_controller.dart';
import '../controllers/user_controllers/my_notifications_controller.dart';
import '../controllers/user_controllers/user_info_controller.dart';
import 'local_services.dart';

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final myMessages = <RemoteMessage>[].obs;

  // ============================================================
  // 1. REQUEST NOTIFICATION PERMISSION
  // ============================================================

  Future<void> requestNotificationPermission() async {
    try {
      final NotificationSettings settings =
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,

        // Not required for normal notifications
        announcement: false,
        carPlay: false,
        criticalAlert: false,

        // false = normal permission popup
        provisional: false,
      );

      if (kDebugMode) {
        print(
          "🔔 Notification Permission: "
              "${settings.authorizationStatus}",
        );
      }

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          if (kDebugMode) {
            print("✅ User granted notification permission");
          }
          break;

        case AuthorizationStatus.provisional:
          if (kDebugMode) {
            print("⚠️ User granted provisional permission");
          }
          break;

        case AuthorizationStatus.denied:
          if (kDebugMode) {
            print("❌ User denied notification permission");
          }
          break;

        case AuthorizationStatus.notDetermined:
          if (kDebugMode) {
            print("⚠️ Notification permission not determined");
          }
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Notification permission error: $e");
      }
    }
  }

  // ============================================================
  // 2. WAIT FOR APNS TOKEN
  // ============================================================

  Future<String?> _getAPNSToken() async {
    if (!Platform.isIOS) {
      return null;
    }

    try {
      String? apnsToken;

      // Try for maximum 10 seconds
      for (int i = 0; i < 10; i++) {
        apnsToken = await messaging.getAPNSToken();

        if (apnsToken != null && apnsToken.isNotEmpty) {
          if (kDebugMode) {
            print("✅ APNs Token received:");
            print(apnsToken);
          }

          return apnsToken;
        }

        if (kDebugMode) {
          print(
            "⏳ Waiting for APNs token... "
                "${i + 1}/10",
          );
        }

        await Future.delayed(
          const Duration(seconds: 1),
        );
      }

      if (kDebugMode) {
        print("❌ APNs token was not received.");
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("❌ APNs token error: $e");
      }

      return null;
    }
  }

  // ============================================================
  // 3. GET FCM DEVICE TOKEN
  // ============================================================

  Future<String?> getDeviceToken() async {
    try {
      // --------------------------------------------------------
      // iOS
      // APNs token MUST be available before getToken()
      // --------------------------------------------------------

      if (Platform.isIOS) {
        final String? apnsToken = await _getAPNSToken();

        if (apnsToken == null) {
          if (kDebugMode) {
            print(
              "❌ Cannot get FCM token because "
                  "APNs token is not available.",
            );
          }

          return null;
        }
      }

      // --------------------------------------------------------
      // Get FCM Token
      // --------------------------------------------------------

      final String? token = await messaging.getToken();

      if (kDebugMode) {
        print("====================================");
        print("✅ FCM TOKEN");
        print(token);
        print("====================================");
      }

      return token;
    } catch (e) {
      if (kDebugMode) {
        print("❌ FCM Token Error: $e");
      }

      return null;
    }
  }

  // ============================================================
  // 4. SUBSCRIBE TO TOPIC
  // ============================================================

  Future<void> subscribeToTopic(
      String topic,
      ) async {
    try {
      // iOS requires APNs token before topic subscription
      if (Platform.isIOS) {
        final String? apnsToken = await _getAPNSToken();

        if (apnsToken == null) {
          if (kDebugMode) {
            print(
              "❌ Cannot subscribe to topic. "
                  "APNs token is not available.",
            );
          }

          return;
        }
      }

      await messaging.subscribeToTopic(topic);

      if (kDebugMode) {
        print("✅ Subscribed to topic: $topic");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Topic subscription error: $e");
      }
    }
  }

  // ============================================================
  // 5. LOCAL NOTIFICATION INITIALIZATION
  // ============================================================

  static Future<void> initLocalNotification(
      BuildContext context,
      RemoteMessage message,
      ) async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        handleMessageClick(
          context,
          message,
        );
      },
    );
  }

  // ============================================================
  // 6. ANDROID NOTIFICATION CHANNEL
  // ============================================================

  Future<void> createNotificationChannel() async {
    if (!Platform.isAndroid) {
      return;
    }

    const AndroidNotificationChannel channel =
    AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description:
      'This channel is used for important notifications.',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ============================================================
  // 7. FIREBASE MESSAGE INITIALIZATION
  // ============================================================

  static Future<void> firebaseInit(
      BuildContext context,
      ) async {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) async {
        if (kDebugMode) {
          print("====================================");
          print("📩 FOREGROUND MESSAGE");
          print("Title: ${message.notification?.title}");
          print("Body: ${message.notification?.body}");
          print("Data: ${message.data}");
          print("====================================");
        }

        // ------------------------------------------------------
        // iOS
        // ------------------------------------------------------

        if (Platform.isIOS) {
          await foregroundMessage();
        }

        // ------------------------------------------------------
        // Android
        // ------------------------------------------------------

        if (Platform.isAndroid) {
          await initLocalNotification(
            context,
            message,
          );

          await showNotification(
            message,
          );
        }

        // ------------------------------------------------------
        // iOS
        //
        // iOS system handles foreground notification because
        // setForegroundNotificationPresentationOptions() is enabled.
        // ------------------------------------------------------

        if (Platform.isIOS) {
          // No need to manually show the same notification here.
        }
      },
    );
  }

  // ============================================================
  // 8. SHOW LOCAL NOTIFICATION
  // ============================================================

  static Future<void> showNotification(
      RemoteMessage message,
      ) async {
    try {
      if (kDebugMode) {
        print("Notification Data: ${message.data}");
      }

      // --------------------------------------------------------
      // Android
      // --------------------------------------------------------

      const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description:
        'This channel is used for important notifications.',
        importance: Importance.high,
        showBadge: true,
      );

      const AndroidNotificationDetails
      androidNotificationDetails =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription:
        'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        channelShowBadge: true,
        ticker: 'ticker',
      );

      // --------------------------------------------------------
      // iOS
      // --------------------------------------------------------

      const DarwinNotificationDetails
      darwinNotificationDetails =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      final notification = message.notification;

      if (notification == null) {
        if (kDebugMode) {
          print(
            "⚠️ Notification payload is null. "
                "Skipping local notification.",
          );
        }

        return;
      }

      await _flutterLocalNotificationsPlugin.show(
        id: message.hashCode,
        title: notification.title ?? '',
        body: notification.body ?? '',
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      if (kDebugMode) {
        print("❌ Show notification error: $e");
      }
    }
  }

  // ============================================================
  // 9. FOREGROUND NOTIFICATION - iOS
  // ============================================================

  static Future<void> foregroundMessage() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print(
          "✅ iOS foreground notification presentation enabled",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          "❌ Foreground notification error: $e",
        );
      }
    }
  }

  // ============================================================
  // 10. HANDLE NOTIFICATION CLICK
  // ============================================================

  static Future<void> handleMessageClick(
      BuildContext context,
      RemoteMessage message,
      ) async {
    try {
      if (kDebugMode) {
        print("📲 Notification clicked");
        print("Data: ${message.data}");
      }

      // --------------------------------------------------------
      // Update local notification storage
      // --------------------------------------------------------

      final value = await LocalServices.getMyMessages();

      myMessages.value = value ?? [];

      myMessages.removeWhere(
            (element) =>
        element.messageId == message.messageId,
      );

      await LocalServices.storeMyMessages(
        myMessages,
      );

      // --------------------------------------------------------
      // Refresh notification/user data
      // --------------------------------------------------------

      MyNotificationsController.getNotifications();
      UserInfoController.getUser();

      // --------------------------------------------------------
      // Deep Link
      // --------------------------------------------------------

      final String? deepLinkUrl =
      message.data["deep_link"]?.toString();

      if (kDebugMode) {
        print("Deep Link: $deepLinkUrl");
      }

      if (deepLinkUrl != null &&
          deepLinkUrl.isNotEmpty) {
        final Uri deepLink = Uri.parse(
          deepLinkUrl,
        );

        Get.put(
          DeepLinkController(),
        ).handleDeepLink(
          deepLink,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          "❌ Error handling notification click: $e",
        );
      }
    }
  }

  // ============================================================
  // 11. HANDLE INITIAL / BACKGROUND MESSAGE
  // ============================================================

  Future<void> setupInterruptMessage(
      BuildContext context,
      ) async {
    try {
      // --------------------------------------------------------
      // App opened from terminated state
      // --------------------------------------------------------

      final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance
          .getInitialMessage();

      if (initialMessage != null) {
        if (kDebugMode) {
          print(
            "📲 App opened from terminated state",
          );
        }

        if (initialMessage.data.isNotEmpty) {
          await handleMessageClick(
            context,
            initialMessage,
          );
        }
      }

      // --------------------------------------------------------
      // App opened from background
      // --------------------------------------------------------

      FirebaseMessaging.onMessageOpenedApp.listen(
            (RemoteMessage message) async {
          if (kDebugMode) {
            print(
              "📲 App opened from background",
            );
          }

          await handleMessageClick(
            context,
            message,
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(
          "❌ Message click setup error: $e",
        );
      }
    }
  }

  // ============================================================
  // 12. COMPLETE INITIALIZATION
  // ============================================================

  Future<String?> initialize(
      BuildContext context, {
        String? topic,
      }) async {
    try {
      if (kDebugMode) {
        print("====================================");
        print("🚀 Notification Service Initializing");
        print("Platform: ${Platform.operatingSystem}");
        print("====================================");
      }

      // --------------------------------------------------------
      // Permission
      // --------------------------------------------------------

      await requestNotificationPermission();

      // --------------------------------------------------------
      // Android channel
      // --------------------------------------------------------

      if (Platform.isAndroid) {
        await createNotificationChannel();
      }

      // --------------------------------------------------------
      // Firebase foreground listener
      // --------------------------------------------------------

      await firebaseInit(context);

      // --------------------------------------------------------
      // Notification click listener
      // --------------------------------------------------------

      await setupInterruptMessage(context);

      // --------------------------------------------------------
      // FCM Token
      // --------------------------------------------------------

      final String? token = await getDeviceToken();

      // --------------------------------------------------------
      // Topic
      // --------------------------------------------------------

      if (token != null &&
          token.isNotEmpty &&
          topic != null &&
          topic.isNotEmpty) {
        await subscribeToTopic(topic);
      }

      if (kDebugMode) {
        print("====================================");
        print("✅ Notification Service Initialized");
        print("====================================");
      }

      return token;
    } catch (e) {
      if (kDebugMode) {
        print(
          "❌ Notification initialization error: $e",
        );
      }

      return null;
    }
  }
}