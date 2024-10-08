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
    apiKey: 'AIzaSyCnVCWrIly59WNc8kyIOxW3XmZuq5IjM5U',
    appId: '1:506385792495:web:e5f24418aeb176d4340a1a',
    messagingSenderId: '506385792495',
    projectId: 'chatting-app-d86e1',
    authDomain: 'chatting-app-d86e1.firebaseapp.com',
    storageBucket: 'chatting-app-d86e1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBChj32GyIpy_YyFsucjZrO_JO-lRmHwW8',
    appId: '1:506385792495:android:ef0047815486c58b340a1a',
    messagingSenderId: '506385792495',
    projectId: 'chatting-app-d86e1',
    storageBucket: 'chatting-app-d86e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfoMdztPvbD2YJLHlnm5bHlR8ZXtPy2Dw',
    appId: '1:506385792495:ios:129266221c35ace4340a1a',
    messagingSenderId: '506385792495',
    projectId: 'chatting-app-d86e1',
    storageBucket: 'chatting-app-d86e1.appspot.com',
    iosBundleId: 'com.example.chattingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfoMdztPvbD2YJLHlnm5bHlR8ZXtPy2Dw',
    appId: '1:506385792495:ios:129266221c35ace4340a1a',
    messagingSenderId: '506385792495',
    projectId: 'chatting-app-d86e1',
    storageBucket: 'chatting-app-d86e1.appspot.com',
    iosBundleId: 'com.example.chattingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCnVCWrIly59WNc8kyIOxW3XmZuq5IjM5U',
    appId: '1:506385792495:web:ad56e884f13655dd340a1a',
    messagingSenderId: '506385792495',
    projectId: 'chatting-app-d86e1',
    authDomain: 'chatting-app-d86e1.firebaseapp.com',
    storageBucket: 'chatting-app-d86e1.appspot.com',
  );
}
