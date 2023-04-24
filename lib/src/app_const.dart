import 'package:gen_crm/src/preferences_key.dart';
import 'package:get/get.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';

import '../storages/share_local.dart';
import '../widgets/widget_dialog.dart';
import 'color.dart';
import 'messages.dart';
import 'navigator.dart';

//todo data hard code
//DATA CALL
// static const String PASSWORD = 'GenCRM@2023##'; //
// static const String DOMAIN = 'demo-gencrm.com';
// static const String OUTBOUND_PROXY = 'pbx-mobile.tel4vn.com:50061';
// static const String URL_API = 'https://pbx-mobile.tel4vn.com';
// static const int UUSER = 102;
// static const String USER_NAME = 'user2';

// final response = await pitelClient.registerDeviceToken(
//   deviceToken: deviceToken,
//   platform: 'android',
//   bundleId: 'vn.gen_crm',
//   domain: 'demo-gencrm.com',
//   extension: '102',
//   // appMode: kReleaseMode ? 'production' : 'dev',
//   appMode: 'dev',
// );

final sipInfoData = SipInfoData.fromJson({
  "authPass": "GenCRM@2023##",
  "registerServer": "demo-gencrm.com",
  "outboundServer": "pbx-mobile.tel4vn.com:50061",
  "userID": 102, // Example 101
  "authID": 102, // Example 101
  "accountName": "102", // Example 101
  "displayName": "102@demo-gencrm.com",
  "dialPlan": null,
  "randomPort": null,
  "voicemail": null,
  "wssUrl": "wss://wss-mobile.tel4vn.com:7444",
  "userName": "user1@demo-gencrm.com",
  "apiDomain": "https://api-mobile.tel4vn.com"
});

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
