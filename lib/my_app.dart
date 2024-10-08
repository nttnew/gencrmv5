import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/call/init_app_call.dart';
import 'package:gen_crm/screens/in_phieu/in_phieu.dart';
import 'package:gen_crm/screens/main/list_bieu_mau.dart';
import 'package:gen_crm/screens/main/detail_car.dart';
import 'package:gen_crm/screens/form/form_sign.dart';
import 'package:gen_crm/screens/form/product_list/list_product.dart';
import 'package:gen_crm/screens/form/add_note.dart';
import 'package:gen_crm/screens/form/form_add_data.dart';
import 'package:gen_crm/screens/home/notification/notification_screen.dart';
import 'package:gen_crm/screens/home/product/detail_product.dart';
import 'package:gen_crm/screens/home/product/product.dart';
import 'package:gen_crm/screens/home/product_customer/detail_product_customer.dart';
import 'package:gen_crm/screens/home/product_customer/product_customer.dart';
import 'package:gen_crm/screens/home/report/report_screen.dart';
import 'package:gen_crm/screens/form/checkin_screen.dart';
import 'package:get/get.dart';
import 'package:gen_crm/screens/forgot_password/forgot_password_otp_screen.dart';
import 'package:gen_crm/screens/screens.dart';
import 'package:gen_crm/src/src_index.dart';
import 'firebase/firebase_config.dart';
import 'firebase/notifi_local.dart';
import 'screens/form/product_list/list_service_park.dart';
import 'screens/home/customer/call_screen.dart';
import 'storages/share_local.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    LoginBloc.of(context).getLanguage();
    _handleMessFirebase();
    super.initState();
  }

  _handleMessFirebase() async {
    NotificationLocalService()
        .initNotification(context); // notification local init
    FirebaseConfig.onMessage(context); // show mess on app
    FirebaseConfig.receiveFromBackgroundState(context); // show mess on app
    FirebaseConfig.onBackgroundPressed(); // show mess on app
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
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          trackColor: MaterialStateProperty.all(COLORS.LIGHT_GREY),
          thumbColor: MaterialStateProperty.all(
            COLORS.PRIMARY_COLOR1.withOpacity(
              0.7,
            ),
          ),
          radius: Radius.circular(1000),
        ),
        fontFamily: 'NunitoSans',
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      initialRoute: (shareLocal.getString(PreferencesKey.TOKEN) != '' &&
              shareLocal.getString(PreferencesKey.TOKEN) != null)
          ? ROUTE_NAMES.MAIN
          : ROUTE_NAMES.SPLASH,
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
          name: ROUTE_NAMES.NOTIFICATION,
          page: () => NotificationScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.FORM_ADD,
          page: () => FormAddData(),
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
        GetPage(
          name: ROUTE_NAMES.FORM_SIGN,
          page: () => FormAddSign(),
        ),
        GetPage(
          name: ROUTE_NAMES.CALL,
          page: () => CallGencrmScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.LIST_SERVICE_PARK,
          page: () => ListServicePark(),
        ),
        GetPage(
          name: ROUTE_NAMES.IN_PHIEU,
          page: () => InPhieuScreen(),
        ),
        GetPage(
          name: ROUTE_NAMES.DETAIL_CAR_MAIN,
          page: () => DetailCar(),
        ),
        GetPage(
          name: ROUTE_NAMES.LIST_BIEU_MAU,
          page: () => ListBieuMau(),
        ),
      ],
    );
  }
}
