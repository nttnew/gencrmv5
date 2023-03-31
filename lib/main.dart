import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gen_crm/bloc/add_job_chance/add_job_chance_bloc.dart';
import 'package:gen_crm/bloc/add_service_voucher/add_service_bloc.dart';
import 'package:gen_crm/bloc/chance_customer/chance_customer_bloc.dart';
import 'package:gen_crm/bloc/clue_customer/clue_customer_bloc.dart';
import 'package:gen_crm/bloc/contact_by_customer/contact_by_customer_bloc.dart';
import 'package:gen_crm/bloc/contract/attack_bloc.dart';
import 'package:gen_crm/bloc/contract/contract_bloc.dart';
import 'package:gen_crm/bloc/contract/detail_contract_bloc.dart';
import 'package:gen_crm/bloc/contract/total_bloc.dart';
import 'package:gen_crm/bloc/detail_customer/detail_customer_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/add_data_bloc.dart';
import 'package:gen_crm/bloc/form_add_data/form_add_data_bloc.dart';
import 'package:gen_crm/bloc/get_infor_acc/get_infor_acc_bloc.dart';
import 'package:gen_crm/bloc/form_edit/form_edit_bloc.dart';
import 'package:gen_crm/bloc/infor/infor_bloc.dart';
import 'package:gen_crm/bloc/information_account/information_account_bloc.dart';
import 'package:gen_crm/bloc/job_customer/job_customer_bloc.dart';
import 'package:gen_crm/bloc/list_note/add_note_bloc.dart';
import 'package:gen_crm/bloc/note_clue/note_clue_bloc.dart';
import 'package:gen_crm/bloc/payment_contract/payment_contract_bloc.dart';
import 'package:gen_crm/bloc/policy/policy_bloc.dart';
import 'package:gen_crm/bloc/product/product_bloc.dart';
import 'package:gen_crm/bloc/report/report_general/report_general_bloc.dart';
import 'package:gen_crm/bloc/unread_list_notification/unread_list_notifi_bloc.dart';
import 'package:gen_crm/bloc/support/detail_support_bloc.dart';
import 'package:gen_crm/bloc/support/support_bloc.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_screen.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_step2_screen.dart';
import 'package:gen_crm/screens/menu/home/contract/list_product.dart';
import 'package:gen_crm/screens/menu/home/contract/update_contract.dart';
import 'package:gen_crm/screens/menu/home/customer/add_note.dart';

import 'package:gen_crm/screens/menu/home/customer/form_add_data.dart';
import 'package:gen_crm/screens/menu/home/customer/form_edit.dart';
import 'package:gen_crm/screens/menu/home/notification/notification_screen.dart';
import 'package:gen_crm/screens/menu/home/report/report_screen.dart';
import 'package:gen_crm/test.dart';
import 'package:get/get.dart';
import 'package:gen_crm/screens/forgot_password/forgot_password_otp_screen.dart';
import 'package:gen_crm/screens/screens.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';
import 'package:vibration/vibration.dart';
import 'api_resfull/api.dart';
import 'bloc/add_customer/add_customer_bloc.dart';
import 'bloc/blocs.dart';
import 'bloc/clue/clue_bloc.dart';
import 'bloc/contract/customer_contract_bloc.dart';
import 'bloc/contract/phone_bloc.dart';
import 'bloc/contract_customer/contract_customer_bloc.dart';
import 'bloc/detail_clue/detail_clue_bloc.dart';
import 'bloc/job_contract/job_contract_bloc.dart';
import 'bloc/list_note/list_note_bloc.dart';
import 'bloc/readed_list_notification/readed_list_notifi_bloc.dart';
import 'bloc/report/report_contact/report_contact_bloc.dart';
import 'bloc/report/report_employee/report_employee_bloc.dart';
import 'bloc/report/report_option/option_bloc.dart';
import 'bloc/report/report_option/report_bloc.dart';
import 'bloc/report/report_product/report_product_bloc.dart';
import 'bloc/support_contract_bloc/support_contract_bloc.dart';
import 'bloc/support_customer/support_customer_bloc.dart';
import 'bloc/work/detail_work_bloc.dart';
import 'bloc/work/work_bloc.dart';
import 'bloc/work_clue/work_clue_bloc.dart';
import 'firebase_options.dart';

import 'screens/menu/attachment/attachment.dart';

