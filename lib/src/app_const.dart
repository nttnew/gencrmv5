import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plugin_pitel/services/models/pn_push_params.dart';
import 'package:plugin_pitel/services/pitel_service.dart';
import 'package:plugin_pitel/services/sip_info_data.dart';
import '../bloc/login/login_bloc.dart';
import '../storages/share_local.dart';
import '../widgets/widget_text.dart';

const int IS_AFTER = 1;
const int IS_BEFORE = 0;
const String BUNDLE_ID = 'com.gencrm';
const String PACKAGE_ID = 'vn.gen_crm';
const String TEAM_ID = 'AEY48KNZRS';
const int PRODUCT_TYPE = 99;
const int PRODUCT_CUSTOMER_TYPE = 98;
const int EDIT_JOB = 5;
const int CV_PRODUCT_CUSTOMER_TYPE = 97;
const int HD_PRODUCT_CUSTOMER_TYPE = 96;
const int HT_PRODUCT_CUSTOMER_TYPE = 95;
const int CH_PRODUCT_CUSTOMER_TYPE = 94;
const int ADD_CUSTOMER = 1;
const int ADD_CHANCE_JOB = 31;
const int ADD_CHANCE = 3;
const int ADD_CLUE = 2;
const int ADD_SUPPORT = 6;
const int ADD_JOB = 5;
const int ADD_CLUE_JOB = 21;
const int ADD_JOB_CONTRACT = 42;
const int ADD_SUPPORT_CONTRACT = 41;
const int ADD_CLUE_CUSTOMER = 11;
const int ADD_CHANCE_CUSTOMER = 12;
const int ADD_JOB_CUSTOMER = 14;
const int ADD_SUPPORT_CUSTOMER = 15;
const int EDIT_SUPPORT = 6;
const int EDIT_CHANCE = 3;
const int EDIT_CLUE = 2;
const int EDIT_CUSTOMER = 1;
const LOADING = 'loading';

class TypeCheckIn {
  static const CHECK_IN = 'checkin';
  static const CHECK_OUT = 'checkout';
}

//type="checkin" và type="checkout"
TextStyle hintTextStyle() => TextStyle(
    fontFamily: "Quicksand",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: COLORS.BLACK);

TextStyle titlestyle() => TextStyle(
    fontFamily: "Quicksand",
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: COLORS.BLACK);

TextStyle titlestyleNgTheoDoi() => TextStyle(
    fontFamily: "Quicksand",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: COLORS.BLACK);

void loginSessionExpired() {
  ShowDialogCustom.showDialogBase(
    title: MESSAGES.NOTIFICATION,
    content: MESSAGES.PHIEN_DANG_NHAP_HET,
    onTap1: () {
      AppNavigator.navigateLogout();
    },
  );
}

Widget noData() => Align(
      alignment: Alignment.center,
      child: WidgetText(
        title: 'Không có dữ liệu',
        style: AppStyle.DEFAULT_18_BOLD,
      ),
    );

