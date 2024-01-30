import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pitel_voip/flutter_pitel_voip.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/src/src_index.dart';
import 'init_app_call.dart';

class CallPage extends ConsumerWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callStateController);
    return CallScreen(
      txtOutgoing: getT(KeyT.txt_outgoing),
      txtIncoming: getT(KeyT.txt_incoming),
      txtWaiting: getT(KeyT.txt_waiting),
      txtSpeaker: getT(KeyT.txt_speaker),
      txtMute: getT(KeyT.txt_mute),
      titleTextStyle: AppStyle.DEFAULT_18,
      callState: callState,
      onCallState: (PitelCallStateEnum res) {
        ref.read(callStateController.notifier).state = res;
      },
      bgColor: COLORS.PRIMARY_COLOR,
    );
  }
}
