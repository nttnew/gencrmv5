import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pitel_voip/services/sip_info_data.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../bloc/login/login_bloc.dart';
import '../../l10n/key_text.dart';
import '../storages/share_local.dart';
import '../widgets/loading_api.dart';
import '../widgets/widget_text.dart';
import 'location.dart';
import 'models/model_generator/add_customer.dart';
import 'models/model_generator/detail_customer.dart';

const int IS_AFTER = 1;
const int IS_BEFORE = 0;
const String BUNDLE_ID = 'com.gencrm';
const String PACKAGE_ID = 'vn.gen_crm';
const String TEAM_ID = 'AEY48KNZRS';

const String ADD_CUSTOMER_OR = 'ADD_CUSTOMER_OR';
const String ADD_CLUE = 'ADD_CLUE';
const String ADD_CHANCE = 'ADD_CHANCE';
const String ADD_CONTRACT = 'ADD_CONTRACT';
const String ADD_JOB = 'ADD_JOB';
const String ADD_SUPPORT = 'ADD_SUPPORT';
const String ADD_QUICK_CONTRACT = 'ADD_QUICK_CONTRACT';
const String ADD_CUSTOMER = 'ADD_CUSTOMER';
const String ADD_CLUE_CUSTOMER = 'ADD_CLUE_CUSTOMER';
const String ADD_CHANCE_CUSTOMER = 'ADD_CHANCE_CUSTOMER';
const String ADD_JOB_CUSTOMER = 'ADD_JOB_CUSTOMER';
const String ADD_SUPPORT_CUSTOMER = 'ADD_SUPPORT_CUSTOMER';
const String ADD_CONTRACT_CUS = 'ADD_CONTRACT_CUS';
const String ADD_CLUE_JOB = 'ADD_CLUE_JOB';
const String ADD_CHANCE_JOB = 'ADD_CHANCE_JOB';
const String ADD_SUPPORT_CONTRACT = 'ADD_SUPPORT_CONTRACT';
const String ADD_JOB_CONTRACT = 'ADD_JOB_CONTRACT';
const String EDIT_CUSTOMER = 'EDIT_CUSTOMER';
const String EDIT_CLUE = 'EDIT_CLUE';
const String EDIT_CHANCE = 'EDIT_CHANCE';
const String EDIT_CONTRACT = 'EDIT_CONTRACT';
const String EDIT_JOB = 'EDIT_JOB';
const String EDIT_SUPPORT = 'EDIT_SUPPORT';
const String CH_PRODUCT_CUSTOMER_TYPE = 'CH_PRODUCT_CUSTOMER_TYPE';
const String HT_PRODUCT_CUSTOMER_TYPE = 'HT_PRODUCT_CUSTOMER_TYPE';
const String HD_PRODUCT_CUSTOMER_TYPE = 'HD_PRODUCT_CUSTOMER_TYPE';
const String CV_PRODUCT_CUSTOMER_TYPE = 'CV_PRODUCT_CUSTOMER_TYPE';
const String PRODUCT_CUSTOMER_TYPE = 'PRODUCT_CUSTOMER_TYPE';
const String PRODUCT_CUSTOMER_TYPE_EDIT = 'PRODUCT_CUSTOMER_TYPE_EDIT';
const String PRODUCT_TYPE = 'PRODUCT_TYPE';
const String PRODUCT_TYPE_EDIT = 'PRODUCT_TYPE_EDIT';
const String ADD_PAYMENT = 'ADD_PAYMENT';
const String EDIT_PAYMENT = 'EDIT_PAYMENT';
const String SUCCESS = 'SUCCESS';

const String LOGIN = 'login';
const String LOGOUT = 'logout';
const String LOGOUT_NOTIFICATION = 'LOGOUT_NOTIFICATION';

const LOADING = 'loading';
String CA_NHAN = 'ca_nhan';
String TO_CHUC = 'to_chuc';
String ADD_NEW_CAR = 'ADD_NEW_CAR';
String SPECIAL_KH = 'khachhang';
String SPECIAL_SPKH = 'spkh';

// id column db
String SO_HOP_DONG_DB = 'so_hop_dong';
String TRANG_THAI_DB = 'trang_thai';
String NGAY_KY_DB = 'ngay_ky';
String KHACH_HANG_DB = 'khach_hang';

class TypeCheckIn {
  static const CHECK_IN = 'checkin';
  static const CHECK_OUT = 'checkout';
}

String hinhThucTT = 'hinh_thuc_thanh_toan';
String hdSoTien = 'hd_sotien';
String ghiChu = 'ghi_chu';

