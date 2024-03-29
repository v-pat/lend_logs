// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC7BRX5-vdNEYnic9zP56WoFGLv4pqb-OE',
    appId: '1:899619484226:web:e9ffc47bf268dde6e2f3db',
    messagingSenderId: '899619484226',
    projectId: 'pay-logs-vpat',
    authDomain: 'pay-logs-vpat.firebaseapp.com',
    storageBucket: 'pay-logs-vpat.appspot.com',
    measurementId: 'G-VX40V63TBR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnXwPmDXTr3qB-W38UsisWHuXIHVcz3oU',
    appId: '1:899619484226:android:270e7753ab99e1cbe2f3db',
    messagingSenderId: '899619484226',
    projectId: 'pay-logs-vpat',
    storageBucket: 'pay-logs-vpat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFYCy4ngbJXzqGwDFtRc-rxhLqHGUNUn0',
    appId: '1:899619484226:ios:7c8d8752b9ddb4e6e2f3db',
    messagingSenderId: '899619484226',
    projectId: 'pay-logs-vpat',
    storageBucket: 'pay-logs-vpat.appspot.com',
    iosBundleId: 'com.example.lendLogs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFYCy4ngbJXzqGwDFtRc-rxhLqHGUNUn0',
    appId: '1:899619484226:ios:7c8d8752b9ddb4e6e2f3db',
    messagingSenderId: '899619484226',
    projectId: 'pay-logs-vpat',
    storageBucket: 'pay-logs-vpat.appspot.com',
    iosBundleId: 'com.example.lendLogs',
  );
}
