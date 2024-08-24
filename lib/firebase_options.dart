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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCs86SR9xGuGlDmpPmT_auuYF04rR6F_Tc',
    appId: '1:459876047401:web:f243cb076d6c53aba55a38',
    messagingSenderId: '459876047401',
    projectId: 'rideramani-ba3ff',
    authDomain: 'rideramani-ba3ff.firebaseapp.com',
    storageBucket: 'rideramani-ba3ff.appspot.com',
    measurementId: 'G-CBVJYD8F36',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB45g-778tRJf3buOeHrpztGOW4mPr3kNQ',
    appId: '1:459876047401:android:6ec7e54ce4961fc9a55a38',
    messagingSenderId: '459876047401',
    projectId: 'rideramani-ba3ff',
    storageBucket: 'rideramani-ba3ff.appspot.com',
  );
}
