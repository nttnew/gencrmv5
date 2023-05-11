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

class DialogCall extends StatefulWidget {
  final String sdt;
  const DialogCall({Key? key, required this.sdt}) : super(key: key);

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
        goBack(); //todo thaats baij
        break;
      case PitelRegistrationStateEnum.NONE:
      case PitelRegistrationStateEnum.UNREGISTERED:
      case PitelRegistrationStateEnum.REGISTERED:
        LoginBloc.of(context).receivedMsg.add(LoginBloc.UNREGISTER);
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
    LoginBloc.of(context).receivedMsg.add(msgBody);
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
            )));
  }

  @override
  void onCallInitiated(String callId) {
    pitelCall.setCallCurrent(callId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreenWidget(
              modelScreen: ROUTE_NAMES.CUSTOMER,
            )));
  }

  void goBack() {
    pitelClient.release();
    Navigator.of(context).pop();
  }

  void _handleCall(BuildContext context, [bool voiceonly = false]) {
    var dest = '0986839102'; //todo harcode
    if (dest.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
          );
        },
      );
    } else {
      pitelClient.call(dest, voiceonly).then((value) => value.fold((succ) => {},
          (err) => {LoginBloc.of(context).receivedMsg.add(err.toString())}));
      // LoginBloc.of(context).preferences.setString('dest', dest);
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
                      showToast('Sao chép thành công');
                    });
                  },
                  child: WidgetText(
                      title: 'Sao chép',
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
                      title: 'Gọi điện',
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 16,
                ),
                if (true) //todo check hide
                  GestureDetector(
                    onTap: () {
                      _handleCall(context, true);
                    },
                    child: WidgetText(
                        title: 'Gọi qua tổng đài',
                        style: AppStyle.DEFAULT_18_BOLD.copyWith(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                  ),
                SizedBox(
                  height: 16,
                ),
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
