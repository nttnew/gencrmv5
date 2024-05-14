import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../src/navigator.dart';
import 'notifi_local.dart';

class FirebaseConfig {
  static Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  static void onBackgroundPressed() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static void getInitialMessage(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      // if (value != null) {
      //   context.router.push(const NotiRoute());
      // }
    });
  }

  static void receiveFromBackgroundState(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((value) async {
      AppNavigator.navigateNotification();
    });
  }

  static void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
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
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
