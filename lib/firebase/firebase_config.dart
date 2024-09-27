import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pitel_voip/voip_push/push_notif.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/authen/authentication_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import '../firebase_options.dart';
import 'notifi_local.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';

//todo android done. check bên ios check cả khi đg ở app có bị đẩy vào màn notification k
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
      print('getInitialMessage');
      _handelNotification(value);
    });
  }

  static void receiveFromBackgroundState(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((value) async {
      print('onMessageOpenedApp');
      _handelNotification(value);
    });
  }

  static _handelNotification(RemoteMessage? value, {bool isElse = true}) {
    if (value?.notification?.title == LOGOUT_NOTIFICATION) {
      logoutNotification();
    } else {
      if (isElse) AppNavigator.navigateNotification();
    }
  }

  static void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      PushNotifAndroid.handleNotification(message); // lib pitel
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        // trong app thì đây là màn hình login
        // xoá token check case logout
        UnreadNotificationBloc.of(context)
            .add(CheckNotification(isLoading: false));
        unawaited(
          NotificationLocalService().showNotification(
            id: notification.hashCode,
            title: notification.title ?? '',
            body: notification.body ?? '',
          ),
        );
        print('onMessage');
        _handelNotification(message, isElse: false);
      }
    });
  }

  // static Future<void> showNotificationForeground() async {
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: Platform.isAndroid, // Required to display a heads up notification
  //     badge: Platform.isAndroid,
  //     sound: Platform.isAndroid,
  //   );
  //   // docs truyền true nhưng khi sử dụng lib flutter_local_notifications thì phải chuyển nó về false
  // }

  static Future<String?> getTokenFcm() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  // static Future<void> deleteTokenFcm() async {
  //   await FirebaseMessaging.instance.deleteToken();
  // }

  static Future<void> initFireBase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  PushNotifAndroid.handleNotification(message);
  print(
      'firebaseMessagingBackgroundHandler---------${message.notification?.title ?? ''}');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      PreferencesKey.LOGOUT_STATUS, message.notification?.title ?? '');
}

logoutNotification() {
  AppNavigator.navigateLogout();
  AuthenticationBloc.of(Get.context!).add(
    AuthenticationLogoutRequested(),
  );
  LoginBloc.of(Get.context!).logout(Get.context!);
}

getActionServiceMessage(
  RemoteNotification? notification,
  TypeEvent typeEvent,
) {
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

class NotificationHandler {
  static const MethodChannel _channel =
      MethodChannel('com.yourapp/notifications');

  // Hàm lắng nghe dữ liệu từ native iOS
  static Future<void> handleNotification(Map<String, dynamic> message) async {
    // Xử lý dữ liệu nhận được từ thông báo
    print('Received notification data from iOS: $message');
  }

  // Lắng nghe từ native gọi vào Flutter
  static void init() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "notificationReceived") {
        // Gọi hàm xử lý khi nhận thông báo
        await handleNotification(call.arguments);
      }
    });
  }
}
