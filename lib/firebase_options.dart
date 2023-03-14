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
    apiKey: 'AIzaSyCNhe6xBvKCYxrwTPqHSTDHIsvqt9bi8y4',
    appId: '1:154364759188:web:6823c0fc3d69ff8768f881',
    messagingSenderId: '154364759188',
    projectId: 'assessments-app-o3',
    authDomain: 'assessments-app-o3.firebaseapp.com',
    storageBucket: 'assessments-app-o3.appspot.com',
    measurementId: 'G-ZNRL9DDLK8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeCPpnH0iIRT3IAs4kkid0AyWpRD-I4cA',
    appId: '1:154364759188:android:b04e79962db73a5c68f881',
    messagingSenderId: '154364759188',
    projectId: 'assessments-app-o3',
    storageBucket: 'assessments-app-o3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzaRlNsgokkYmLcmCs0xYSYXtXzWWo4V8',
    appId: '1:154364759188:ios:a8ec44142c38916768f881',
    messagingSenderId: '154364759188',
    projectId: 'assessments-app-o3',
    storageBucket: 'assessments-app-o3.appspot.com',
    iosClientId: '154364759188-r7lfq7lca4os74hiqt62cs7brks8emk2.apps.googleusercontent.com',
    iosBundleId: 'com.example.assessmentsApp',
  );
}
