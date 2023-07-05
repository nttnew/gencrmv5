import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../src/color.dart';
import '../src/preferences_key.dart';
import '../src/styles.dart';
import '../storages/share_local.dart';
import 'show_dialog.dart';
import 'widget_text.dart';

class WidgetFingerPrint extends StatefulWidget {
  const WidgetFingerPrint({Key? key}) : super(key: key);

  @override
  State<WidgetFingerPrint> createState() => _WidgetFingerPrintState();
}

class _WidgetFingerPrintState extends State<WidgetFingerPrint> {
  late final BehaviorSubject<bool> supportBiometric;
  late final BehaviorSubject<bool> fingerPrintIsCheck;
  String? canLoginWithFingerPrint;
  late final LocalAuthentication auth;

  @override
  void initState() {
    auth = LocalAuthentication();
    fingerPrintIsCheck = BehaviorSubject();
    supportBiometric = BehaviorSubject();
    canLoginWithFingerPrint =
        shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT);
    if (canLoginWithFingerPrint == null ||
        canLoginWithFingerPrint == "" ||
        canLoginWithFingerPrint == "false") {
      fingerPrintIsCheck.add(false);
    } else {
      if (canLoginWithFingerPrint == "true") {
        fingerPrintIsCheck.add(true);
      }
    }
    checkBiometricEnable();
    super.initState();
  }

  Future<void> checkBiometricEnable() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    if (!canAuthenticateWithBiometrics) {
      return;
    }

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      supportBiometric.add(true);
    }
  }

  Future<void> useBiometric({required bool value}) async {
    if (!value) {
      fingerPrintIsCheck.sink.add(false);
      shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, "false");
      return;
    }
    try {
      final String reason =
          AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id ??
              '';
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        fingerPrintIsCheck.add(true);
        shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, "true");
      } else {
        ShowDialogCustom.showDialogBase(
          title: AppLocalizations.of(Get.context!)?.notification,
          content:
              AppLocalizations.of(Get.context!)?.login_fail_please_try_again ??
                  '',
        );
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: supportBiometric,
      builder: (_, supportBiometric) {
        return StreamBuilder<bool>(
          stream: fingerPrintIsCheck,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WidgetText(
                          title:
                              "${AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id}: ",
                          style:
                              AppStyle.DEFAULT_16.copyWith(color: COLORS.GREY)),
                      !(snapshot.data ?? false)
                          ? WidgetText(
                              title: AppLocalizations.of(Get.context!)?.no,
                              style: AppStyle.DEFAULT_16.copyWith(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600))
                          : WidgetText(
                              title: AppLocalizations.of(Get.context!)?.yes,
                              style: AppStyle.DEFAULT_16.copyWith(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Switch(
                    value: snapshot.data ?? false,
                    onChanged: (value) {
                      if (!(supportBiometric.data ?? false)) {
                        ShowDialogCustom.showDialogBase(
                          title:
                              AppLocalizations.of(Get.context!)?.notification,
                          content: AppLocalizations.of(Get.context!)
                              ?.the_device_has_not_setup_fingerprint_face,
                        );
                      } else {
                        useBiometric(value: value);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
