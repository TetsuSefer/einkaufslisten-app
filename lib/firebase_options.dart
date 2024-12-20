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
    apiKey: 'AIzaSyAsXdIgr4-9OlkEKyF_6vwSK_QXXinQAXE',
    appId: '1:506622597688:web:882a34089c2985ad3c64cd',
    messagingSenderId: '506622597688',
    projectId: 'einkaufslisten-app-34fcf',
    authDomain: 'einkaufslisten-app-34fcf.firebaseapp.com',
    storageBucket: 'einkaufslisten-app-34fcf.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZ5ePJtC2BdJ3JtFRT2ZjgEFhn1At7se0',
    appId: '1:506622597688:android:a51a267124fa3bf53c64cd',
    messagingSenderId: '506622597688',
    projectId: 'einkaufslisten-app-34fcf',
    storageBucket: 'einkaufslisten-app-34fcf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVp7yKaABPi6pH6WiJWur22VGBQbGtTtc',
    appId: '1:506622597688:ios:e55c28f88639a3823c64cd',
    messagingSenderId: '506622597688',
    projectId: 'einkaufslisten-app-34fcf',
    storageBucket: 'einkaufslisten-app-34fcf.firebasestorage.app',
    iosBundleId: 'com.example.einkaufslistenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVp7yKaABPi6pH6WiJWur22VGBQbGtTtc',
    appId: '1:506622597688:ios:e55c28f88639a3823c64cd',
    messagingSenderId: '506622597688',
    projectId: 'einkaufslisten-app-34fcf',
    storageBucket: 'einkaufslisten-app-34fcf.firebasestorage.app',
    iosBundleId: 'com.example.einkaufslistenApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAsXdIgr4-9OlkEKyF_6vwSK_QXXinQAXE',
    appId: '1:506622597688:web:fe6bdeec8bb26f1d3c64cd',
    messagingSenderId: '506622597688',
    projectId: 'einkaufslisten-app-34fcf',
    authDomain: 'einkaufslisten-app-34fcf.firebaseapp.com',
    storageBucket: 'einkaufslisten-app-34fcf.firebasestorage.app',
  );
}
