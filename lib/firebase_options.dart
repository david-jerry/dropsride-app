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
    apiKey: 'AIzaSyDkWYlsvlC0gpITUFGrSWgkaHwlKFZdBKY',
    appId: '1:919391878723:web:7ce6e586112a1d0a8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    authDomain: 'still-chassis-382314.firebaseapp.com',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-9iKf_Lvn8Qpz_Ikv9t-MPiLUvR6EoDw',
    appId: '1:919391878723:android:f4db0b8672867e7b8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTIIO86Wh4KWfoVR0YOviek6c5zKMqhnY',
    appId: '1:919391878723:ios:7fabebc515d4959a8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
    androidClientId: '919391878723-maktt4idgj0acn2ftq69d3lk07rotjds.apps.googleusercontent.com',
    iosClientId: '919391878723-i7qfqdha9tdkuf6kd05m2t7qd316eaio.apps.googleusercontent.com',
    iosBundleId: 'com.dropsride.apple',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTIIO86Wh4KWfoVR0YOviek6c5zKMqhnY',
    appId: '1:919391878723:ios:7fabebc515d4959a8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
    androidClientId: '919391878723-maktt4idgj0acn2ftq69d3lk07rotjds.apps.googleusercontent.com',
    iosClientId: '919391878723-i7qfqdha9tdkuf6kd05m2t7qd316eaio.apps.googleusercontent.com',
    iosBundleId: 'com.dropsride.apple',
  );
}
