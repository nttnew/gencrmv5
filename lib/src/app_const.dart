import 'package:get/get.dart';

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
