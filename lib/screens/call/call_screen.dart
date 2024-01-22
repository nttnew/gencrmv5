import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plugin_pitel/component/pitel_call_state.dart';
import 'package:plugin_pitel/component/pitel_rtc_video_view.dart';
import 'package:plugin_pitel/component/sip_pitel_helper_listener.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_call.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:plugin_pitel/sip/sip_ua.dart';
import '../../src/src_index.dart';
import '../../widgets/cupertino_loading.dart';
import 'ripple_logo.dart';
import 'action_button.dart';
import 'package:wakelock/wakelock.dart';

class CallScreenWidget extends ConsumerStatefulWidget {
  CallScreenWidget({
    Key? key,
    this.receivedBackground = false,
    this.modelScreen,
    this.title,
  }) : super(key: key);

  final PitelCall _pitelCall = PitelClient.getInstance().pitelCall;
  final bool receivedBackground;
  final String? modelScreen;
  final String? title;

  @override
  ConsumerState<CallScreenWidget> createState() => _MyCallScreenWidget();
}

class _MyCallScreenWidget extends ConsumerState<CallScreenWidget>
    with WidgetsBindingObserver
    implements SipPitelHelperListener {
  PitelCall get pitelCall => widget._pitelCall;

  String _timeLabel = '';
  Timer? _timer;
  bool _speakerOn = false;
  PitelCallStateEnum _state = PitelCallStateEnum.NONE;
  bool calling = false;
  bool _isBacked = false;
  String _callId = '';

  bool get voiceOnly => pitelCall.isVoiceOnly();

  String? get direction => pitelCall.direction;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    handleCall();
    pitelCall.addListener(this);
    if (voiceOnly) {
      _initRenderers();
    }
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
        back();
      }
      if (pitelCall.direction == null && _state == PitelCallStateEnum.NONE) {
        back();
      }
    }
  }

  void back() {
    Navigator.pushReplacementNamed(
      context,
      widget.modelScreen ?? ROUTE_NAMES.MAIN,
      arguments: widget.title,
    );
  }

  void handleCall() {
    if (Platform.isAndroid) {
      if (direction != 'OUTGOING') {
        pitelCall.answer();
        Wakelock.enable();
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
        _timer?.cancel();
      }
    });
  }

  // INIT: Initialize Pitel
  void _initRenderers() async {
    if (!voiceOnly) {
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
      back();
    }
  }

  // Handle hangup and reset timer
  void _handleHangup() {
    if (Platform.isAndroid) {
      Wakelock.disable();
    }
    pitelCall.hangup(callId: _callId);
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  // Turn on/off speaker
  void _toggleSpeaker() {
    if (pitelCall.localStream != null) {
      _speakerOn = !_speakerOn;
      pitelCall.enableSpeakerphone(_speakerOn);
      setState(() {});
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
      fillColor: COLORS.RED,
    );

    var hangupBtnInactive = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(
          title: "hangup",
          onPressed: () {
            back();
          },
          icon: Icons.call_end,
          fillColor: Colors.red,
        ),
        Text(
          getT(
            KeyT.close,
          ),
          style: AppStyle.DEFAULT_16_BOLD.copyWith(),
        )
      ],
    );

    var basicActions = <Widget>[];

    basicActions.add(ActionButton(
      iconColor: calling
          ? Colors.black.withOpacity(0.6)
          : Colors.grey.withOpacity(0.6),
      fillColor: calling
          ? Colors.black.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
      title: pitelCall.audioMuted ? 'unmute' : 'mute',
      icon: pitelCall.audioMuted ? Icons.mic_off : Icons.mic,
      checked: pitelCall.audioMuted,
      onPressed: () => calling ? pitelCall.mute(callId: _callId) : {},
    ));

    basicActions.add(hangupBtn);

    if (voiceOnly) {
      basicActions.add(ActionButton(
        iconColor: _speakerOn ? COLORS.GREEN : Colors.black.withOpacity(0.6),
        fillColor: Colors.black.withOpacity(0.1),
        title: _speakerOn ? 'speaker off' : 'speaker on',
        icon: _speakerOn ? Icons.volume_up : Icons.volume_up_outlined,
        checked: _speakerOn,
        onPressed: () => _toggleSpeaker(),
      ));
    }
    switch (_state) {
      case PitelCallStateEnum.NONE:
      case PitelCallStateEnum.PROGRESS:
        break;
      case PitelCallStateEnum.STREAM:
        break;
      case PitelCallStateEnum.CONNECTING:
        break;
      case PitelCallStateEnum.MUTED:
      case PitelCallStateEnum.UNMUTED:
      case PitelCallStateEnum.ACCEPTED:
      case PitelCallStateEnum.CONFIRMED:
        calling = true;
        {
          if (_timeLabel == '' && calling) {
            _timeLabel = '00:00';
            _startTimer();
          }
        }
        break;
      case PitelCallStateEnum.FAILED:
      case PitelCallStateEnum.ENDED:
        _timer?.cancel();
        basicActions = [hangupBtnInactive];
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

    if (!voiceOnly &&
        pitelCall.remoteStream != null &&
        pitelCall.remoteRenderer != null) {
      stackWidgets.add(
        Center(
          child: PitelRTCVideoView(pitelCall.remoteRenderer!),
        ),
      );
    }

    if (!voiceOnly &&
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
          top: 0,
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
      body: Container(
        child: pitelCall.isConnected && pitelCall.isHaveCall
            ? _buildContent()
            : const Center(
                child: CupertinoLoading(),
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
