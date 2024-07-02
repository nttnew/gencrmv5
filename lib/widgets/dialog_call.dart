import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pitel_voip/pitel_sdk/pitel_call.dart';
import 'package:flutter_pitel_voip/pitel_sdk/pitel_client.dart';
import 'package:flutter_pitel_voip/services/models/push_notif_params.dart';
import 'package:flutter_pitel_voip/services/pitel_service.dart';
import 'package:flutter_pitel_voip/sip/src/sip_ua_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/login/login_bloc.dart';
import '../models/call_history_model.dart';
import '../screens/call/init_app_call.dart';
import '../src/src_index.dart';
import '../../l10n/key_text.dart';

class DialogCall extends ConsumerStatefulWidget {
  final String phone;
  final String name;

  const DialogCall({
    Key? key,
    required this.phone,
    required this.name,
  }) : super(key: key);

  @override
  ConsumerState<DialogCall> createState() => _DialogCallState();
}

class _DialogCallState extends ConsumerState<DialogCall> {
  final PitelCall pitelCall = PitelClient.getInstance().pitelCall;

  void registerFunc() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final PushNotifParams pushNotifParams = PushNotifParams(
      teamId: TEAM_ID,
      bundleId: packageInfo.packageName,
    );

    final pitelClient = PitelServiceImpl();
    final pitelSetting =
        await pitelClient.setExtensionInfo(getSipInfo(), pushNotifParams);
    ref.read(pitelSettingProvider.notifier).state = pitelSetting;
  }

  void _handleRegisterCall() async {
    final PitelSettings? pitelSetting = ref.watch(pitelSettingProvider);
    if (pitelSetting != null) {
      pitelCall.register(pitelSetting);
    } else {
      registerFunc();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("ACCEPT_CALL", true);
  }

  void _handleCall(BuildContext context, [bool voiceonly = false]) {
    var dest = widget.phone.trim().replaceAll(' ', '');
    if (dest.isEmpty) {
    } else {
      pitelCall.outGoingCall(
        phoneNumber: dest,
        handleRegisterCall: _handleRegisterCall,
      );
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
                    title: widget.phone,
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
                        text: widget.phone.trim().replaceAll(' ', ''),
                      ),
                    ).then((_) {
                      showToast(getT(KeyT.copy_success));
                    });
                  },
                  child: WidgetText(
                      title: getT(KeyT.copy),
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri(
                        scheme: "tel",
                        path: widget.phone.trim().replaceAll(' ', '')));
                  },
                  child: WidgetText(
                      title: getT(KeyT.call),
                      style: AppStyle.DEFAULT_18_BOLD
                          .copyWith(fontSize: 24, fontWeight: FontWeight.w600)),
                ),
                if (LoginBloc.of(context).checkRegisterSuccess()) ...[
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      saveHistoryCall(
                        CallHistoryModel(
                          phone: widget.phone.trim().replaceAll(' ', ''),
                          name: widget.name,
                          time: DateTime.now().toString(),
                        ),
                      );
                      _handleCall(context, true);
                    },
                    child: WidgetText(
                        title: getT(KeyT.call_operator),
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
