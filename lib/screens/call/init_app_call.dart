import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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

class _InitCallAppState extends State<InitCallApp> {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;
  bool isCall = false;

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
    initRegister();
  }

  void initRegister() async {
    isCall = true;
    final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
    if (Platform.isAndroid) {
      handleRegister();
    }
    if (res.isEmpty && Platform.isIOS) {
      handleRegister();
    }
  }

  void handleRegister() async {
    final deviceToken = await PushVoipNotif.getDeviceToken();
    handleRegisterBase(context, pitelService, deviceToken);
  }

  @override
  Widget build(BuildContext context) {
    return AppLifecycleTracker(
      didChangeAppState: (state) async {
        if (Platform.isIOS) {
          final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
          if (state == AppState.resumed && res.isEmpty) {
            if (!isCall) {
              handleRegister();
            }
          }
          if (state == AppState.inactive || state == AppState.paused) {
            setState(() {
              isCall = false;
            });
          }
        }
        if (Platform.isAndroid && state == AppState.resumed) {
          if (!pitelCall.isConnected) {
            handleRegister();
          }
        }
      },
      child: ScreenMain(),
    );
  }
}
