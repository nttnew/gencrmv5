import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/l10n/l10n.dart';
import 'package:gen_crm/screens/call/init_app_call.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_step2_screen.dart';
import 'package:gen_crm/screens/menu/form/form_edit.dart';
import 'package:gen_crm/screens/menu/form/form_sign.dart';
import 'package:gen_crm/screens/menu/form/product_list/list_product.dart';
import 'package:gen_crm/screens/menu/form/update_contract.dart';
import 'package:gen_crm/screens/menu/form/add_note.dart';
import 'package:gen_crm/screens/menu/form/form_add_data.dart';
import 'package:gen_crm/screens/menu/home/notification/notification_screen.dart';
import 'package:gen_crm/screens/menu/home/product/detail_product.dart';
import 'package:gen_crm/screens/menu/home/product/product.dart';
import 'package:gen_crm/screens/menu/home/product_customer/detail_product_customer.dart';
import 'package:gen_crm/screens/menu/home/product_customer/product_customer.dart';
import 'package:gen_crm/screens/menu/home/report/report_screen.dart';
import 'package:gen_crm/screens/menu/form/checkin_screen.dart';
import 'package:get/get.dart';
import 'package:gen_crm/screens/forgot_password/forgot_password_otp_screen.dart';
import 'package:gen_crm/screens/screens.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'screens/menu/form/product_list/list_service_park.dart';
import 'screens/menu/home/customer/call_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _handleMessFirebase();
    super.initState();
  }

  _handleMessFirebase() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettings;
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'xxxx',
        importance: Importance.max,
      );
      var initializationSettingsAndroid =
          new AndroidInitializationSettings("@mipmap/ic_launcher");
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(channel);

      initializationSettings =
          new InitializationSettings(android: initializationSettingsAndroid);
    } else {
      var initializationSettingsIOS = new DarwinInitializationSettings();
      initializationSettings =
          new InitializationSettings(iOS: initializationSettingsIOS);
    }
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      GetNotificationBloc.of(context).add(CheckNotification());

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        if (Platform.isAndroid) {
          AndroidNotification? androidNotification =
              message.notification?.android;
          if (androidNotification != null) {
            var androidPlatformChannelSpecifics =
                const AndroidNotificationDetails(
              'high_importance_channel',
              'xxxx',
              importance: Importance.max,
              priority: Priority.max,
            );
            var platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics,
            );
            await flutterLocalNotificationsPlugin.show(
              0,
              notification.title,
              notification.body,
              platformChannelSpecifics,
              payload: 'test',
            );
          }
        } else if (Platform.isIOS) {
          var iOSChannelSpecifics = const DarwinNotificationDetails();
          var platformChannelSpecifics =
              NotificationDetails(iOS: iOSChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            platformChannelSpecifics,
            payload: 'test',
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [
          SystemUiOverlay.top,
        ],
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: COLORS.WHITE,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }
    return StreamBuilder<Locale>(
        stream: LoginBloc.of(context).locale,
        builder: (context, snapshot) {
          return GetMaterialApp(
            locale: snapshot.data,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'NunitoSans'),
            initialRoute: ROUTE_NAMES.SPLASH,
            getPages: [
              GetPage(
                name: ROUTE_NAMES.MAIN,
                page: () => InitCallApp(),
              ),
              GetPage(
                name: ROUTE_NAMES.SPLASH,
                page: () => SplashPage(),
              ),
              GetPage(
                name: ROUTE_NAMES.LOGIN,
                page: () => LoginScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.INFORMATION_ACCOUNT,
                page: () => InformationAccount(),
              ),
              GetPage(
                name: ROUTE_NAMES.CHANCE,
                page: () => ChanceScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.INFO_CHANCE,
                page: () => InfoChancePage(),
              ),
              GetPage(
                name: ROUTE_NAMES.CUSTOMER,
                page: () => CustomerScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.REPORT,
                page: () => ReportScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.PRODUCT,
                page: () => ProductScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.CLUE,
                page: () => ClueScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.INFO_CLUE,
                page: () => DetailInfoClue(),
              ),
              GetPage(
                name: ROUTE_NAMES.WORK,
                page: () => WorkScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.CONTRACT,
                page: () => ContractScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.DETAIL_WORK,
                page: () => DetailWorkScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.DETAIL_SUPPORT,
                page: () => DetailSupportScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.INFO_CONTRACT,
                page: () => DetailInfoContract(),
              ),
              GetPage(
                name: ROUTE_NAMES.ADD_CONTRACT,
                page: () => FormAddContract(),
              ),
              GetPage(
                name: ROUTE_NAMES.SUPPORT,
                page: () => SupportScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.ABOUT_US,
                page: () => AboutUsScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.POLICY,
                page: () => PolicyScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.CHANGE_PASSWORD,
                page: () => ChangePassWordPage(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORGOT_PASSWORD,
                page: () => ForgotPasswordScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORGOT_PASSWORD_OTP,
                page: () => ForgotPasswordOTPScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORGOT_PASSWORD_RESET,
                page: () => ForgotPasswordResetScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.DETAIL_CUSTOMER,
                page: () => DetailCustomerScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.ADD_CUSTOMER,
                page: () => AddCustomer(),
              ),
              GetPage(
                name: ROUTE_NAMES.ADD_SERVICE_VOUCHER_STEP_TWO,
                page: () => AddServiceVoucherStepTwoScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.NOTIFICATION,
                page: () => NotificationScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORM_ADD,
                page: () => FormAddData(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORM_ADD_CUSTOMER_GROUP,
                page: () => FormAddData(),
              ),
              GetPage(
                name: ROUTE_NAMES.FORM_EDIT,
                page: () => FormEdit(),
              ),
              GetPage(
                name: ROUTE_NAMES.ADD_NOTE,
                page: () => AddNote(),
              ),
              GetPage(
                name: ROUTE_NAMES.ADD_PRODUCT,
                page: () => ListProduct(),
              ),
              GetPage(
                name: ROUTE_NAMES.EDIT_CONTRACT,
                page: () => EditContract(),
              ),
              GetPage(
                name: ROUTE_NAMES.DETAIL_PRODUCT,
                page: () => DetailProductScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.CHECK_IN,
                page: () => CheckInScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.PRODUCT_CUSTOMER,
                page: () => ProductCustomerScreen(),
              ),
              GetPage(
                name: ROUTE_NAMES.DETAIL_PRODUCT_CUSTOMER,
                page: () => DetailProductCustomerScreen(),
              ),
              GetPage(name: ROUTE_NAMES.FORM_SIGN, page: () => FormAddSign()),
              GetPage(name: ROUTE_NAMES.CALL, page: () => CallScreen()),
              GetPage(
                  name: ROUTE_NAMES.LIST_SERVICE_PARK,
                  page: () => ListServicePark()),
            ],
          );
        });
  }
}
