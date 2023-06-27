import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/login/login_bloc.dart';
import '../screens/call/call_screen.dart';
import '../src/src_index.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../storages/share_local.dart';

class DialogCall extends StatefulWidget {
  final String sdt;
  final String title;
  const DialogCall({
    Key? key,
    required this.sdt,
    required this.title,
  }) : super(key: key);

  @override
  State<DialogCall> createState() => _DialogCallState();
}

class _DialogCallState extends State<DialogCall>
    implements SipPitelHelperListener {
  late final pitelCall;
  late final pitelClient;
  @override
  void initState() {
    pitelCall = PitelClient.getInstance().pitelCall;
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
        shareLocal.putString(PreferencesKey.REGISTER_MSG, LoginBloc.UNREGISTER);
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
              title: widget.title,
            )));
  }

  @override
  void onCallInitiated(String callId) {
    pitelCall.setCallCurrent(callId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreenWidget(
              modelScreen: ROUTE_NAMES.CUSTOMER,
              title: widget.title,
            )));
  }

  void goBack() {
    pitelClient.release();
    Navigator.of(context).pop();
  }

  void _handleCall(BuildContext context, [bool voiceonly = false]) {
    var dest = widget.sdt;
    if (dest.isEmpty) {
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
    return SafeArea(
        top: false,
        child: AlertDialog(
          content: Container(
            width: AppValue.widths - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                WidgetText(
                    title: widget.sdt,
                    style: AppStyle.DEFAULT_18_BOLD.copyWith(fontSize: 32)),
                SizedBox(
                  height: 16,
                ),
                Divider(
                  height: 1,
                  color: COLORS.GREY,
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: widget.sdt,
                      ),
                    ).then((_) {
                      showToast(
                          AppLocalizations.of(Get.context!)?.copy_success ??
                              '');
                    });
                  },
                  child: WidgetText(
                      title: AppLocalizations.of(Get.context!)?.copy,
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri(scheme: "tel", path: widget.sdt));
                  },
                  child: WidgetText(
                      title: AppLocalizations.of(Get.context!)?.call,
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
                ),
                if (LoginBloc.of(context).checkRegisterSuccess()) ...[
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      _handleCall(context, true);
                    },
                    child: WidgetText(
                        title: AppLocalizations.of(Get.context!)?.call_operator,
                        style: AppStyle.DEFAULT_18_BOLD.copyWith(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                  ),
                ]
              ],
            ),
          ),
        ));
  }

  Future<void> showToast(String message) async {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
          content: Text(message), duration: const Duration(milliseconds: 300)));
  }
}
