// import 'package:flutter/material.dart';
// import 'package:plugin_pitel/component/pitel_call_state.dart';
// import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
// import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
// import 'package:plugin_pitel/services/pitel_service.dart';
// import 'package:plugin_pitel/services/sip_info_data.dart';
// import 'package:plugin_pitel/sip/sip_ua.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'call_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
//   HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _MyHomeScreen();
// }
//
// class _MyHomeScreen extends State<HomeScreen>
//     implements SipPitelHelperListener {
//
//   static const String PASSWORD='GenCRM@2023##';
//   static const String DOMAIN='demo-gencrm.com';
//   static const String OUTBOUND_PROXY='pbx-mobile.tel4vn.com:50061';
//   static const String URL_WSS='wss://wss-mobile.tel4vn.com:7444';
//   static const String URL_API='https://pbx-mobile.tel4vn.com';
//   static const int UUSER=102;
//   static const String USER_NAME='user2';
//
//
//
//
//   late String _dest;
//   PitelCall get pitelCall => widget._pitelCall;
//   final TextEditingController _textController = TextEditingController();
//   late SharedPreferences _preferences;
//
//   String receivedMsg = 'UNREGISTER';
//   PitelClient pitelClient = PitelClient.getInstance();
//   String state = '';
//
//   // INIT: Initialize state
//   @override
//   initState() {
//     super.initState();
//     state = pitelCall.getRegisterState();
//     receivedMsg = 'UNREGISTER';
//     _bindEventListeners();
//     _loadSettings();
//   }
//
//   @override
//   void deactivate() {
//     super.deactivate();
//     _removeEventListeners();
//   }
//
//   // INIT: Load default settings
//   void _loadSettings() async {
//     _preferences = await SharedPreferences.getInstance();
//     _dest = _preferences.getString('dest') ?? '';
//     _textController.text = _dest;
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
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => CallScreenWidget()));
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
//       _preferences.setString('dest', dest);
//     }
//   }
//
//   void goBack() {
//     pitelClient.release();
//     Navigator.of(context).pop();
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
//         ElevatedButton(
//           onPressed: () {
//             // SIP INFO DATA: input Sip info config data
//             final sipInfo = SipInfoData.fromJson({
//               "authPass": PASSWORD,
//               "registerServer": DOMAIN,
//               "outboundServer": OUTBOUND_PROXY,
//               "userID": UUSER,
//               "authID": UUSER,
//               "accountName": "${UUSER}",
//               "displayName": "${UUSER}@${DOMAIN}",
//               "dialPlan": null,
//               "randomPort": null,
//               "voicemail": null,
//               "wssUrl": URL_WSS,
//               "userName": "${USER_NAME}@${DOMAIN}",
//               "apiDomain": URL_API
//             });
//             // final sipInfo = SipInfoData.fromJson({
//             // "authPass": "${Password}",
//             // "registerServer": "${Domain}",
//             // "outboundServer": "${Outbound_Proxy}",
//             // "userID": UUser,                // Example 101
//             // "authID": UUser,                // Example 101
//             // "accountName": "${UUser}",      // Example 101
//             // "displayName": "${UUser}@${Domain}",
//             // "dialPlan": null,
//             // "randomPort": null,
//             // "voicemail": null,
//             // "wssUrl": "${URL_WSS}",
//             // "userName": "${username}@${Domain}",
//             // "apiDomain": "${URL_API}"
//             // });
//
//             final pitelClient = PitelServiceImpl();
//             pitelClient.setExtensionInfo(sipInfo);
//           },
//           child: const Text("Register"),
//         ),
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
//       case PitelRegistrationStateEnum.REGISTERED:
//         setState(() {
//           receivedMsg = 'REGISTERED';
//         });
//         break;
//     }
//   }
// }
