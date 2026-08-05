import Flutter
import UIKit
// Firebase disabled (not used currently)
// import Firebase
import UserNotifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //  FirebaseApp.configure()
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    GMSServices.provideAPIKey("AIzaSyClJchSAuHzo5eLYcpbntzMbMA-zzpX0WI")

    GeneratedPluginRegistrant.register(with: self)

    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}