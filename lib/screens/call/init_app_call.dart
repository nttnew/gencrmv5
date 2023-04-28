import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/screen_main.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:plugin_pitel/component/app_life_cycle/app_life_cycle.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/voip_push/push_notif.dart';
import 'package:plugin_pitel/voip_push/voip_notif.dart';

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
    LoginBloc.of(context).getDataCall();
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
    handleRegisterBase(context, pitelService, deviceToken);
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
        child: ScreenMain(),
      );
    }
    return ScreenMain();
  }
}
