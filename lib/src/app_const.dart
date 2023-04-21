import 'package:gen_crm/src/preferences_key.dart';
import 'package:get/get.dart';

import '../storages/share_local.dart';
import '../widgets/widget_dialog.dart';
import 'color.dart';
import 'messages.dart';
import 'navigator.dart';

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