Future main() async {
  Bloc.observer = SimpleBlocObserver();
  await dotenv.load(fileName: BASE_URL.ENV);
  shareLocal = await ShareLocal.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  UserRepository userRepository = UserRepository();
  await Firebase.initializeApp(
    name: "app",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettings;
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', 'xxxx',
        importance: Importance.max);
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
    RemoteNotification notification = message.notification!;

    if (notification != null) {
      if (Platform.isAndroid) {
        AndroidNotification androidNotification =
            message.notification!.android!;
        if (androidNotification != null) {
          var androidPlatformChannelSpecifics =
              const AndroidNotificationDetails(
                  'high_importance_channel', 'xxxx',
                  importance: Importance.max,
                  playSound: true,
                  showProgress: true,
                  priority: Priority.high,
                  ticker: 'test ticker');

          var iOSChannelSpecifics = const DarwinNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: iOSChannelSpecifics);
          Vibration.vibrate(duration: 1000, amplitude: 128);
          await flutterLocalNotificationsPlugin.show(0, notification.title,
              notification.body, platformChannelSpecifics,
              payload: 'test');
        }
      } else if (Platform.isIOS) {
        var iOSChannelSpecifics = const DarwinNotificationDetails();
        var platformChannelSpecifics =
            NotificationDetails(iOS: iOSChannelSpecifics);
        Vibration.vibrate(duration: 1000, amplitude: 128);
        await flutterLocalNotificationsPlugin.show(
            0, notification.title, notification.body, platformChannelSpecifics,
            payload: 'test');
      }
    } else {}
  });
  if (defaultTargetPlatform == TargetPlatform.android) {}
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
            localRepository: const EventRepositoryStorage(),
          )..add(AuthenticationStateInit()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              userRepository: userRepository,
              localRepository: const EventRepositoryStorage(),
            ),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (context) => ChangePasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ForgotPasswordOTPBloc>(
            create: (context) => ForgotPasswordOTPBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ResetPasswordBloc>(
            create: (context) => ResetPasswordBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ResendOTPBloc>(
            create: (context) => ResendOTPBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider<InfoUserBloc>(
            create: (context) => InfoUserBloc(
                userRepository: userRepository,
                localRepository: const EventRepositoryStorage(),
                context: context),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListCustomerBloc>(
            create: (context) =>
                GetListCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListChanceBloc>(
            create: (context) =>
                GetListChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportProductBloc>(
            create: (context) =>
                ReportProductBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportSelectProductBloc>(
            create: (context) =>
                ReportSelectProductBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListDetailChanceBloc>(
            create: (context) =>
                GetListDetailChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<GetJobChanceBloc>(
            create: (context) =>
                GetJobChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailCustomerBloc>(
            create: (context) =>
                DetailCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<ClueCustomerBloc>(
            create: (context) =>
                ClueCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<ChanceCustomerBloc>(
            create: (context) =>
                ChanceCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<ContractCustomerBloc>(
            create: (context) =>
                ContractCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<JobCustomerBloc>(
            create: (context) =>
                JobCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<AddJobChanceBloc>(
            create: (context) =>
                AddJobChanceBloc(userRepository: userRepository),
          ),
          BlocProvider<SupportCustomerBloc>(
            create: (context) =>
                SupportCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<ContractBloc>(
            create: (context) => ContractBloc(userRepository: userRepository),
          ),
          BlocProvider<AddCustomerBloc>(
            create: (context) =>
                AddCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListClueBloc>(
            create: (context) =>
                GetListClueBloc(userRepository: userRepository),
          ),
          BlocProvider<GetDetailClueBloc>(
            create: (context) =>
                GetDetailClueBloc(userRepository: userRepository),
          ),
          BlocProvider<WorkClueBloc>(
            create: (context) => WorkClueBloc(userRepository: userRepository),
          ),
          BlocProvider<GetPolicyBloc>(
            create: (context) => GetPolicyBloc(userRepository: userRepository),
          ),
          BlocProvider<GetInforBloc>(
              create: (context) =>
                  GetInforBloc(userRepository: userRepository)),
          //Dương
          BlocProvider<FormAddBloc>(
            create: (context) => FormAddBloc(userRepository: userRepository),
          ),
          BlocProvider<AddDataBloc>(
            create: (context) => AddDataBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailContractBloc>(
            create: (context) =>
                DetailContractBloc(userRepository: userRepository),
          ),
          BlocProvider<WorkBloc>(
            create: (context) => WorkBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailWorkBloc>(
            create: (context) => DetailWorkBloc(userRepository: userRepository),
          ),
          BlocProvider<GetNoteClueBloc>(
            create: (context) =>
                GetNoteClueBloc(userRepository: userRepository),
          ),
          BlocProvider<InforAccBloc>(
            create: (context) => InforAccBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListUnReadNotifiBloc>(
            create: (context) =>
                GetListUnReadNotifiBloc(userRepository: userRepository),
          ),
          BlocProvider<GetListReadedNotifiBloc>(
            create: (context) =>
                GetListReadedNotifiBloc(userRepository: userRepository),
          ),
          BlocProvider<GetInforAccBloc>(
            create: (context) =>
                GetInforAccBloc(userRepository: userRepository),
          ),

          BlocProvider<SupportBloc>(
            create: (context) => SupportBloc(userRepository: userRepository),
          ),
          BlocProvider<DetailSupportBloc>(
            create: (context) =>
                DetailSupportBloc(userRepository: userRepository),
          ),
          BlocProvider<FormEditBloc>(
            create: (context) => FormEditBloc(userRepository: userRepository),
          ),
          BlocProvider<CustomerContractBloc>(
            create: (context) =>
                CustomerContractBloc(userRepository: userRepository),
          ),
          BlocProvider<ListNoteBloc>(
            create: (context) => ListNoteBloc(userRepository: userRepository),
          ),
          BlocProvider<AddNoteBloc>(
            create: (context) => AddNoteBloc(userRepository: userRepository),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(userRepository: userRepository),
          ),
          BlocProvider<ContactByCustomerBloc>(
            create: (context) =>
                ContactByCustomerBloc(userRepository: userRepository),
          ),
          BlocProvider<TotalBloc>(
            create: (context) => TotalBloc(userRepository: userRepository),
          ),
          BlocProvider<AttackBloc>(
            create: (context) => AttackBloc(userRepository: userRepository),
          ),
          BlocProvider<PhoneBloc>(
            create: (context) => PhoneBloc(userRepository: userRepository),
          ),
          BlocProvider<PaymentContractBloc>(
            create: (context) =>
                PaymentContractBloc(userRepository: userRepository),
          ),
          BlocProvider<SupportContractBloc>(
            create: (context) =>
                SupportContractBloc(userRepository: userRepository),
          ),
          BlocProvider<OptionBloc>(
            create: (context) => OptionBloc(userRepository: userRepository),
          ),
          BlocProvider<JobContractBloc>(
            create: (context) =>
                JobContractBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportEmployeeBloc>(
            create: (context) =>
                ReportEmployeeBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportBloc>(
            create: (context) => ReportBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportContactBloc>(
            create: (context) =>
                ReportContactBloc(userRepository: userRepository),
          ),
          BlocProvider<ReportGeneralBloc>(
            create: (context) =>
                ReportGeneralBloc(userRepository: userRepository),
          ),
          BlocProvider<ServiceVoucherBloc>(
            create: (context) =>
                ServiceVoucherBloc(userRepository: userRepository),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NunitoSans'),
      title: MESSAGES.APP_TITLE,
      initialRoute: ROUTE_NAMES.SPLASH,
      getPages: [
        GetPage(
          name: ROUTE_NAMES.MAIN,
          page: () => ScreenMain(),
        ),
        GetPage(
          name: ROUTE_NAMES.test,
          page: () => Test(),
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
        // GetPage(
        //   name: ROUTE_NAMES.ADD_CHANCE,
        //   page: () => AddChanceScreen(),
        // ),
        GetPage(
          name: ROUTE_NAMES.CUSTOMER,
          page: () => CustomerScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.REPORT,
          page: () => ReportScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.CLUE,
          page: () => ClueScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.INFO_CLUE,
          page: () => InfoCluePage(),
        ),
        // GetPage(
        //   name: ROUTE_NAMES.ADD_CLUE,
        //   page: () => AddClueScreen(),
        // ),
        GetPage(
          name: ROUTE_NAMES.WORK,
          page: () => WorkScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.CONTRACT,
          page: () => ContractScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.DETAILWORK,
          page: () => DetailWorkScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.DETAILSUPPORT,
          page: () => DetailSupportScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.INFO_CONTRACT,
          page: () => InfoContractPage(),
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
          name: ROUTE_NAMES.DETAILCUSTOMER,
          page: () => DetailCustomerScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.ADDCUSTOMER,
          page: () => AddCustomer(),
        ),
        GetPage(
          name: ROUTE_NAMES.ADDSERVICEVOUCHER,
          page: () => AddServiceVoucherScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.ADDSERVICEVOUCHERSTEPTWO,
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
          name: ROUTE_NAMES.ATTACHMENT,
          page: () => Attachment(),
        ),
      ],
    );
  }
}
