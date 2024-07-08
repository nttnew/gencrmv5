import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlMy(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

void updateLocale() {
  // Get.updateLocale(
  //   Locale.fromSubtags(languageCode: PrefsService.getLanguage()),
  // );
}

void closeKey() {
  FocusManager.instance.primaryFocus?.unfocus();
}