void loginSessionExpired(Function() onTap) {
  Loading().popLoading();
  ShowDialogCustom.showDialogBase(
      title: getT(KeyT.notification),
      content: getT(KeyT.login_session_expired_please_login_again),
      onTap1: () {
        onTap();
        AppNavigator.navigateLogout();
      },
      onWhen: () {
        onTap();
        AppNavigator.navigateLogout();
      });
}

Widget noData() => Align(
      alignment: Alignment.center,
      child: WidgetText(
        title: getT(KeyT.no_data),
        style: AppStyle.DEFAULT_18_BOLD,
      ),
    );

getSipInfo() {
  final context = Get.context!;
  final String user =
      LoginBloc.of(context).loginData?.info_user?.extension ?? '0';
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  final String pass = stringToBase64.decode(
      LoginBloc.of(context).loginData?.info_user?.password_extension ?? '');

  final String domain = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.domain_mobile ??
      '';

  final String portApp = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.port_app ??
      '';

  final String outboundProxy = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.outbound_server ??
      '';

  final String wssMobile = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.wss_mobile ??
      '';

  final String apiDomain = LoginBloc.of(context)
          .loginData
          ?.info_user
          ?.info_setup_callcenter
          ?.api_url ??
      '';
  final sipInfo = SipInfoData.fromJson({
    "authPass": pass, // pass,
    "registerServer": domain + (portApp != '' ? ':' + portApp : ''),
    "outboundServer": outboundProxy,
    "userID": user,
    "authID": user,
    "accountName": "${user}",
    "displayName": "${user}@${domain}",
    "dialPlan": null,
    "port": 50061,
    "randomPort": null,
    "voicemail": null,
    "wssUrl": wssMobile,
    "userName": "${user}@${domain}",
    "apiDomain": apiDomain, //apiDomain,
  });
  return sipInfo;
}

Widget itemIcon(
  String title,
  String icon,
  Function() click, {
  Widget? iconWidget,
  bool isSvg = true,
}) {
  return GestureDetector(
    onTap: () => click(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
        ),
        Container(
          height: 24,
          width: 24,
          child: iconWidget ??
              (isSvg
                  ? SvgPicture.asset(
                      icon,
                      fit: BoxFit.contain,
                      color: COLORS.TEXT_BLUE_BOLD,
                    )
                  : Image.asset(
                      icon,
                      fit: BoxFit.contain,
                      color: COLORS.TEXT_BLUE_BOLD,
                    )),
        ),
        SizedBox(
          width: 25,
        ),
        WidgetText(
          title: title,
          style: AppStyle.DEFAULT_20_BOLD.copyWith(
            color: COLORS.TEXT_BLUE_BOLD,
          ),
        )
      ],
    ),
  );
}

