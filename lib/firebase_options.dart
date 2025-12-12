import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_ANDROID_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_PROJECT_ID.appspot.com',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_IOS_API_KEY',
          appId: 'YOUR_IOS_APP_ID',
          messagingSenderId: 'YOUR_IOS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_PROJECT_ID.appspot.com',
          iosBundleId: 'com.example.beastLiftingAppTrial',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_MACOS_API_KEY',
          appId: 'YOUR_MACOS_APP_ID',
          messagingSenderId: 'YOUR_MACOS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_PROJECT_ID.appspot.com',
        );
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return const FirebaseOptions(
          apiKey: 'YOUR_OTHER_API_KEY',
          appId: 'YOUR_OTHER_APP_ID',
          messagingSenderId: 'YOUR_OTHER_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_PROJECT_ID.appspot.com',
        );
    }
  }
}
