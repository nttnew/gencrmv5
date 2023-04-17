// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plugin_pitel/component/pitel_call_state.dart';
// import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
// import 'package:plugin_pitel/services/pitel_service.dart';
// import 'package:plugin_pitel/services/sip_info_data.dart';
// import 'package:plugin_pitel/sip/sip_ua.dart';
// import 'package:plugin_pitel/voip_push/push_notif.dart';
// import 'package:plugin_pitel/voip_push/voip_notif.dart';
//
// import 'call_screen.dart';
//
// final checkIsPushNotif = StateProvider<bool>((ref) => false);
//
// class HomeScreen extends ConsumerStatefulWidget {
//   final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
//   HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<HomeScreen> createState() => _MyHomeScreen();
// }
//
// class _MyHomeScreen extends ConsumerState<HomeScreen>
//     implements SipPitelHelperListener {
//   // late String _dest;
//   PitelCall get pitelCall => widget._pitelCall;
//   final TextEditingController _textController = TextEditingController();
//
//   String receivedMsg = 'UNREGISTER';
//   PitelClient pitelClient = PitelClient.getInstance();
//   String state = '';
//   bool isLogin = false;
//
//   // INIT: Initialize state
//   @override
//   initState() {
//     super.initState();
//     state = pitelCall.getRegisterState();
//     receivedMsg = 'UNREGISTER';
//     _bindEventListeners();
//     _getDeviceToken();
//     VoipNotifService.listenerEvent(
//       callback: (event) {},
//       onCallAccept: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
//       },
//       onCallDecline: () {},
//     );
//   }
//
//   void _getDeviceToken() async {
//     final deviceToken = await PushVoipNotif.getDeviceToken();
//     print(deviceToken);
//   }
//
//   @override
//   void deactivate() {
//     super.deactivate();
//     _removeEventListeners();
//   }
//
//   void _bindEventListeners() {
//     pitelCall.addListener(this);
//   }
//
//   void _removeEventListeners() {
//     pitelCall.removeListener(this);
//   }
//
//   // HANDLE: handle message if register status change
//   @override
//   void onNewMessage(PitelSIPMessageRequest msg) {
//     var msgBody = msg.request.body as String;
//     setState(() {
//       receivedMsg = msgBody;
//     });
//   }
//
//   @override
//   void callStateChanged(String callId, PitelCallState state) {}
//
//   @override
//   void transportStateChanged(PitelTransportState state) {}
//
//   @override
//   void onCallReceived(String callId) {
//     pitelCall.setCallCurrent(callId);
//     //! Replace if you are using other State Managerment (Bloc, GetX,...)
//     final isPushNotif = ref.watch(checkIsPushNotif);
//     if (!isPushNotif) {
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
//     }
//   }
//
//   @override
//   void onCallInitiated(String callId) {
//     pitelCall.setCallCurrent(callId);
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
//   }
//
//   // ACTION: call device if register success
//   // Flow: Register (with sipInfoData) -> Register success REGISTERED -> Start Call
//   void _handleCall(BuildContext context, [bool voiceonly = false]) {
//     var dest = _textController.text;
//     if (dest.isEmpty) {
//       showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return const AlertDialog(
//             title: Text('Target is empty.'),
//             content: Text('Please enter a SIP URI or username!'),
//           );
//         },
//       );
//     } else {
//       pitelClient.call(dest, voiceonly).then((value) =>
//           value.fold((succ) => {}, (err) => {receivedMsg = err.toString()}));
//     }
//   }
//
//   void goBack() {
//     pitelClient.release();
//     Navigator.of(context).pop();
//   }
//
//   void _logout() {
//     setState(() {
//       isLogin = false;
//       receivedMsg = 'UNREGISTER';
//     });
//     _removeDeviceToken();
//     pitelCall.unregister();
//   }
//
//   void _registerDeviceToken() async {
//     final response = await pitelClient.registerDeviceToken(
//       deviceToken:
//           '56357b057da09ba1c8a069c06a0f0232f7a1d80bf743f757c290a20b42dce55c',
//       platform: 'ios',
//       bundleId: 'com.pitel.uikit.demo',
//       domain: 'mobile.tel4vn.com',
//       extension: '101',
//     );
//   }
//
//   void _removeDeviceToken() async {
//     final response = await pitelClient.removeDeviceToken(
//       deviceToken:
//           '56357b057da09ba1c8a069c06a0f0232f7a1d80bf743f757c290a20b42dce55c',
//       domain: 'mobile.tel4vn.com',
//       extension: '101',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pitel UI Kit"),
//         centerTitle: true,
//       ),
//       body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         Container(
//             padding: const EdgeInsets.all(20),
//             width: 360,
//             child: Text(
//               'STATUS: $receivedMsg',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
//             )),
//         isLogin
//             ? TextButton(
//                 onPressed: _logout,
//                 child: const Text(
//                   'Logout',
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ))
//             : ElevatedButton(
//                 onPressed: () {
//                   // SIP INFO DATA: input Sip info config data
//                   final sipInfo = SipInfoData.fromJson({
//                     "authPass": "GenCRM@2023##",
//                     "registerServer": "demo-gencrm.com",
//                     "outboundServer": "pbx-mobile.tel4vn.com:50061",
//                     "userID": 101,
//                     "authID": 101,
//                     "accountName": "101",
//                     "displayName": "101@demo-gencrm.com",
//                     "dialPlan": null,
//                     "randomPort": null,
//                     "voicemail": null,
//                     "wssUrl": "wss://wss-mobile.tel4vn.com:7444",
//                     "userName": "user1@demo-gencrm.com",
//                     "apiDomain": "https://pbx-mobile.tel4vn.com"
//                   });
//
//                   final pitelClient = PitelServiceImpl();
//                   pitelClient.setExtensionInfo(sipInfo);
//                   setState(() {
//                     isLogin = true;
//                   });
//                   _registerDeviceToken();
//                 },
//                 child: const Text("Register"),
//               ),
//         const SizedBox(height: 20),
//         Container(
//           color: Colors.green,
//           child: TextField(
//             keyboardType: TextInputType.number,
//             style: const TextStyle(fontSize: 20),
//             textAlign: TextAlign.center,
//             decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Input Phone number",
//                 hintStyle: TextStyle(fontSize: 18)),
//             controller: _textController,
//             showCursor: true,
//             autofocus: true,
//           ),
//         ),
//         const SizedBox(height: 20),
//         receivedMsg == "REGISTERED"
//             ? ElevatedButton(
//                 onPressed: () => _handleCall(context, true),
//                 child: const Text("Call"))
//             : const SizedBox.shrink(),
//       ]),
//     );
//   }
//
//   // STATUS: check register status
//   @override
//   void registrationStateChanged(PitelRegistrationState state) {
//     switch (state.state) {
//       case PitelRegistrationStateEnum.REGISTRATION_FAILED:
//         goBack();
//         break;
//       case PitelRegistrationStateEnum.NONE:
//       case PitelRegistrationStateEnum.UNREGISTERED:
//         setState(() {
//           receivedMsg = 'UNREGISTERED';
//         });
//         break;
//       case PitelRegistrationStateEnum.REGISTERED:
//         setState(() {
//           receivedMsg = 'REGISTERED';
//         });
//         break;
//     }
//   }
// }