Widget widgetTextClick(
  String title,
  String content,
  Function onClick, {
  String? contentNull,
  String contentValueNull = '',
  Color? color,
}) {
  return Row(
    children: [
      Expanded(
          child: Text(
        title,
        style: AppStyle.DEFAULT_14,
      )),
      Expanded(
        child: GestureDetector(
          onTap: () {
            onClick();
          },
          child: Text(
            content == contentValueNull && contentNull != null
                ? contentNull
                : content,
            style: AppStyle.DEFAULT_14.copyWith(
              color: color ?? COLORS.ORANGE,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ),
    ],
  );
}

Widget itemTextIconStart({
  required String title,
  required String icon,
  required String? color,
  Color? colorDF,
  bool isSVG = true,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: itemTextIcon(
          paddingTop: 0,
          text: title,
          icon: icon,
          isSVG: isSVG,
          styleText: AppStyle.DEFAULT_16_BOLD.copyWith(
            color: COLORS.TEXT_COLOR,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      AppValue.hSpace4,
      Container(
        decoration: BoxDecoration(
          color: color != null && color != ''
              ? HexColor(color)
              : colorDF ?? COLORS.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(
            99,
          ),
        ),
        width: AppValue.widths * 0.1,
        height: AppValue.heights * 0.02,
      )
    ],
  );
}

Widget itemTextEnd({
  required String title,
  required String content,
  required String icon,
  Color? colorTitle,
  Function? onTapTitle,
  bool isSvg = true,
  bool isAvatar = false,
  Color? colorIcon,
  double? marginD,
}) {
  return Container(
    margin: !isAvatar
        ? null
        : EdgeInsets.only(
            top: marginD ?? 8,
          ),
    decoration: !isAvatar
        ? null
        : BoxDecoration(
            border: Border(
              top: BorderSide(
                color: COLORS.GRAY_IMAGE,
              ),
            ),
          ),
    child: Container(
      margin: isAvatar
          ? EdgeInsets.only(
              top: marginD ?? 8,
            )
          : null,
      child: Row(
        crossAxisAlignment:
            isAvatar ? CrossAxisAlignment.center : CrossAxisAlignment.end,
        children: [
          if (isAvatar)
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    margin: EdgeInsets.only(
                      right: 8,
                    ),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: COLORS.GRAY_IMAGE,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      icon,
                      errorBuilder: (_, __, ___) => Image.asset(
                        ICONS.IC_PROFILE_ERROR_PNG,
                      ),
                    ),
                  ),
                  WidgetText(
                    title: title,
                    style: AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                      color: colorTitle ?? COLORS.BLACK,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: itemTextIcon(
                isSVG: isSvg,
                text: title,
                icon: icon,
                colorIcon: colorIcon,
                colorText: colorTitle,
                onTap: onTapTitle,
                paddingTop: marginD,
              ),
            ),
          SizedBox(
            width: 8,
          ),
          SvgPicture.asset(ICONS.IC_QUESTION_SVG),
          SizedBox(
            width: 4,
          ),
          WidgetText(
            title: content,
            style: AppStyle.DEFAULT_14.copyWith(
              color: COLORS.TEXT_BLUE_BOLD,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget itemTextIcon({
  Color? colorText,
  Color? colorIcon,
  TextStyle? styleText,
  required String text,
  required icon,
  String? textPlus,
  bool isSVG = true,
  Function? onTap,
  double? paddingTop,
}) {
  return text.trim() == ''
      ? SizedBox()
      : onTap != null
          ? Padding(
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
                    child: GestureDetector(
                      onTap: () => onTap(),
                      child: WidgetText(
                        title: (textPlus != null ? '$textPlus: ' : '') + text,
                        style: styleText ??
                            AppStyle.DEFAULT_LABEL_PRODUCT.copyWith(
                              color:
                                  colorText != null ? colorText : COLORS.BLACK,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                top: paddingTop ?? 15,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.up,
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
                      title: (textPlus != null ? '$textPlus: ' : '') + text,
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

  Debounce({this.milliseconds = 1500});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

String getFlagCountry(String flag) {
  String domain = shareLocal.getString(PreferencesKey.URL_BASE);
  //link gan flag : domain + modules/xlanguage/images + {flag}
  return domain + 'modules/xlanguage/images/' + flag;
}

bool checkLocation(CustomerIndividualItemData data) =>
    (data.field_name == 'dia_chi_chung_text_dm' ||
        data.field_name == 'dia_chi_chung_text') &&
    getTinhThanh().length > 0;

/// CAR_CRM 1 = true
const String CAR_CRM = '1';
bool isCarCrm() {
  return CAR_CRM ==
      shareLocal.getString(
        PreferencesKey.CAR_CRM,
      );
}

Color getColorWithIsCar() {
  return isCarCrm() ? COLORS.WHITE : COLORS.BLACK;
}

Color getBackgroundWithIsCar() {
  return isCarCrm() ? COLORS.PRIMARY_COLOR1 : COLORS.SECONDS_COLOR;
}

String checkTitle(
  List<InfoDataModel> dataL,
  String key,
) {
  for (final value in dataL) {
    for (final InfoItem element in value.data ?? []) {
      if (element.id == key) {
        return element.value_field;
      }
    }
  }
  return '';
}

Widget iconBackBlur() => Positioned(
      top: 16 + MediaQuery.of(Get.context!).padding.top,
      left: 16,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
          color: Colors.black.withOpacity(
            0.4,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: COLORS.WHITE,
              size: 24,
            ),
          ),
        ),
      ),
    );

showBottomGenCRM({
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  double radius = 10,
  bool isConstraints = false,
}) async =>
    await showModalBottomSheet(
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      context: Get.context!,
      isScrollControlled: isScrollControlled,
      constraints: isConstraints
          ? null
          : BoxConstraints(maxHeight: Get.height * 0.8, minWidth: Get.width),
      clipBehavior: Clip.hardEdge,
      backgroundColor: COLORS.WHITE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          topLeft: Radius.circular(radius),
        ),
      ),
      builder: (context) => child,
    );

itemSearchFilterTree() => Image.asset(
      ICONS.IC_USER_NEW_PNG,
      width: 20,
      height: 20,
      fit: BoxFit.contain,
    );

itemSearch() => Image.asset(
      ICONS.IC_SEARCH_PNG,
      width: 20,
      height: 20,
      fit: BoxFit.contain,
    );

iconButtonGen({
  required Function onTap,
  Widget? icon,
  Color? backgroundColor,
}) =>
    Container(
      margin: EdgeInsets.only(
        left: 8,
      ),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ElevatedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.all(4),
            minimumSize: Size(0, 0),
            fixedSize: Size(24, 24),
            maximumSize: Size(24, 24),
            backgroundColor: backgroundColor ?? COLORS.BLUE,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  4,
                ),
              ),
            )),
        child: icon ??
            Icon(
              Icons.add,
              color: COLORS.WHITE,
              size: 16,
            ),
      ),
    );
