import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
// --- Firebase disabled (not used currently) ---
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:hive_manager/firebase_options.dart';
// import 'package:hive_manager/src/core/services/firebase/firebase_notification.dart';
// ------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/screen_util_init_app.dart';
import 'package:hive_manager/src/core/di/injection_container.dart';
// import 'package:hive_manager/src/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Firebase messaging background handler disabled ---
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase if not already initialized
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   // Setup local notifications for background processing
//   await NotificationService.instance.setupFlutterNotifications();
//
//   // Show the notification
//   await NotificationService.instance.showNotification(message);
// }
// document_management

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // --- Firebase disabled (not used currently) ---
  // // Initialize Firebase first
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   // logger.i('Firebase initialized successfully');
  // } catch (e) {
  //   logger.e('Firebase initialization failed: $e');
  // }
  //
  // // Initialize notification service after Firebase
  // try {
  //   await NotificationService.instance.initialize();
  //   // logger.i('Notification service initialized successfully');
  // } catch (e) {
  //   logger.e('Notification service initialization failed: $e');
  // }
  //
  // // Set background message handler AFTER Firebase initialization
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // ------------------------------------------------

  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      // extraAssetLoaders: const [TranslationsLoader()],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        // retry: (retryCount, error) => null,
        child: const ScreenUtilInitApp(),
      ),
    ),
  );
}

// flutter clean
// rm -Rf ios/Pods && rm -Rf ios/.symlinks && rm -Rf ios/Flutter/Flutter.framework && rm -Rf ios/Flutter/Flutter.podspec
// flutter pub get
// cd ios
// pod install
// arch -x86_64 pod install
// cd ..
// flutter build ios
// flutter run
