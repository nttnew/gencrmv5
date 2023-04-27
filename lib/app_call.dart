import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gen_crm/screens/screen_main.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:plugin_pitel/component/app_life_cycle/app_life_cycle.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import 'package:plugin_pitel/voip_push/voip_notif.dart';

import 'bloc/login/login_bloc.dart';

class MyAppCall extends StatefulWidget {
  const MyAppCall({Key? key}) : super(key: key);

  @override
  State<MyAppCall> createState() => _MyAppCallState();
}

class _MyAppCallState extends State<MyAppCall> with WidgetsBindingObserver {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  @override
  void initState() {
    LoginBloc.of(context).getDataCall();
    VoipNotifService.listenerEvent(
      callback: (event) {},
      onCallAccept: () {
        handleRegisterBase(context, pitelService);
      },
      onCallDecline: () {},
      onCallEnd: () {
        pitelCall.hangup();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //! Re-Register when resumed/open app in IOS
      handleRegisterBase(context, pitelService);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AppLifecycleTracker(
        didChangeAppState: (state) {
          if (Platform.isAndroid && state == AppState.opened) {
            handleRegisterBase(context, pitelService);
          }
        },
        child: ScreenMain(),
      );
    }
    return ScreenMain();
  }
}
