import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_pitel_voip/screens/pitel_voip_call/pitel_voip_call.dart';
import 'package:flutter_pitel_voip/services/sip_info_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/screens/call/call.dart';
import 'package:gen_crm/screens/screen_main.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../my_app.dart';
// import 'package:plugin_pitel/component/app_life_cycle/app_life_cycle.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
// import 'package:plugin_pitel/services/pitel_service.dart';
// import 'package:plugin_pitel/voip_push/push_notif.dart';
// import 'package:plugin_pitel/voip_push/voip_notif.dart';

class InitCallApp extends ConsumerStatefulWidget {
  const InitCallApp({Key? key}) : super(key: key);

  @override
  ConsumerState<InitCallApp> createState() => _InitCallAppState();
}

class _InitCallAppState extends ConsumerState<InitCallApp> {
  // final pitelService = PitelServiceImpl();
  // final PitelCall pitelCall = PitelClient.getInstance().pitelCall;
  bool isCall = false;

  @override
  void initState() {
    super.initState();
    LoginBloc.of(context).getDataCall();
    // VoipNotifService.listenerEvent(
    //   callback: (event) {},
    //   onCallAccept: () {
    //     handleRegister();
    //   },
    //   onCallDecline: () {},
    //   onCallEnd: () {
    //     pitelCall.hangup();
    //   },
    // );
    initRegister();
  }

  void initRegister() async {
    isCall = true;
    // final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
    // if (Platform.isAndroid) {
    //   handleRegister();
    // }
    // if (res.isEmpty && Platform.isIOS) {
    //   handleRegister();
    // }
  }

  void handleRegister() async {
    try {
      // final deviceToken = await PushVoipNotif.getDeviceToken();
      // handleRegisterBase(context, pitelService, deviceToken);
    } catch (e) {}
  }

  String wss = 'wss://psbc02.tel4vn.com:7444';
  String outboundServer = 'hungson.gencrm.com:50061';
  String Domain = 'hungson.gencrm.com';
  String apiDomain = 'https://api-pbx01.tel4vn.com';
  String user = '12';
  String pass = 'Abc@1234';
  String apple_team_id = 'AEY48KNZRS';
  String receivedMsg = 'UNREGISTER';
  String state = '';
  bool isLogin = false;

  void _onRegisterState(String registerState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (registerState == 'REGISTERED') {
      //  Set isLoggedIn = true when user logout
      prefs.setBool("IS_LOGGED_IN", true);

      setState(() {
        receivedMsg = registerState;
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PitelVoipCall(
      // Wrap with PitelVoipCall

      bundleId:
          Platform.isAndroid ? PACKAGE_ID : '${TEAM_ID}.${BUNDLE_ID}.voip',
      appMode: 'production', // dev or production
      sipInfoData: getSipInfo(),
      goBack: () {
        Get.back();
        // go back function
      },
      goToCall: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CallPage()));
        // go to call screen
      },
      onCallState: (callState) {
        // IMPORTANT: Set callState to your global state management. Example: bloc, getX, riverpod,..
        // Example riverpod
        ref.read(callStateController.notifier).state = callState;
      },
      onRegisterState: (String registerState) {
        // get Register Status in here
      },
      child: ScreenMain(),
    );
    // return AppLifecycleTracker(
    //   didChangeAppState: (state) async {
    //     if (Platform.isIOS) {
    //       final List<dynamic> res = await FlutterCallkitIncoming.activeCalls();
    //       if (state == AppState.resumed && res.isEmpty) {
    //         if (!isCall) {
    //           handleRegister();
    //         }
    //       }
    //       if (state == AppState.inactive || state == AppState.paused) {
    //         setState(() {
    //           isCall = false;
    //         });
    //       }
    //     }
    //     if (Platform.isAndroid && state == AppState.resumed) {
    //       if (!pitelCall.isConnected) {
    //         handleRegister();
    //       }
    //     }
    //   },
    //   child: ScreenMain(),
    // );
  }
}
