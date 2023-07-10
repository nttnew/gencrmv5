import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../bloc/login/login_bloc.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../call/action_button.dart';
import '../../../call/call_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    implements SipPitelHelperListener {
  late final pitelCall;
  late final pitelClient;
  late final BehaviorSubject<String> _controller;
  final String nameModule = Get.arguments;

  @override
  void initState() {
    pitelCall = PitelClient.getInstance().pitelCall;
    _controller = BehaviorSubject.seeded('');
    pitelClient = PitelClient.getInstance();
    _bindEventListeners();
    super.initState();
  }

  // STATUS: check register status
  @override
  void registrationStateChanged(PitelRegistrationState state) {
    switch (state.state) {
      case PitelRegistrationStateEnum.REGISTRATION_FAILED:
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
      case PitelRegistrationStateEnum.REGISTERED:
        shareLocal.putString(PreferencesKey.REGISTER_MSG, LoginBloc.REGISTERED);
        break;
    }
  }

  void _bindEventListeners() {
    pitelCall.addListener(this);
  }

  @override
  void deactivate() {
    super.deactivate();
    _removeEventListeners();
  }

  void _removeEventListeners() {
    pitelCall.removeListener(this);
  }

  // ACTION: call device if register success
  // Flow: Register (with sipInfoData) -> Register success REGISTERED -> Start Call
  @override
  void onNewMessage(PitelSIPMessageRequest msg) {
    var msgBody = msg.request.body as String;
    shareLocal.putString(PreferencesKey.REGISTER_MSG, msgBody);
  }

  @override
  void callStateChanged(String callId, PitelCallState state) {}

  @override
  void transportStateChanged(PitelTransportState state) {}

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreenWidget(
              modelScreen: ROUTE_NAMES.CUSTOMER,
              title: nameModule,
            )));
  }

  @override
  void onCallInitiated(String callId) {
    pitelCall.setCallCurrent(callId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreenWidget(
              modelScreen: ROUTE_NAMES.CUSTOMER,
              title: nameModule,
            )));
  }

  void goBack() {
    pitelClient.release();
    Navigator.of(context).pop();
  }

  void _handleCall(BuildContext context, [bool voiceonly = false]) {
    var dest = _controller.value;
    if (dest.isEmpty) {
      showToast(
          AppLocalizations.of(Get.context!)?.you_did_not_enter_a_number_phone ??
              '');
    } else {
      pitelClient.call(dest, voiceonly).then((value) => value.fold(
          (succ) => {},
          (err) => {
                shareLocal.putString(
                    PreferencesKey.REGISTER_MSG, err.toString())
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(
          AppLocalizations.of(Get.context!)?.call_operator ?? ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                StreamBuilder<String>(
                    stream: _controller,
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 170,
                        child: FittedBox(
                          child: Center(
                            child: Text(
                              snapshot.data.toString(),
                              style: styleNumber.copyWith(fontSize: 50),
                            ),
                          ),
                        ),
                      );
                    }),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: _controller.value));
                      },
                      child: Image.asset(
                        ICONS.IC_COPY_PNG,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        ClipboardData? clipboardData =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData != null &&
                            int.tryParse(clipboardData.text ?? '') != null) {
                          if ((clipboardData.text?.length ?? 0) > 10) {
                            _controller.add(
                                clipboardData.text.toString().substring(0, 10));
                          } else {
                            _controller.add(clipboardData.text ?? '');
                          }
                        } else {}
                      },
                      child: Image.asset(
                        ICONS.IC_PASTE_PNG,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [numberText(1), numberText(2), numberText(3)],
            ),
            Row(
              children: [numberText(4), numberText(5), numberText(6)],
            ),
            Row(
              children: [numberText(7), numberText(8), numberText(9)],
            ),
            Row(
              children: [numberText(0)],
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                ),
                ActionButton(
                  title: "hangup",
                  onPressed: () {
                    _handleCall(context, true);
                  },
                  icon: Icons.call,
                  fillColor: COLORS.GREEN,
                ),
                GestureDetector(
                  onLongPress: () {
                    if (_controller.value.isNotEmpty) _controller.value = '';
                  },
                  onTap: () {
                    if (_controller.value.isNotEmpty)
                      _controller.value = _controller.value
                          .substring(0, _controller.value.length - 1);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Image.asset(
                      ICONS.IC_DELETE_TEXT_PNG,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget numberText(int title) => Expanded(
          child: GestureDetector(
        onTap: () {
          if (_controller.value.length < 11)
            _controller.value = '${_controller.value}${title}';
        },
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.width / 5.5,
          child: Center(
            child: WidgetText(
              title: title.toString(),
              style: styleNumber,
            ),
          ),
        ),
      ));

  TextStyle styleNumber = AppStyle.DEFAULT_TITLE_PRODUCT.copyWith(
    fontSize: 45,
    color: Colors.black,
  );

  Future<void> showToast(String message) async {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
          content: Text(message), duration: const Duration(milliseconds: 300)));
  }
}
