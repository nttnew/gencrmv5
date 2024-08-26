import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../l10n/key_text.dart';
import '../../../../models/setting_model.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/appbar_base.dart';
import '../../../../widgets/widget_text.dart';
import '../menu_drawer/widget_item_list_menu.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
    required this.onSelectLang,
  }) : super(key: key);
  final Function onSelectLang;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final BehaviorSubject<bool> _supportBiometric;
  late final BehaviorSubject<bool> _fingerPrintIsCheck;
  String? _canLoginWithFingerPrint;
  List<LanguagesResponse> _resultLanguage = [];
  late final LocalAuthentication _auth;
  List<ModelSetting> _listSetting = [];

  @override
  void initState() {
    _listSetting.add(
      ModelSetting(
        KeyT.account_information,
        ICONS.IC_USER_PNG,
        () {
          AppNavigator.navigateInformationAccount();
        },
      ),
    );
    _listSetting.add(
      ModelSetting(
        KeyT.introduce,
        ICONS.IC_ABOUT_US_PNG,
        () {
          AppNavigator.navigateAboutUs();
        },
      ),
    );
    _listSetting.add(
      ModelSetting(
        KeyT.policy_terms,
        ICONS.IC_POLICY_PNG,
        () {
          AppNavigator.navigatePolicy();
        },
      ),
    );
    _listSetting.add(
      ModelSetting(
        KeyT.change_password,
        ICONS.IC_CHANGE_PASS_WORK_PNG,
        () {
          AppNavigator.navigateChangePassword();
        },
      ),
    );
    _getListLanguagesBE();
    _auth = LocalAuthentication();
    _fingerPrintIsCheck = BehaviorSubject();
    _supportBiometric = BehaviorSubject();
    _canLoginWithFingerPrint =
        shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT);
    if (_canLoginWithFingerPrint == null ||
        _canLoginWithFingerPrint == '' ||
        _canLoginWithFingerPrint == 'false') {
      _fingerPrintIsCheck.add(false);
    } else {
      if (_canLoginWithFingerPrint == 'true') {
        _fingerPrintIsCheck.add(true);
      }
    }
    _checkBiometricEnable();
    super.initState();
  }

  Future<void> _checkBiometricEnable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    if (!canAuthenticateWithBiometrics) {
      return;
    }
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    if (availableBiometrics.isNotEmpty) {
      _supportBiometric.add(true);
    }
  }

  Future<void> _useBiometric({required bool value}) async {
    if (!value) {
      _fingerPrintIsCheck.sink.add(false);
      shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, 'false');
      return;
    }
    try {
      final String reason = getT(KeyT.login_with_fingerprint_face_id);
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        _fingerPrintIsCheck.add(true);
        shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, 'true');
      } else {
        ShowDialogCustom.showDialogBase(
          title: getT(KeyT.notification),
          content: getT(KeyT.login_fail_please_try_again),
        );
      }
    } catch (e) {
      return;
    }
  }

  void _getListLanguagesBE() {
    String data = shareLocal.getString(PreferencesKey.LANGUAGE_BE) ?? '';
    if (data != '' && _resultLanguage != []) {
      final result = json.decode(data) as List<dynamic>;
      _resultLanguage =
          result.map((e) => LanguagesResponse.fromJson(e)).toList();
      LoginBloc.of(context).getLanguage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBaseNormal(getT(KeyT.setting)),
      body: Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
              bottom: 24,
              top: 12,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _listSetting.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      _listSetting[index].onTap();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 16,
                        right: 20,
                        left: 20,
                      ),
                      child: WidgetItemListMenu(
                        icon: _listSetting[index].image,
                        title: getT(_listSetting[index].keyTitle),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: COLORS.WHITE,
                    border: Border.all(color: COLORS.GREY_400, width: 0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        4,
                      ),
                    ),
                  ),
                  child: Center(
                    child: DropdownButton2<LanguagesResponse>(
                      isDense: true,
                      hint: StreamBuilder<LanguagesResponse>(
                          stream: LoginBloc.of(context).localeLocalSelect,
                          builder: (context, snapshot) {
                            final languagesSnap = snapshot.data;
                            return languagesSnap != null
                                ? _itemLang(languagesSnap)
                                : SizedBox();
                          }),
                      icon: SizedBox.shrink(),
                      underline: SizedBox.shrink(),
                      dropdownWidth: 150,
                      dropdownMaxHeight: 200,
                      onChanged: (LanguagesResponse? value) {},
                      barrierColor: Colors.grey.withOpacity(0.4),
                      items: _resultLanguage
                          .map((items) => DropdownMenuItem<LanguagesResponse>(
                                onTap: () async {
                                  LoginBloc.of(context).setLanguage(items);
                                  await LoginBloc.of(context).getMenuMain();
                                  widget.onSelectLang();
                                  setState(() {});
                                },
                                value: items,
                                child: _itemLang(items),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await LoginBloc.of(context).getMenuMain();
                    await LoginBloc.of(context).getVersionInfoCar();
                    await LoginBloc.of(context).reloadLang();
                    widget.onSelectLang();
                    setState(() {});
                  },
                  child: Image.asset(
                    ICONS.IC_RELOAD_PNG,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<bool>(
            stream: _supportBiometric,
            builder: (_, supportBiometric) {
              return StreamBuilder<bool>(
                stream: _fingerPrintIsCheck,
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: WidgetText(
                            title:
                                '${getT(KeyT.login_with_fingerprint_face_id)}: ',
                            style: AppStyle.DEFAULT_16.copyWith(
                              color: COLORS.GREY,
                            ),
                          ),
                        ),
                        Switch(
                          value: snapshot.data ?? false,
                          onChanged: (value) {
                            if (!(supportBiometric.data ?? false)) {
                              ShowDialogCustom.showDialogBase(
                                title: getT(KeyT.notification),
                                content: getT(KeyT
                                    .the_device_has_not_setup_fingerprint_face),
                              );
                            } else {
                              _useBiometric(value: value);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          AppValue.vSpaceTiny,
          Center(
            child: WidgetText(
              title: initAddressApplication(),
              style: AppStyle.DEFAULT_16.copyWith(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          AppValue.vSpaceTiny,
          Center(
            child: WidgetText(
              title: 'Version: 2.4.6',
              style: AppStyle.DEFAULT_16.copyWith(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _itemLang(LanguagesResponse items) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Image.network(
              getFlagCountry(
                items.flag ?? '',
              ),
              fit: BoxFit.contain,
            ),
            height: 24,
            width: 24,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            items.label ?? '',
            style: AppStyle.DEFAULT_14.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
