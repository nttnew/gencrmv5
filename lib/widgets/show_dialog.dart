import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../l10n/key_text.dart';

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
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(15),
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
                      Text(
                        content ?? getT(KeyT.are_you_sure_you_want_to_sign_out),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: onTap1 ?? () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: colorButton1 ??
                                          (onTap2 == null
                                              ? COLORS.PRIMARY_COLOR
                                              : COLORS.GREY.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      textButton1 ??
                                          (onTap2 != null
                                              ? getT(KeyT.cancel)
                                              : getT(KeyT.ok)),
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color:
                                              txtColorButton1 ?? COLORS.BLACK),
                                    ),
                                  ),
                                )),
                          ),
                          if (onTap2 != null) ...[
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: onTap2,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: colorButton2 ??
                                            COLORS.SECONDS_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        textButton2 ?? getT(KeyT.agree),
                                        style: AppStyle.DEFAULT_16_BOLD
                                            .copyWith(
                                                color: txtColorButton1 ??
                                                    COLORS.BLACK),
                                      ),
                                    ),
                                  )),
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

  static showDialogTwoButtonAddress(
      {String? title,
      String? content,
      String? textButton1,
      Color? colorButton1,
      VoidCallback? onTap1,
      String? textButton2,
      Color? colorButton2,
      Function? onTap2}) {
    String text_r = "";
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Scaffold(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(title ?? getT(KeyT.enter_address_application_below),
                          style: AppStyle.DEFAULT_16.copyWith(fontSize: 14)),
                      SizedBox(
                        height: 15,
                      ),
                      WidgetInput(
                        colorTxtLabel:
                            Theme.of(context).scaffoldBackgroundColor,
                        inputType: TextInputType.text,
                        onChanged: (text) {
                          text_r = text;
                        },
                        // focusNode: _emailFocusNode,
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: HexColor("#838A91")),
                        ),
                        initialValue: initAddressApplication(),
                        textLabel: Text("",
                            style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: onTap1 ?? () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: textButton1 != null
                                          ? COLORS.PRIMARY_COLOR
                                          : COLORS.GREY.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      textButton1 ?? getT(KeyT.cancel),
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color: colorButton1 ?? COLORS.BLACK),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: GestureDetector(
                                onTap: onTap2 != null
                                    ? () {
                                        onTap2(text_r);
                                      }
                                    : () => Get.back(),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: COLORS.SECONDS_COLOR,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      textButton2 ?? getT(KeyT.agree),
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color: colorButton1 ?? COLORS.BLACK),
                                    ),
                                  ),
                                )),
                          ),
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
    );
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
