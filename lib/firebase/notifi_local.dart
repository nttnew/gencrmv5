import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationLocalService {
  static final NotificationLocalService _notificationService =
      NotificationLocalService._internal();

  factory NotificationLocalService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationLocalService._internal();

  Future<void> initNotification(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        print(13);
      },
    );

    final InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        // await context.router.push(const NotiRoute());
      },
    );
  }

  Future<void> createChanel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'coral_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? path,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            styleInformation: BigTextStyleInformation(body),
            actions: <AndroidNotificationAction>[
          AndroidNotificationAction('click', 'alo')
        ]);

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      ),
      payload: payload,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
