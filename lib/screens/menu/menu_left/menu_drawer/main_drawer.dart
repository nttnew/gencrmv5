import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../bloc/get_infor_acc/get_infor_acc_bloc.dart';
import '../../../../l10n/l10n.dart';
import '../../../../models/button_menu_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../../../../src/app_const.dart';
import '../../../../src/src_index.dart';
import '../../../../storages/share_local.dart';
import '../../../../widgets/widget_text.dart';
import 'widget_item_list_menu.dart';

class MainDrawer extends StatefulWidget {
  final Function? onPress;

  const MainDrawer({this.onPress});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<ButtonMenuModel> listMenu = [];
  List _elements = [];
  late final BehaviorSubject<bool> supportBiometric;
  late final BehaviorSubject<bool> fingerPrintIsCheck;
  String? canLoginWithFingerPrint;
  List<LanguagesResponse> resultLanguage = [];
  late final LocalAuthentication auth;

  @override
  void initState() {
    getMenu();
    getListLanguagesBE();
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

  void getListLanguagesBE() {
    String data = shareLocal.getString(PreferencesKey.LANGUAGE_BE) ?? "";
    if (data != '' && resultLanguage != []) {
      final result = json.decode(data) as List<dynamic>;
      resultLanguage =
          result.map((e) => LanguagesResponse.fromJson(e)).toList();
      LoginBloc.of(context).getLanguage();
    }
  }

  getMenu() async {
    _elements.add({
      'id': '1',
      'title': AppLocalizations.of(Get.context!)?.home_page ?? '',
      'image': ICONS.IC_MENU_HOME_PNG,
      'group': '1',
      'isAdmin': false,
    });
    String menu = await shareLocal.getString(PreferencesKey.MENU);
    List listM = jsonDecode(menu);
    for (int i = 0; i < listM.length; i++) {
      _elements.add({
        'id': listM[i]['id'],
        'title': listM[i]['name'],
        'image': ModuleMy.getIcon(listM[i]['id']),
        'group': '1',
        'isAdmin': false,
      });
    }
    _elements = [
      ..._elements,
      ...[
        {
          'id': 'report',
          'title': AppLocalizations.of(Get.context!)?.report,
          'image': ICONS.IC_REPORT_PNG,
          'group': '1',
          'isAdmin': false
        },
        {
          'id': '2',
          'title': AppLocalizations.of(Get.context!)?.account_information,
          'image': ICONS.IC_USER_PNG,
          'group': '1',
          'isAdmin': false
        },
        {
          'id': '3',
          'title': AppLocalizations.of(Get.context!)?.introduce,
          'image': ICONS.IC_ABOUT_US_PNG,
          'group': '1',
          'isAdmin': false,
        },
        {
          'id': '4',
          'title': AppLocalizations.of(Get.context!)?.policy_terms,
          'image': ICONS.IC_POLICY_PNG,
          'group': '1',
          'isAdmin': false,
        },
        {
          'id': '5',
          'title': AppLocalizations.of(Get.context!)?.change_password,
          'image': ICONS.IC_CHANGE_PASS_WORK_PNG,
          'group': '1',
          'isAdmin': false,
        },
      ]
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLORS.WHITE,
      width: AppValue.widths * 0.85,
      height: AppValue.heights,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 35,
              left: 10,
              right: 10,
            ),
            color: COLORS.SECONDS_COLOR,
            height: AppValue.heights * 0.18,
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<GetInforAccBloc, GetInforAccState>(
                    builder: (context, state) {
                      if (state is UpdateGetInforAccState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WidgetNetworkImage(
                              isAvatar: true,
                              image: state.inforAcc.avatar ?? "",
                              width: 75,
                              height: 75,
                              borderRadius: 75,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetText(
                                      title: state.inforAcc.fullname ?? '',
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    ),
                                    AppValue.vSpaceTiny,
                                    WidgetText(
                                      title:
                                          state.inforAcc.department_name ?? '',
                                      style: AppStyle.DEFAULT_16.copyWith(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WidgetNetworkImage(
                              isAvatar: true,
                              image: "",
                              width: 75,
                              height: 75,
                              borderRadius: 75,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetText(
                                    title: '',
                                    style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  AppValue.vSpaceTiny,
                                  WidgetText(
                                    title: '',
                                    style: AppStyle.DEFAULT_16.copyWith(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                      color: COLORS.BLACK.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(
                        6,
                      ))),
                  child: Center(
                    child: DropdownButton2<LanguagesResponse>(
                      hint: StreamBuilder<LanguagesResponse>(
                          stream: LoginBloc.of(context).localeLocal,
                          builder: (context, snapshot) {
                            final languagesSnap = snapshot.data;

                            return languagesSnap != null
                                ? Row(
                                    children: [
                                      Container(
                                        child: Image.network(
                                          getFlagCountry(
                                            languagesSnap.flag ?? '',
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(
                                          L10n.getLocale(
                                                  languagesSnap.name ?? '')
                                              .toString()
                                              .toLowerCase(),
                                          style: AppStyle.DEFAULT_14_BOLD,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox();
                          }),
                      icon: Container(),
                      underline: Container(),
                      onChanged: (LanguagesResponse? value) {},
                      dropdownWidth: 90,
                      barrierColor: Colors.grey.withOpacity(0.4),
                      items: resultLanguage
                          .map((items) => DropdownMenuItem<LanguagesResponse>(
                                onTap: () {
                                  LoginBloc.of(context).setLanguage(items);
                                },
                                value: items,
                                child: Row(
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
                                      L10n.getLocale(items.name ?? '')
                                          .toString()
                                          .toLowerCase(),
                                      style: AppStyle.DEFAULT_14_BOLD,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: _elements.length > 0
                  ? ListView.builder(
                      itemCount: _elements.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return _elements.length != index
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          widget.onPress!(_elements[index]),
                                      child: WidgetItemListMenu(
                                        icon: _elements[index]['image'],
                                        title: _elements[index]['title'],
                                      ),
                                    ),
                                    AppValue.vSpaceSmall,
                                  ],
                                ),
                              )
                            : StreamBuilder<bool>(
                                stream: supportBiometric,
                                builder: (_, supportBiometric) {
                                  return StreamBuilder<bool>(
                                    stream: fingerPrintIsCheck,
                                    builder: (context, snapshot) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          bottom: 20,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  WidgetText(
                                                      title:
                                                          "${AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id}: ",
                                                      style: AppStyle.DEFAULT_16
                                                          .copyWith(
                                                              color:
                                                                  COLORS.GREY)),
                                                  !(snapshot.data ??
                                                          false)
                                                      ? WidgetText(
                                                          title:
                                                              AppLocalizations.of(Get
                                                                      .context!)
                                                                  ?.no,
                                                          style: AppStyle
                                                              .DEFAULT_16
                                                              .copyWith(
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))
                                                      : WidgetText(
                                                          title: AppLocalizations.of(
                                                                  Get.context!)
                                                              ?.yes,
                                                          style: AppStyle.DEFAULT_16
                                                              .copyWith(
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                ],
                                              ),
                                            ),
                                            Switch(
                                              value: snapshot.data ?? false,
                                              onChanged: (value) {
                                                if (!(supportBiometric.data ??
                                                    false)) {
                                                  ShowDialogCustom
                                                      .showDialogBase(
                                                    title: AppLocalizations.of(
                                                            Get.context!)
                                                        ?.notification,
                                                    content: AppLocalizations
                                                            .of(Get.context!)
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
                      },
                    )
                  : SizedBox()),
          AppValue.vSpaceTiny,
          Center(
            child: WidgetText(
              title: initAddressApplication(),
              style: AppStyle.DEFAULT_16.copyWith(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
            ),
          ),
          AppValue.vSpaceTiny,
          Center(
            child: WidgetText(
              title: 'Version: 2.1.8',
              style: AppStyle.DEFAULT_16.copyWith(
                  fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
            ),
          ),
          WidgetButton(
            onTap: () {
              ShowDialogCustom.showDialogBase(
                  colorButton2: COLORS.GREY.withOpacity(0.5),
                  colorButton1: COLORS.SECONDS_COLOR,
                  onTap2: () {
                    AppNavigator.navigateLogout();
                    AuthenticationBloc.of(context)
                        .add(AuthenticationLogoutRequested());
                    LoginBloc.of(context).logout(context);
                  });
            },
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            text: AppLocalizations.of(Get.context!)?.logout,
            textColor: COLORS.BLACK,
            backgroundColor: COLORS.GREY.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
