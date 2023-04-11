import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/pitel_rtc_video_view.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import 'package:rxdart/rxdart.dart';

import '../../src/src_index.dart';
import '../../widgets/action_button.dart';

class CallScreenWidget extends StatefulWidget {
  CallScreenWidget({Key? key, this.receivedBackground = false})
      : super(key: key);
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  final bool receivedBackground;

  @override
  State<CallScreenWidget> createState() => _MyCallScreenWidget();
}

class _MyCallScreenWidget extends State<CallScreenWidget>
    implements SipPitelHelperListener {
  PitelCall get pitelCall => widget._pitelCall;
  String _timeLabel = '00:00';
  late Timer _timer;
  bool _speakerOn = false;
  BehaviorSubject<PitelCallStateEnum> _state =
      BehaviorSubject.seeded(PitelCallStateEnum.NONE);
  bool calling = false;
  bool _isBacked = false;
  String _callId = '';

  bool get voiceonly => pitelCall.isVoiceOnly();

  String? get direction => pitelCall.direction;

  @override
  initState() {
    super.initState();
    pitelCall.addListener(this);
    if (voiceonly) {
      _initRenderers();
    }
    _startTimer();
  }

  // Deactive & Dispose when call end
  @override
  deactivate() {
    super.deactivate();
    _handleHangup();
    pitelCall.removeListener(this);
    _disposeRenderers();
  }

  // Start timer to calculate time of call
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final duration = Duration(seconds: timer.tick);
      if (mounted) {
        setState(() {
          _timeLabel = [duration.inMinutes, duration.inSeconds]
              .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
              .join(':');
        });
      } else {
        _timer.cancel();
      }
    });
  }

  // INIT: Initialize Pitel
  void _initRenderers() async {
    if (!voiceonly) {
      await pitelCall.initializeLocal();
      await pitelCall.initializeRemote();
    }
  }

  // Dispose pitelcall
  void _disposeRenderers() {
    pitelCall.disposeLocalRenderer();
    pitelCall.disposeRemoteRenderer();
  }

  @override
  void dispose() {
    _disposeRenderers();
    pitelCall.removeListener(this);
    super.dispose();
  }

  // STATUS: Handle call state
  @override
  void callStateChanged(String callId, PitelCallState callState) {
    setState(() {
      _state.add(callState.state);
    });
    switch (callState.state) {
      case PitelCallStateEnum.HOLD:
      case PitelCallStateEnum.UNHOLD:
        break;
      case PitelCallStateEnum.MUTED:
      case PitelCallStateEnum.UNMUTED:
        break;
      case PitelCallStateEnum.STREAM:
        break;
      case PitelCallStateEnum.ENDED:
      case PitelCallStateEnum.FAILED:
        setState(() {
          _callId = callId;
        });
        _backToDialPad();
        break;
      case PitelCallStateEnum.CONNECTING:
      case PitelCallStateEnum.PROGRESS:
      case PitelCallStateEnum.ACCEPTED:
      case PitelCallStateEnum.CONFIRMED:
        setState(() {
          _callId = callId;
        });
        break;
      case PitelCallStateEnum.NONE:
      case PitelCallStateEnum.CALL_INITIATION:
      case PitelCallStateEnum.REFER:
        break;
    }
  }

  // Setup initialize listener
  @override
  void onNewMessage(PitelSIPMessageRequest msg) {}

  @override
  void registrationStateChanged(PitelRegistrationState state) {}

  @override
  void transportStateChanged(PitelTransportState state) {}

  @override
  void onCallReceived(String callId) {
    pitelCall.setCallCurrent(callId);
    setState(() {});
  }

  @override
  void onCallInitiated(String callId) {}

  // Back to Home screen
  void _backToDialPad() {
    if (mounted && !_isBacked) {
      _isBacked = true;
      context.pop();
    }
  }

  // Handle hangup and reset timer
  void _handleHangup() {
    pitelCall.hangup(callId: _callId);
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  // Handle accept call
  void _handleAccept() {
    pitelCall.answer();
  }

  // Turn on/off speaker
  void _toggleSpeaker() {
    if (pitelCall.localStream != null) {
      _speakerOn = !_speakerOn;
      pitelCall.enableSpeakerphone(_speakerOn);
    }
  }

  Widget _buildActionButtons() {
    var hangupBtn = ActionButton(
      title: "hangup",
      onPressed: () {
        _handleHangup();
        _backToDialPad();
      },
      icon: Icons.call_end,
      fillColor: Colors.red,
    );

    var hangupBtnInactive = ActionButton(
      title: "hangup",
      onPressed: () {},
      icon: Icons.call_end,
      fillColor: Colors.grey,
    );

    var basicActions = <Widget>[];
    // var advanceActions = <Widget>[];
    switch (_state.value) {
      case PitelCallStateEnum.NONE:
      case PitelCallStateEnum.PROGRESS:
        if (direction == 'INCOMING') {
          basicActions = [
            ActionButton(
              title: "Accept",
              fillColor: Colors.green,
              icon: Icons.phone,
              onPressed: () => _handleAccept(),
            ),
            hangupBtn
          ];
        } else {
          basicActions = [];
          if (voiceonly)
            basicActions.add(ActionButton(
              iconColor: Colors.black.withOpacity(0.2),
              title: _speakerOn ? 'speaker off' : 'speaker on',
              icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
              fillColor: Colors.black.withOpacity(0.1),
              checked: _speakerOn,
              onPressed: () => {},
            ));
          basicActions.add(hangupBtn);
          basicActions.add(ActionButton(
            iconColor: Colors.black.withOpacity(0.2),
            title: pitelCall.audioMuted ? 'unmute' : 'mute',
            icon: pitelCall.audioMuted ? Icons.mic_off : Icons.mic,
            checked: pitelCall.audioMuted,
            fillColor: Colors.black.withOpacity(0.1),
            onPressed: () => {},
          ));
        }
        break;
      case PitelCallStateEnum.STREAM:
        basicActions = [];
        if (voiceonly)
          basicActions.add(ActionButton(
            iconColor: Colors.black.withOpacity(0.2),
            title: _speakerOn ? 'speaker off' : 'speaker on',
            icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
            fillColor: Colors.black.withOpacity(0.1),
            checked: _speakerOn,
            onPressed: () => {},
          ));
        basicActions.add(ActionButton(
          title: "hangup",
          onPressed: () {
            _disposeRenderers();
            context.pop();
            pitelCall.removeListener(this);
          },
          icon: Icons.call_end,
          fillColor: Colors.red,
        ));
        basicActions.add(ActionButton(
          iconColor: Colors.black.withOpacity(0.2),
          title: pitelCall.audioMuted ? 'unmute' : 'mute',
          icon: pitelCall.audioMuted ? Icons.mic_off : Icons.mic,
          checked: pitelCall.audioMuted,
          fillColor: Colors.black.withOpacity(0.1),
          onPressed: () => {},
        ));

        break;
      case PitelCallStateEnum.CONNECTING:
        break;
      case PitelCallStateEnum.MUTED:
      case PitelCallStateEnum.UNMUTED:
      case PitelCallStateEnum.ACCEPTED:
      case PitelCallStateEnum.CONFIRMED:
        {
          if (voiceonly) {
            basicActions.add(ActionButton(
              title: _speakerOn ? 'speaker off' : 'speaker on',
              icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
              fillColor: Colors.black.withOpacity(0.1),
              checked: _speakerOn,
              onPressed: () => _toggleSpeaker(),
            ));
          }
          basicActions.add(hangupBtn);
          basicActions.add(ActionButton(
            title: pitelCall.audioMuted ? 'unmute' : 'mute',
            icon: pitelCall.audioMuted ? Icons.mic_off : Icons.mic,
            checked: pitelCall.audioMuted,
            fillColor: Colors.black.withOpacity(0.1),
            onPressed: () => pitelCall.mute(),
          ));
        }
        break;
      case PitelCallStateEnum.FAILED:
      case PitelCallStateEnum.ENDED:
        basicActions.add(hangupBtnInactive);
        break;
      default:
        break;
    }

    var actionWidgets = <Widget>[];

    actionWidgets.add(Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: basicActions)));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: actionWidgets);
  }

  Widget _buildContent() {
    var stackWidgets = <Widget>[];

    if (!voiceonly &&
        pitelCall.remoteStream != null &&
        pitelCall.remoteRenderer != null) {
      stackWidgets.add(Center(
        child: PitelRTCVideoView(pitelCall.remoteRenderer!),
      ));
    }

    if (!voiceonly &&
        pitelCall.localStream != null &&
        pitelCall.localRenderer != null) {
      stackWidgets.add(Container(
        alignment: Alignment.topRight,
        child: AnimatedContainer(
          height: 0,
          width: 0,
          alignment: Alignment.topRight,
          duration: const Duration(milliseconds: 300),
          child: PitelRTCVideoView(pitelCall.localRenderer!),
        ),
      ));
    }

    stackWidgets.addAll([
      Positioned(
        top: voiceonly ? 48 : 6,
        left: 0,
        right: 0,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.all(6),
              child: WidgetText(
                title: 'VOICE CALL',
                style: AppStyle.DEFAULT_18_BOLD,
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(6),
              child: WidgetText(
                  title: '${pitelCall.remoteIdentity}',
                  style: AppStyle.DEFAULT_18_BOLD.copyWith(fontSize: 32)),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(6),
              child: StreamBuilder<PitelCallStateEnum>(
                  stream: _state,
                  builder: (context, snapshot) {
                    return WidgetText(
                        title: getTextTitle(_state.value),
                        style: AppStyle.DEFAULT_18_BOLD);
                  }),
            ))
          ],
        )),
      ),
    ]);

    return Stack(
      children: stackWidgets,
    );
  }

  String getTextTitle(PitelCallStateEnum _status) {
    switch (_status) {
      case PitelCallStateEnum.CONFIRMED:
        return _timeLabel;
      case PitelCallStateEnum.PROGRESS:
        return 'Đang kết nối';
      case PitelCallStateEnum.STREAM:
        return 'Đang đổ chuông';
      case PitelCallStateEnum.ENDED:
        return 'Kết thúc cuộc gọi';
      case PitelCallStateEnum.NONE:
        return 'Đang gọi đến';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#D0F1EB").withOpacity(0.9),
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Gọi điện tổng đài",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Container(
        child: pitelCall.isConnected && pitelCall.isHaveCall
            ? _buildContent()
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: pitelCall.isConnected && pitelCall.isHaveCall
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
              child: SizedBox(
                width: 320,
                child: _buildActionButtons(),
              ),
            )
          : const SizedBox(),
    );
  }
}
