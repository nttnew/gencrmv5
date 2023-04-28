import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gen_crm/screens/call/home_screen.dart';
import 'package:plugin_pitel/component/app_life_cycle/app_life_cycle.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/models/pn_push_params.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:plugin_pitel/voip_push/voip_notif.dart';

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

const String BUNDLE_ID = 'com.gencrm';
const String PACKAGE_ID = 'vn.gen_crm';
const String TEAM_ID = 'AEY48KNZRS';

class InitCallApp extends StatefulWidget {
  const InitCallApp({Key? key}) : super(key: key);

  @override
  State<InitCallApp> createState() => _InitCallAppState();
}

class _InitCallAppState extends State<InitCallApp> with WidgetsBindingObserver {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  @override
  void initState() {
    super.initState();
    VoipNotifService.listenerEvent(
      callback: (event) {},
      onCallAccept: () {
        handleRegister();
      },
      onCallDecline: () {},
      onCallEnd: () {
        pitelCall.hangup();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //! Re-Register when resumed/open app in IOS
      handleRegister();
    }
  }

  void handleRegister() async {
    final deviceToken = await PushVoipNotif.getDeviceToken();
    final pnPushParams = PnPushParams(
      pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
      pnParam: Platform.isAndroid
          ? PACKAGE_ID // Example com.company.app
          : '${TEAM_ID}.${BUNDLE_ID}.voip', // Example com.company.app
      pnPrid: '${deviceToken}',
    );
    pitelService.setExtensionInfo(sipInfoData, pnPushParams);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AppLifecycleTracker(
        //! Re-Register when resumed/open app in Android
        didChangeAppState: (state) {
          if (Platform.isAndroid && state == AppState.opened) {
            handleRegister();
          }
        },
        child: HomeScreen(),
      );
    }
    return HomeScreen();
  }
}
