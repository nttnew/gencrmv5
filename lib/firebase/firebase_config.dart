import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pitel_voip/voip_push/push_notif.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../firebase_options.dart';
import '../src/navigator.dart';
import 'notifi_local.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';

class FirebaseConfig {
  static Future<void> requestPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      // Nếu ứng dụng chưa được cấp quyền, yêu cầu quyền nhận thông báo
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
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
        UnreadNotificationBloc.of(context)
            .add(CheckNotification(isLoading: false));
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
