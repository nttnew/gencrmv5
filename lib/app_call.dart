import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gen_crm/screens/screen_main.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/base.dart';
import 'package:gen_crm/src/preferences_key.dart';
import 'package:gen_crm/storages/share_local.dart';
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

  late final sipInfo;

  @override
  void initState() {
    VoipNotifService.listenerEvent(
      callback: (event) {},
      onCallAccept: () {
        //! Re-register when user accept call
        pitelService.setExtensionInfo(sipInfo);
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
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //! Re-Register when resumed/open app in IOS
      handleRegister();
    }
  }

  Future<void> handleRegister() async {
    await LoginBloc.of(context).getDataCall();
    final String domainUrl = 'https://demo-gencrm.com/';
    //shareLocal.getString(PreferencesKey.URL_BASE);
    final String domain = domainUrl.substring(
        domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
    final int user =
        int.parse(LoginBloc.of(context).loginData?.info_user?.extension ?? '0');
    final String pass =
        LoginBloc.of(context).loginData?.info_user?.password_extension ?? '';
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
    pitelService.setExtensionInfo(sipInfoData);
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
