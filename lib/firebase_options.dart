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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDpDKnIEEYwUCZx6Wxr_lCC1beKf6zLaRQ',
    appId: '1:191422405605:web:1d764cf8976d132a92ad0c',
    messagingSenderId: '191422405605',
    projectId: 'pbm-nebengbro',
    authDomain: 'pbm-nebengbro.firebaseapp.com',
    databaseURL: 'https://pbm-nebengbro-default-rtdb.firebaseio.com',
    storageBucket: 'pbm-nebengbro.appspot.com',
    measurementId: 'G-JNV7F7WK1R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDphLB_dTOFKvH4l4vOb2FqRUfvwvUERLw',
    appId: '1:191422405605:android:0f176fe8816805f492ad0c',
    messagingSenderId: '191422405605',
    projectId: 'pbm-nebengbro',
    databaseURL: 'https://pbm-nebengbro-default-rtdb.firebaseio.com',
    storageBucket: 'pbm-nebengbro.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvKg2nbBVa-awTtER_Ro5EFtFtwTa24Yo',
    appId: '1:191422405605:ios:c881141c3f47c5c292ad0c',
    messagingSenderId: '191422405605',
    projectId: 'pbm-nebengbro',
    databaseURL: 'https://pbm-nebengbro-default-rtdb.firebaseio.com',
    storageBucket: 'pbm-nebengbro.appspot.com',
    iosBundleId: 'com.example.nebengbroApps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvKg2nbBVa-awTtER_Ro5EFtFtwTa24Yo',
    appId: '1:191422405605:ios:c881141c3f47c5c292ad0c',
    messagingSenderId: '191422405605',
    projectId: 'pbm-nebengbro',
    databaseURL: 'https://pbm-nebengbro-default-rtdb.firebaseio.com',
    storageBucket: 'pbm-nebengbro.appspot.com',
    iosBundleId: 'com.example.nebengbroApps',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDpDKnIEEYwUCZx6Wxr_lCC1beKf6zLaRQ',
    appId: '1:191422405605:web:0ae54737c84bd78c92ad0c',
    messagingSenderId: '191422405605',
    projectId: 'pbm-nebengbro',
    authDomain: 'pbm-nebengbro.firebaseapp.com',
    databaseURL: 'https://pbm-nebengbro-default-rtdb.firebaseio.com',
    storageBucket: 'pbm-nebengbro.appspot.com',
    measurementId: 'G-H3RXZPK4GV',
  );
}
