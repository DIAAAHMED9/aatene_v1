import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyAUA1ODd2ooz_OmUwjcMq66K-VquWpoZbw',
    appId: '1:1026858119799:android:195b837011c6ecd0700c72',
    messagingSenderId: '1026858119799',
    projectId: 'aatene-36a8c',
    storageBucket: 'aatene-36a8c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArQfRmBJjhvZyxS69dngttwDskN18l7c4',
    appId: '1:1026858119799:ios:130e21d0b7dec66a700c72',
    messagingSenderId: '1026858119799',
    projectId: 'aatene-36a8c',
    storageBucket: 'aatene-36a8c.firebasestorage.app',
    androidClientId: '1026858119799-kduiqpgsleht4mraou1q2snbuftjo0q4.apps.googleusercontent.com',
    iosBundleId: 'com.aatene.mobile',
  );
}