import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/pitel_rtc_video_view.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';

import '../../src/src_index.dart';
import '../../widgets/action_button.dart';
import '../../widgets/ripple_logo.dart';
import '../../widgets/widget_text.dart';

class CallScreenWidget extends ConsumerStatefulWidget {
  CallScreenWidget(
      {Key? key, this.receivedBackground = false, this.modelScreen})
      : super(key: key);
  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  final bool receivedBackground;
  final String? modelScreen;
  @override
  ConsumerState<CallScreenWidget> createState() => _MyCallScreenWidget();
}

class _MyCallScreenWidget extends ConsumerState<CallScreenWidget>
    with WidgetsBindingObserver
    implements SipPitelHelperListener {
  PitelCall get pitelCall => widget._pitelCall;

  String _timeLabel = '00:00';
  late Timer _timer;
  bool _speakerOn = false;
  PitelCallStateEnum _state = PitelCallStateEnum.NONE;
  bool calling = false;
  bool _isBacked = false;
  String _callId = '';

  bool get voiceonly => pitelCall.isVoiceOnly();

  String? get direction => pitelCall.direction;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    handleCall();

    pitelCall.addListener(this);
    if (voiceonly) {
      _initRenderers();
    }
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!pitelCall.isConnected || !pitelCall.isHaveCall) {
        // Navigate to your first screen
        Navigator.of(context).popUntil(
            ModalRoute.withName(widget.modelScreen ?? ROUTE_NAMES.MAIN));
      }
    }
  }

  void handleCall() {
    if (Platform.isAndroid) {
      if (direction != 'OUTGOING') {
        //! Answer when incoming call
        pitelCall.answer();
      }
    }
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

  // STATUS: Handle call state
  @override
  void callStateChanged(String callId, PitelCallState callState) {
    setState(() {
      _state = callState.state;
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
  void onCallReceived(String callId) {}

  @override
  void onCallInitiated(String callId) {}

  // Back to Home screen
  void _backToDialPad() {
    if (mounted && !_isBacked) {
      if (direction != 'OUTGOING') {
        FlutterCallkitIncoming.endAllCalls();
      }
      _isBacked = true;
      Navigator.of(context).popUntil(
          ModalRoute.withName(widget.modelScreen ?? ROUTE_NAMES.MAIN));
    }
  }

  // Handle hangup and reset timer
  void _handleHangup() {
    pitelCall.hangup(callId: _callId);
    if (_timer.isActive) {
      _timer.cancel();
    }
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
    switch (_state) {
      case PitelCallStateEnum.NONE:
      case PitelCallStateEnum.PROGRESS:
        if (direction == 'OUTGOING') {
          basicActions = [hangupBtn];
        }
        break;
      case PitelCallStateEnum.STREAM:
        basicActions = [hangupBtn];

        basicActions = [
          ActionButton(
            title: "hangup",
            onPressed: () {
              _disposeRenderers();
              Navigator.of(context).popUntil(
                  ModalRoute.withName(widget.modelScreen ?? ROUTE_NAMES.MAIN));
              pitelCall.removeListener(this);
            },
            icon: Icons.call_end,
            fillColor: Colors.red,
          ),
        ];
        break;
      case PitelCallStateEnum.CONNECTING:
        break;
      case PitelCallStateEnum.MUTED:
      case PitelCallStateEnum.UNMUTED:
      case PitelCallStateEnum.ACCEPTED:
      case PitelCallStateEnum.CONFIRMED:
        calling = true;
        {
          if (voiceonly) {
            basicActions.add(ActionButton(
              iconColor: Colors.black.withOpacity(0.6),
              fillColor: Colors.black.withOpacity(0.1),
              title: _speakerOn ? 'speaker off' : 'speaker on',
              icon: _speakerOn ? Icons.volume_off : Icons.volume_up,
              checked: _speakerOn,
              onPressed: () => _toggleSpeaker(),
            ));
          }
          basicActions.add(hangupBtn);
          basicActions.add(ActionButton(
            iconColor: Colors.black.withOpacity(0.6),
            fillColor: Colors.black.withOpacity(0.1),
            title: pitelCall.audioMuted ? 'unmute' : 'mute',
            icon: pitelCall.audioMuted ? Icons.mic_off : Icons.mic,
            checked: pitelCall.audioMuted,
            onPressed: () => pitelCall.mute(callId: _callId),
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

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: basicActions.length == 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: basicActions);
  }

  Widget _buildContent() {
    var stackWidgets = <Widget>[];

    if (!voiceonly &&
        pitelCall.remoteStream != null &&
        pitelCall.remoteRenderer != null) {
      stackWidgets.add(
        Center(
          child: PitelRTCVideoView(pitelCall.remoteRenderer!),
        ),
      );
    }

    if (!voiceonly &&
        pitelCall.localStream != null &&
        pitelCall.localRenderer != null) {
      stackWidgets.add(
        Container(
          alignment: Alignment.topRight,
          child: AnimatedContainer(
            height: 0,
            width: 0,
            alignment: Alignment.topRight,
            duration: const Duration(milliseconds: 300),
            child: PitelRTCVideoView(pitelCall.localRenderer!),
          ),
        ),
      );
    }

    stackWidgets.addAll(
      [
        Positioned(
          top: voiceonly ? -48 : -6,
          left: 0,
          right: 0,
          child: RippleLogo(
            pitelCall: pitelCall,
            timeLabel: _timeLabel,
            isCall: calling,
          ),
        ),
      ],
    );
    return Stack(
      children: stackWidgets,
    );
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
          child: WidgetText(
            title: "Gọi điện tổng đài",
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
          ? Container(
              margin: EdgeInsets.all(40),
              child: _buildActionButtons(),
            )
          : const SizedBox(),
    );
  }
}
