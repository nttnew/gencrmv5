import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pitel_voip/pitel_sdk/pitel_call.dart';
import 'package:flutter_pitel_voip/pitel_sdk/pitel_client.dart';
import 'package:flutter_pitel_voip/screens/pitel_voip/pitel_voip.dart';
import 'package:flutter_pitel_voip/screens/pitel_voip_call/pitel_voip_call.dart';
import 'package:flutter_pitel_voip/services/models/push_notif_params.dart';
import 'package:flutter_pitel_voip/services/pitel_service.dart';
import 'package:flutter_pitel_voip/sip/src/sip_ua_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/call/call.dart';
import 'package:gen_crm/screens/screen_main.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/preferences_key.dart';
import '../../storages/share_local.dart';

final checkIsPushNotif = StateProvider<bool>((ref) => false);
final callStateController =
    StateProvider<PitelCallStateEnum>((ref) => PitelCallStateEnum.NONE);
final pitelSettingProvider = StateProvider<PitelSettings?>((ref) => null);

class InitCallApp extends ConsumerStatefulWidget {
  const InitCallApp({Key? key}) : super(key: key);

  @override
  ConsumerState<InitCallApp> createState() => _InitCallAppState();
}

class _InitCallAppState extends ConsumerState<InitCallApp> {
  final pitelService = PitelServiceImpl();
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  @override
  void initState() {
    super.initState();
    LoginBloc.of(context).getDataCall();
  }

  void _onRegisterState(String registerState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (registerState == LoginBloc.REGISTERED) {
      prefs.setBool(PreferencesKey.IS_LOGGED_IN, true);
      shareLocal.putString(PreferencesKey.REGISTER_MSG, registerState);
    }
  }

  void registerFunc() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final PushNotifParams pushNotifParams = PushNotifParams(
      teamId: TEAM_ID,
      bundleId: packageInfo.packageName,
    );

    final pitelClient = PitelServiceImpl();

    final pitelSetting =
        await pitelClient.setExtensionInfo(getSipInfo(), pushNotifParams);

    ref.read(pitelSettingProvider.notifier).state = pitelSetting;
  }

  void handleRegister() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool(PreferencesKey.IS_LOGGED_IN);

    if (isLoggedIn != null && isLoggedIn) {
      registerFunc();
    }
  }

  void handleRegisterCall() async {
    final PitelSettings? pitelSetting = ref.watch(pitelSettingProvider);
    if (pitelSetting != null) {
      pitelCall.register(pitelSetting);
    } else {
      registerFunc();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("ACCEPT_CALL", true);
  }

  @override
  Widget build(BuildContext context) {
    return PitelVoip(
      handleRegister: handleRegister,
      handleRegisterCall: handleRegisterCall,
      child: PitelVoipCall(
        bundleId: Platform.isAndroid ? PACKAGE_ID : BUNDLE_ID,
        appMode: 'production', // dev or production
        sipInfoData: getSipInfo(),
        goBack: () {
          Get.back();
        },
        goToCall: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CallPage()));
        },
        onCallState: (callState) {
          ref.read(callStateController.notifier).state = callState;
        },
        onRegisterState: (String registerState) {
          _onRegisterState(registerState);
        },
        child: ScreenMain(),
      ),
    );
  }
}
