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
    appId: '1:919391878723:web:9b5e1311086bee658b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    authDomain: 'still-chassis-382314.firebaseapp.com',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-9iKf_Lvn8Qpz_Ikv9t-MPiLUvR6EoDw',
    appId: '1:919391878723:android:3ba2edf03004878f8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTIIO86Wh4KWfoVR0YOviek6c5zKMqhnY',
    appId: '1:919391878723:ios:d5baa828206ab9ed8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
    iosClientId: '919391878723-01bcjk353n7gofpv4u7g9mvhqb7om4c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.dropsride',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTIIO86Wh4KWfoVR0YOviek6c5zKMqhnY',
    appId: '1:919391878723:ios:d5baa828206ab9ed8b1ef6',
    messagingSenderId: '919391878723',
    projectId: 'still-chassis-382314',
    databaseURL: 'https://still-chassis-382314-default-rtdb.firebaseio.com',
    storageBucket: 'still-chassis-382314.appspot.com',
    iosClientId: '919391878723-01bcjk353n7gofpv4u7g9mvhqb7om4c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.dropsride',
  );
}
