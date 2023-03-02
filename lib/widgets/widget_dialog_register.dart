import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';

class WidgetDialogRegister extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WidgetDialog(
      twoButton: true,
      title: MESSAGES.NOTIFICATION,
      content: MESSAGES.REGISTER_NOTIFICATION,
      onTap1: () => _openUrl("https://zalo.me/0902183658"),
      onTap2: ()=> AppNavigator.navigateBack(),
    );
  }
}
_openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}