import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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
const LOADING = 'loading';

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
  final String apiDomain = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.domain ??
      '';
  final sipInfo = SipInfoData.fromJson({
    "authPass": pass,
    "registerServer": domain,
    "outboundServer": outboundServer,
    "userID": user,
    "authID": user,
    "accountName": "${user}",
    "displayName": "${user}@${domain}",
    "dialPlan": null,
    "randomPort": null,
    "voicemail": null,
    "wssUrl": BASE_URL.URL_WSS,
    "userName": "${user}@${domain}",
    "apiDomain": getCheckHttp(apiDomain),
  });
  final pnPushParams = PnPushParams(
    pnProvider: Platform.isAndroid ? 'fcm' : 'apns',
    pnParam: Platform.isAndroid
        ? PACKAGE_ID // Example com.company.app
        : '${TEAM_ID}.${BUNDLE_ID}.voip', // Example com.company.app
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
