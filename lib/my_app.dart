import 'package:flutter/material.dart';
import 'package:gen_crm/screens/call/init_app_call.dart';
import 'package:gen_crm/screens/add_service_voucher/add_service_voucher_step2_screen.dart';
import 'package:gen_crm/screens/menu/home/contract/list_product.dart';
import 'package:gen_crm/screens/menu/home/contract/update_contract.dart';
import 'package:gen_crm/screens/menu/home/customer/add_note.dart';
import 'package:gen_crm/screens/menu/home/customer/form_add_data.dart';
import 'package:gen_crm/screens/menu/home/customer/form_edit.dart';
import 'package:gen_crm/screens/menu/home/notification/notification_screen.dart';
import 'package:gen_crm/screens/menu/home/product/detail_product.dart';
import 'package:gen_crm/screens/menu/home/product/product.dart';
import 'package:gen_crm/screens/menu/home/report/report_screen.dart';
import 'package:get/get.dart';
import 'package:gen_crm/screens/forgot_password/forgot_password_otp_screen.dart';
import 'package:gen_crm/screens/screens.dart';
import 'package:gen_crm/src/src_index.dart';

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
          page: () => InfoCluePage(),
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
      ],
    );
  }
}
