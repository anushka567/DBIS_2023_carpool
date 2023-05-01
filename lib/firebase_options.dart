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
    apiKey: 'AIzaSyBAi6YI2bEhnhDO0ti316ahoY05x7gdC9c',
    appId: '1:607974461298:web:714a0a038583c4586e57eb',
    messagingSenderId: '607974461298',
    projectId: 'cabshare-d219c',
    authDomain: 'cabshare-d219c.firebaseapp.com',
    databaseURL: 'https://cabshare-d219c-default-rtdb.firebaseio.com',
    storageBucket: 'cabshare-d219c.appspot.com',
    measurementId: 'G-NW88KS42MK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAldxyGH9SCHjQooSzNPegPUSBt-43wOK8',
    appId: '1:607974461298:android:88f335b314ea861f6e57eb',
    messagingSenderId: '607974461298',
    projectId: 'cabshare-d219c',
    databaseURL: 'https://cabshare-d219c-default-rtdb.firebaseio.com',
    storageBucket: 'cabshare-d219c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSGVWx9fAn9ViUPFKhgvN_f8kq4A2U8wE',
    appId: '1:607974461298:ios:42322d95ea65695e6e57eb',
    messagingSenderId: '607974461298',
    projectId: 'cabshare-d219c',
    databaseURL: 'https://cabshare-d219c-default-rtdb.firebaseio.com',
    storageBucket: 'cabshare-d219c.appspot.com',
    iosClientId: '607974461298-bi9ajaaesrbln8nt0b5mt15ld3d2rg33.apps.googleusercontent.com',
    iosBundleId: 'com.example.cabshare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSGVWx9fAn9ViUPFKhgvN_f8kq4A2U8wE',
    appId: '1:607974461298:ios:42322d95ea65695e6e57eb',
    messagingSenderId: '607974461298',
    projectId: 'cabshare-d219c',
    databaseURL: 'https://cabshare-d219c-default-rtdb.firebaseio.com',
    storageBucket: 'cabshare-d219c.appspot.com',
    iosClientId: '607974461298-bi9ajaaesrbln8nt0b5mt15ld3d2rg33.apps.googleusercontent.com',
    iosBundleId: 'com.example.cabshare',
  );
}
