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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFS7y2UjhDkpGYb4z0hNL3p8t1zVZo65E',
    appId: '1:99143310321:android:d89b1b9ab325061392c250',
    messagingSenderId: '99143310321',
    projectId: 't-save-1f869',
    storageBucket: 't-save-1f869.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6H4Y0ZD9y-jETzqM0dS6F-1R_oMAqIms',
    appId: '1:99143310321:ios:ada6dc4189eeecfc92c250',
    messagingSenderId: '99143310321',
    projectId: 't-save-1f869',
    storageBucket: 't-save-1f869.appspot.com',
    androidClientId: '99143310321-5qpf6o20c7da04taoe8267vaqij2qltm.apps.googleusercontent.com',
    iosClientId: '99143310321-t7k0kt5730b5glloec3q4u0sp3qdlpv1.apps.googleusercontent.com',
    iosBundleId: 'com.tsaveuser.www',
  );
}
