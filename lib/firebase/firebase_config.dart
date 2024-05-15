import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pitel_voip/voip_push/push_notif.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../firebase_options.dart';
import '../src/navigator.dart';
import 'notifi_local.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';

class FirebaseConfig {
  static Future<void> requestPermission() async {
    // await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
  }

  static void onBackgroundPressed() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static void getInitialMessage(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      //
    });
  }

  static void receiveFromBackgroundState(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((value) async {
      AppNavigator.navigateNotification();
    });
  }

  static void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      PushNotifAndroid.handleNotification(message); // lib pitel
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        GetNotificationBloc.of(context).add(CheckNotification());
        unawaited(
          NotificationLocalService().showNotification(
            id: notification.hashCode,
            title: notification.title ?? '',
            body: notification.body ?? '',
          ),
        );
      }
    });
  }

  static Future<void> showNotificationForeground() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: Platform.isAndroid, // Required to display a heads up notification
      badge: Platform.isAndroid,
      sound: Platform.isAndroid,
    );
    // docs truyền true nhưng khi sử dụng lib flutter_local_notifications thì phải chuyển nó về false
  }

  static Future<String?> getTokenFcm() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  static Future<void> deleteTokenFcm() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  static Future<void> initFireBase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  PushNotifAndroid.handleNotification(message); // lib pitel
}

void getActionSeviceMessage(
    RemoteNotification? notification, TypeEvent typeEvent) {
  switch (typeEvent) {
    case TypeEvent.COLLABORATOR_UPDATE:
      return;
    case TypeEvent.EVENT_UPDATE:
      return;
    case TypeEvent.FEATURE_UPDATE:
      return;
    case TypeEvent.PROMOTION_UPDATE:
      return;
    case TypeEvent.SYSTEM:
      return;
    default:
      return;
  }
}

enum TypeEvent {
  SYSTEM,
  EVENT_UPDATE,
  FEATURE_UPDATE,
  PROMOTION_UPDATE,
  COLLABORATOR_UPDATE
}

// import 'dart:convert';
// import 'dart:io' show Platform;
//
// import 'package:eraser/eraser.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_callkit_incoming_timer/flutter_callkit_incoming.dart';
// import 'package:flutter_pitel_voip/pitel_sdk/pitel_client.dart';
// import 'package:flutter_pitel_voip/services/models/pn_push_params.dart';
// import 'package:flutter_pitel_voip/services/sip_info_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'android_connection_service.dart';
//
// class PushNotifAndroid {
//   static initFirebase({
//     FirebaseOptions? options,
//     Function(RemoteMessage message)? onMessage,
//     Function(RemoteMessage message)? onMessageOpenedApp,
//     Function(RemoteMessage message)? onBackgroundMessage,
//   }) async {
// //   await Firebase.initializeApp(
// //       options: options,
// //      );
// //  FirebaseMessaging messaging = FirebaseMessaging.instance;
// //
// //     await messaging.requestPermission(
// //       alert: true,             // vào push_notif.dart của lib pitel để đóng 2 func sau để handel notif
// //       announcement: false,
// //       badge: true,
// //       carPlay: false,
// //       criticalAlert: false,
// //       provisional: false,
// //       sound: true,
// //     );
// //
// //     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
// //       if (onBackgroundMessage != null) {
// //         onBackgroundMessage(message);
// //       }
// //       return firebaseMessagingBackgroundHandler(message);
// //     });
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //      handleNotification(message);
// //      if (onMessage != null) {
// //        onMessage(message);
// //      }
// //    });
// //    FirebaseMessaging.onMessageOpenedApp.listen((message) {
// //      if (onMessageOpenedApp != null) {
// //        onMessageOpenedApp(message);
// //      }
// //     });
//   }
//
//   static Future<String> getDeviceToken() async {
//     final FirebaseMessaging fcm = FirebaseMessaging.instance;
//     var deviceToken = "";
//     try {
//       final token = await fcm.getToken();
//       deviceToken = token.toString();
//     } catch (error) {
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//     return deviceToken;
//   }
//
//   @pragma('vm:entry-point')
//   static Future<void> firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     handleNotification(message);
//   }
//
//   static Future<void> handleNotification(RemoteMessage message) async {
//     switch (message.data['callType']) {
//       case "RE_REGISTER":
//         await registerWhenReceiveNotif();
//         break;
//       case "CANCEL_ALL":
//       case "CANCEL_GROUP":
//         FlutterCallkitIncoming.endAllCalls();
//         Eraser.clearAllAppNotifications();
//         break;
//       case "CALL":
//         handleShowCallKit(message);
//         break;
//       default:
//         break;
//     }
//   }
//
//   static void handleShowCallKit(RemoteMessage message) {
//     AndroidConnectionService.showCallkitIncoming(CallkitParamsModel(
//       uuid: message.messageId ?? '',
//       nameCaller: message.data['nameCaller'] ?? '',
//       avatar: message.data['avatar'] ?? '',
//       phoneNumber: message.data['phoneNumber'] ?? '',
//       appName: message.data['appName'] ?? '',
//       backgroundColor: message.data['backgroundColor'] ?? '#0955fa',
//     ));
//   }
//
//   static Future<void> registerWhenReceiveNotif() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? sipInfoData = prefs.getString("SIP_INFO_DATA");
//     final String? pnPushParams = prefs.getString("PN_PUSH_PARAMS");
//
//     final SipInfoData? sipInfoDataDecode = sipInfoData != null
//         ? SipInfoData.fromJson(jsonDecode(sipInfoData))
//         : null;
//     final PnPushParams? pnPushParamsDecode = pnPushParams != null
//         ? PnPushParams.fromJson(jsonDecode(pnPushParams))
//         : null;
//
//     if (sipInfoDataDecode != null && pnPushParamsDecode != null) {
//       final pitelClient = PitelClient.getInstance();
//       pitelClient.setExtensionInfo(sipInfoDataDecode.toGetExtensionResponse());
//       pitelClient.registerSipWithoutFCM(pnPushParamsDecode);
//     }
//   }
// }
//
// class VoipPushIOS {
//   static Future<String> getVoipDeviceToken() async {
//     return await FlutterCallkitIncoming.getDevicePushTokenVoIP();
//   }
// }
//
// class PushVoipNotif {
//   static Future<String> getDeviceToken() async {
//     final deviceToken = Platform.isAndroid
//         ? await PushNotifAndroid.getDeviceToken()
//         : await VoipPushIOS.getVoipDeviceToken();
//     return deviceToken;
//   }
//
//   static Future<String> getFCMToken() async {
//     final fcmToken = await PushNotifAndroid.getDeviceToken();
//     return fcmToken;
//   }
// }
