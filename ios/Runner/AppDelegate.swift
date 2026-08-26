import UIKit
import Flutter
import FirebaseCore
import FBSDKCoreKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var flutterViewController: FlutterViewController?

    private let deepLinkChannelName =
        "com.themallbd.deeplink/channel"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
        UIApplication.LaunchOptionsKey: Any
        ]? = nil
    ) -> Bool {

        // MARK: - Firebase

        FirebaseApp.configure()

        // MARK: - Facebook SDK

        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        // MARK: - Flutter View Controller

        let flutterViewController = FlutterViewController()

        self.flutterViewController = flutterViewController

        let window = UIWindow(
            frame: UIScreen.main.bounds
        )

        window.rootViewController = flutterViewController
        window.makeKeyAndVisible()

        self.window = window

        // MARK: - Register Flutter Plugins

        GeneratedPluginRegistrant.register(
            with: flutterViewController
        )

        // MARK: - Notifications

        UNUserNotificationCenter.current().delegate = self

        // MARK: - Facebook Deferred Deep Link

        setupFacebookDeferredDeepLink()

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    // MARK: - Facebook Login / URL

    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [
        UIApplication.OpenURLOptionsKey: Any
        ] = [:]
    ) -> Bool {

        let handledByFacebook =
            ApplicationDelegate.shared.application(
                app,
                open: url,
                options: options
            )

        if handledByFacebook {
            return true
        }

        return super.application(
            app,
            open: url,
            options: options
        )
    }

    // MARK: - Universal Links

    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping (
            [UIUserActivityRestoring]?
        ) -> Void
    ) -> Bool {

        if userActivity.activityType ==
               NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {

            sendDeepLinkToFlutter(
                url.absoluteString
            )

            return true
        }

        return super.application(
            application,
            continue: userActivity,
            restorationHandler: restorationHandler
        )
    }

    // MARK: - Notification Presentation

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        completionHandler([
                              .alert,
                              .badge,
                              .sound
                          ])
    }

    // MARK: - Facebook Deferred Deep Link

    private func setupFacebookDeferredDeepLink() {

        AppLinkUtility.fetchDeferredAppLink {
            [weak self] url, error in

            guard let self = self else {
                return
            }

            if let error = error {
                print(
                    "Facebook Deferred Deep Link Error: \(error.localizedDescription)"
                )

                return
            }

            guard let url = url else {
                return
            }

            DispatchQueue.main.async {
                self.sendDeepLinkToFlutter(
                    url.absoluteString
                )
            }
        }
    }

    // MARK: - Send Deep Link to Flutter

    private func sendDeepLinkToFlutter(
        _ url: String
    ) {

        guard let flutterViewController =
        self.flutterViewController else {

            print(
                "FlutterViewController is not available"
            )

            return
        }

        let channel = FlutterMethodChannel(
            name: deepLinkChannelName,
            binaryMessenger:
            flutterViewController.binaryMessenger
        )

        channel.invokeMethod(
            "onDeepLinkReceived",
            arguments: url
        )
    }
}