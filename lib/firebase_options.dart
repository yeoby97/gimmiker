// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyALAeNeYuXq18KhRlOXP6WJ5O1kEbLysoU',
    appId: '1:1094957991619:web:27cf05a4aec4b0d7584476',
    messagingSenderId: '1094957991619',
    projectId: 'spacecloud-5dde5',
    authDomain: 'spacecloud-5dde5.firebaseapp.com',
    storageBucket: 'spacecloud-5dde5.firebasestorage.app',
    measurementId: 'G-KEDXPW1N39',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAnWXYDvZQdH_TAbd834KvJ9vnpXLLk64',
    appId: '1:1094957991619:android:525ca9d1e38a8214584476',
    messagingSenderId: '1094957991619',
    projectId: 'spacecloud-5dde5',
    storageBucket: 'spacecloud-5dde5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaK62wxJoZU59CzwT4QaaHLoh3BC25fhw',
    appId: '1:1094957991619:ios:81c920277cd2b189584476',
    messagingSenderId: '1094957991619',
    projectId: 'spacecloud-5dde5',
    storageBucket: 'spacecloud-5dde5.firebasestorage.app',
    androidClientId: '1094957991619-1f7gs03uaduiq8ch0mfsj798kiqm1v0u.apps.googleusercontent.com',
    iosClientId: '1094957991619-nqqcv6dkcabu6p7d6tkeuv6h7g8ppe8v.apps.googleusercontent.com',
    iosBundleId: 'com.example.gimmiker',
  );
}
