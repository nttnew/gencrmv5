import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/widgets/appbar_base.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/src/sip_ua_helper.dart';
import '../../../../bloc/login/login_bloc.dart';
import '../../../../l10n/key_text.dart';
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
  late final TextEditingController _controller;
  final String nameModule = Get.arguments;
  late final FocusNode _focusNode;

  @override
  void initState() {
    pitelCall = PitelClient.getInstance().pitelCall;
    _controller = TextEditingController();
    pitelClient = PitelClient.getInstance();
    _bindEventListeners();
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Giải phóng FocusNode khi widget bị hủy
    super.dispose();
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
    var dest = _controller.text;
    if (dest.isEmpty) {
      showToast(getT(KeyT.you_did_not_enter_a_number_phone));
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
      appBar: AppbarBaseNormal(getT(KeyT.call_operator)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                ),
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _controller,
                    textAlign: TextAlign.center,
                    showCursor: true,
                    readOnly: true,
                    style: styleNumber.copyWith(fontSize: 50),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    ClipboardData? clipboardData =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (clipboardData != null &&
                        int.tryParse(clipboardData.text ?? '') != null) {
                      if ((clipboardData.text?.length ?? 0) > 12) {
                        _controller.text =
                            clipboardData.text.toString().substring(0, 12);
                      } else {
                        _controller.text = clipboardData.text ?? '';
                      }
                      _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length));
                    }
                  },
                  child: Image.asset(
                    ICONS.IC_PASTE_PNG,
                    width: 20,
                    height: 20,
                  ),
                ),
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
                  width: 80,
                  height: 80,
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
                    if (_controller.text.isNotEmpty) _controller.text = '';
                  },
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      if (_controller.selection.baseOffset ==
                          _controller.selection.extentOffset) {
                        deleteTextAtPosition(
                            _controller.selection.extentOffset - 1);
                      } else {
                        deleteTextRange(_controller.selection.baseOffset,
                            _controller.selection.extentOffset - 1);
                      }
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(
                      bottom: 28,
                      top: 14,
                      right: 20,
                      left: 20,
                    ),
                    child: Image.asset(
                      ICONS.IC_DELETE_TEXT_PNG,
                      width: 32,
                      height: 32,
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

  void deleteTextRange(int start, int end) {
    if (start >= 0 && end < _controller.text.length) {
      final text = _controller.text;
      final newText = text.replaceRange(start, end + 1, '');
      _controller.text = newText;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: start));
    }
  }

  void deleteTextAtPosition(int position) {
    if (_controller.text.length > position && position != -1) {
      final text = _controller.text;
      final newText =
          text.substring(0, position) + text.substring(position + 1);
      _controller.text = newText;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: position));
    }
  }

  void insertTextAtPosition(int position, String text) {
    if (_controller.text.length < 12) if (position >= 0 &&
        position <= _controller.text.length) {
      final currentText = _controller.text;
      final newText = currentText.replaceRange(position, position, text);
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: position + text.length));
    } else {
      _controller.text = text;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: text.length));
    }
  }

  Widget numberText(int title) => Expanded(
          child: GestureDetector(
        onTap: () {
          insertTextAtPosition(_controller.selection.extentOffset, '$title');
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