void handleRegisterBase(
    BuildContext context, PitelServiceImpl pitelService, String deviceToken) {
  final String domainUrl = shareLocal.getString(PreferencesKey.URL_BASE);
  final String domain = domainUrl.substring(
      domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
  final int user =
      int.parse(LoginBloc.of(context).loginData?.info_user?.extension ?? '0');
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  final String pass = stringToBase64.decode(
      LoginBloc.of(context).loginData?.info_user?.password_extension ?? '');

  final String outboundServer = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.outbound ??
      '';
  final String domainSever = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.domain ??
      '';

  final String outboundProxy = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.outbound_proxy ??
      '';

  final String port =
      LoginBloc.of(context).loginData?.info_user?.info_setup_callcenter?.port ??
          '';
  final sipInfo = SipInfoData.fromJson({
    "authPass": pass,
    "registerServer": domain,
    "outboundServer": outboundProxy,
    "userID": user,
    "authID": user,
    "accountName": "${user}",
    "displayName": "${user}@${domain}",
    "dialPlan": null,
    "randomPort": null,
    "voicemail": null,
    "wssUrl": 'wss://' +
        outboundServer +
        ':' +
        port,
    "userName": "${user}@${domain}",
    "apiDomain": domainSever, //apiDomain,
  });
  final pnPushParams = PnPushParams(
    pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
    pnParam: Platform.isAndroid ? PACKAGE_ID : '${TEAM_ID}.${BUNDLE_ID}.voip',
    pnPrid: '${deviceToken}',
  );
  pitelService.setExtensionInfo(sipInfo, pnPushParams);
}

Widget itemIcon(String title, String icon, Function() click,
    {Widget? iconWidget, bool isSvg = true}) {
  return GestureDetector(
    onTap: () => click(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: AppValue.widths * 0.2,
        ),
        Container(
          height: 24,
          width: 24,
          child: iconWidget ??
              (isSvg
                  ? SvgPicture.asset(
                      icon,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      icon,
                      fit: BoxFit.contain,
                    )),
        ),
        SizedBox(
          width: AppValue.widths * 0.1,
        ),
        WidgetText(title: title, style: styleTitleBottomSheet())
      ],
    ),
  );
}

TextStyle styleTitleBottomSheet() => TextStyle(
    color: HexColor("#0069CD"),
    fontFamily: "Quicksand",
    fontWeight: FontWeight.w700,
    fontSize: 20);

handleOnPressItemMenu(_drawerKey, value) async {
  switch (value['id']) {
    case '1':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateMain();
      break;
    case 'opportunity':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateChance(value['title']);
      break;
    case 'job':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateWork(value['title']);
      break;
    case 'contract':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateContract(value['title']);
      break;
    case 'support':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateSupport(value['title']);
      break;
    case 'customer':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateCustomer(value['title']);
      break;
    case 'contact':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateClue(value['title']);
      break;
    case 'report':
      _drawerKey.currentState!.openEndDrawer();
      String? money = await shareLocal.getString(PreferencesKey.MONEY);
      AppNavigator.navigateReport(money ?? "đ");
      break;
    case 'product':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateProduct(value['title']);
      break;
    case 'sanphamkh':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateProductCustomer(value['title']);
      break;
    case '2':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateInformationAccount();
      break;
    case '3':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateAboutUs();
      break;
    case '4':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigatePolicy();
      break;
    case '5':
      _drawerKey.currentState!.openEndDrawer();
      AppNavigator.navigateChangePassword();
      break;
    default:
      break;
  }
}

Widget itemTextIcon({
  Color? colorText,
  Color? colorIcon,
  TextStyle? styleText,
  required String text,
  required icon,
  bool isSVG = true,
  Function? onTap,
  double? paddingTop,
}) {
  return text == ''
      ? SizedBox()
      : onTap != null
          ? GestureDetector(
              onTap: () => onTap(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: paddingTop ?? 15,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      child: icon.runtimeType == Icon
                          ? icon
                          : isSVG
                              ? SvgPicture.asset(
                                  icon,
                                  color: colorIcon != null ? colorIcon : null,
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  icon,
                                  color: colorIcon != null ? colorIcon : null,
                                  fit: BoxFit.contain,
                                ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: WidgetText(
                        title: text,
                        style: styleText ??
                            AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                              color:
                                  colorText != null ? colorText : COLORS.BLACK,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                top: paddingTop ?? 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: icon.runtimeType == Icon
                        ? icon
                        : isSVG
                            ? SvgPicture.asset(
                                icon,
                                color: colorIcon != null ? colorIcon : null,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                icon,
                                color: colorIcon != null ? colorIcon : null,
                                fit: BoxFit.contain,
                              ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: WidgetText(
                      title: text,
                      style: styleText ??
                          AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                            color: colorText != null ? colorText : COLORS.BLACK,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ],
              ),
            );
}

String getCheckHttp(String text) {
  if (text.toLowerCase().contains('https://')) {
    return text;
  }
  return 'https://' + text;
}

class Debounce {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({this.milliseconds = 450});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
