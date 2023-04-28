import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gen_crm/src/preferences_key.dart';
import 'package:get/get.dart';
import 'package:plugin_pitel/services/models/pn_push_params.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import '../bloc/login/login_bloc.dart';
import '../storages/share_local.dart';
import '../widgets/widget_dialog.dart';
import 'base.dart';
import 'color.dart';
import 'messages.dart';
import 'navigator.dart';

const int IS_AFTER = 1;
const int IS_BEFORE = 0;
const String BUNDLE_ID = 'com.gencrm';
const String PACKAGE_ID = 'vn.gen_crm';
const String TEAM_ID = 'AEY48KNZRS';

void loginSessionExpired() {
  Get.dialog(WidgetDialog(
    title: MESSAGES.NOTIFICATION,
    content: MESSAGES.PHIEN_DANG_NHAP_HET,
    textButton1: MESSAGES.OKE,
    backgroundButton1: COLORS.PRIMARY_COLOR,
    onTap1: () {
      AppNavigator.navigateLogout();
    },
  ));
}

void handleRegisterBase(
    BuildContext context, PitelServiceImpl pitelService, String deviceToken) {
  final String domainUrl = 'https://demo-gencrm.com/';
  //shareLocal.getString(PreferencesKey.URL_BASE);
  final String domain = domainUrl.substring(
      domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
  final int user =
      int.parse(LoginBloc.of(context).loginData?.info_user?.extension ?? '0');
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  final String pass = stringToBase64.decode(
      LoginBloc.of(context).loginData?.info_user?.password_extension ?? '');

  final String outboundServer = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.outbound ??
      '';
  final String apiDomain = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.domain ??
      '';
  final sipInfo = SipInfoData.fromJson({
    "authPass": pass,
    "registerServer": domain,
    "outboundServer": outboundServer,
    "userID": user,
    "authID": user,
    "accountName": "${user}",
    "displayName": "${user}@${domain}",
    "dialPlan": null,
    "randomPort": null,
    "voicemail": null,
    "wssUrl": BASE_URL.URL_WSS,
    "userName": "${user}@${domain}",
    "apiDomain": getCheckHttp(apiDomain),
  });
  final pnPushParams = PnPushParams(
    pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
    pnParam: Platform.isAndroid
        ? PACKAGE_ID // Example com.company.app
        : '${TEAM_ID}.${BUNDLE_ID}.voip', // Example com.company.app
    pnPrid: '${deviceToken}',
  );
  pitelService.setExtensionInfo(sipInfo, pnPushParams);
}

handleOnPressItemMenu(_drawerKey, value) async {
  switch (value['id']) {
    case '1':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateMain();
      break;
    case 'opportunity':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateChance(value['title']);
      break;
    case 'job':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateWork(value['title']);
      break;
    case 'contract':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateContract(value['title']);
      break;
    case 'support':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateSupport(value['title']);
      break;
    case 'customer':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateCustomer(value['title']);
      break;
    case 'contact':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateClue(value['title']);
      break;
    case 'report':
      _drawerKey.currentState!.openEndDrawer();
      String? money = await shareLocal.getString(PreferencesKey.MONEY);
      AppNavigator.navigateReport(money ?? "đ");
      break;
    case '2':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateInformationAccount();
      break;
    case '3':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateAboutUs();
      break;
    case '4':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigatePolicy();
      break;
    case '5':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateChangePassword();
      break;
    default:
      break;
  }
}

String getCheckHttp(String text) {
  if (text.toLowerCase().contains('https://')) {
    return text;
  }
  return 'https://' + text;
}
