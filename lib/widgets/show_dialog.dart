import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../l10n/key_text.dart';

const String SPECIAL = 'special*';

class ShowDialogCustom {
  static showLoading() {
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return TrailLoading();
      },
    );
  }

  static endLoading() {
    Get.back();
  }

  static showDialogBase({
    String? title,
    String? content,
    String? textButton1,
    Color? txtColorButton1,
    VoidCallback? onTap1,
    String? textButton2,
    Color? colorButton2,
    Color? colorButton1,
    Widget? child,
    VoidCallback? onTap2,
    Function? onWhen,
  }) {
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BackdropFilter(
              filter: onWhen == null
                  ? ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0)
                  : ImageFilter.blur(),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: COLORS.WHITE,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      if (title != null) ...[
                        Text(
                          title,
                          style: AppStyle.DEFAULT_18_BOLD,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                      if (content != null &&
                          content.toString().contains(SPECIAL))
                        RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: content.replaceAll(SPECIAL, ''),
                                style: title != null
                                    ? AppStyle.DEFAULT_14
                                    : AppStyle.DEFAULT_18_BOLD,
                              ),
                              TextSpan(
                                text: '*',
                                style: (title != null
                                        ? AppStyle.DEFAULT_14
                                        : AppStyle.DEFAULT_18_BOLD)
                                    .copyWith(
                                  color: COLORS.RED,
                                ),
                              ),
                              TextSpan(
                                text: ')',
                                style: (title != null
                                    ? AppStyle.DEFAULT_14
                                    : AppStyle.DEFAULT_18_BOLD),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          content ??
                              getT(KeyT.are_you_sure_you_want_to_sign_out),
                          style: title != null
                              ? AppStyle.DEFAULT_14
                              : AppStyle.DEFAULT_18_BOLD,
                          textAlign: TextAlign.center,
                        ),
                      if (child != null) child,
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ButtonCustom(
                              paddingAll: 10,
                              marginHorizontal: 0,
                              marginVertical: 0,
                              backgroundColor: colorButton1 ??
                                  (onTap2 == null
                                      ? getBackgroundWithIsCar()
                                      : COLORS.GREY.withOpacity(0.5)),
                              onTap: onTap1 ?? () => Get.back(),
                              title: textButton1 ??
                                  (onTap2 != null
                                      ? getT(KeyT.cancel)
                                      : getT(KeyT.ok)),
                            ),
                          ),
                          if (onTap2 != null) ...[
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: ButtonCustom(
                                textColor: getColorWithIsCar(),
                                paddingAll: 10,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                onTap: onTap2,
                                title: textButton2 ?? getT(KeyT.agree),
                                backgroundColor:
                                    colorButton2 ?? getBackgroundWithIsCar(),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (onWhen != null) onWhen();
    });
  }

  static showDialogScreenBase({
    required Widget child,
    bool isPop = false,
  }) async {
    final data = await showDialog<dynamic>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            isPop ? Get.back() : null;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: COLORS.WHITE,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(25),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    return data;
  }
}

String initAddressApplication() {
  String txt = shareLocal.getString(PreferencesKey.URL_BASE) ?? '';
  if (txt.contains('https://')) {
    return txt.substring(txt.indexOf('//') + 2, txt.lastIndexOf('/'));
  } else {
    return txt;
  }
}
