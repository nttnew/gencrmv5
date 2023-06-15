import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:

      case TargetPlatform.windows:

      case TargetPlatform.linux:

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgOjAw2nFu0pwNO2zSjtr7QzTR2dTdJIg',
    appId: '1:476014117271:android:cc7e37aac88f2a150e04d2',
    messagingSenderId: '476014117271',
    projectId: 'carcrm-57969',
    storageBucket: 'carcrm-57969.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMS_Nc3IuLqJ0AT3z60qShKbfcFWUOiwg',
    appId: '1:476014117271:ios:8178c58c3187dd540e04d2',
    messagingSenderId: '476014117271',
    projectId: 'carcrm-57969',
    storageBucket: 'carcrm-57969.appspot.com',
    androidClientId:
        'com.googleusercontent.apps.476014117271-n4nt418nd9sjlv20706i7mbivtd3b90g',
    iosClientId:
        '476014117271-n4nt418nd9sjlv20706i7mbivtd3b90g.apps.googleusercontent.com',
    iosBundleId: 'com.carcrm',
  );
}
