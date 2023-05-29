import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

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

  static showDialogBase(
      {String? title,
      String? content,
      String? textButton1,
      Color? colorButton1,
      VoidCallback? onTap1,
      String? textButton2,
      Color? colorButton2,
      VoidCallback? onTap2}) {
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
                      color: Colors.white,
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
                        content ?? 'Bạn chắc chắn muốn đăng xuất ?',
                        style: title != null
                            ? AppStyle.DEFAULT_14
                            : AppStyle.DEFAULT_18_BOLD,
                        textAlign: TextAlign.center,
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
                                      color: onTap2 == null
                                          ? COLORS.PRIMARY_COLOR
                                          : COLORS.GREY.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      textButton1 ??
                                          (onTap2 != null ? 'Huỷ' : 'Oke'),
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color: colorButton1 ?? Colors.black),
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
                                        color: COLORS.SECONDS_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        textButton2 ?? 'Đồng ý',
                                        style: AppStyle.DEFAULT_16_BOLD
                                            .copyWith(
                                                color: colorButton1 ??
                                                    Colors.black),
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
    );
  }

  static showDialogScreenBase({required Widget child}) async {
    final data = await showDialog<dynamic>(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(25),
                  child: child,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(title ?? 'Nhập địa chỉ ứng dụng bên dưới',
                          style: AppStyle.DEFAULT_16.copyWith(fontSize: 14)),
                      SizedBox(
                        height: 25,
                      ),
                      WidgetInput(
                        colorFix: Theme.of(context).scaffoldBackgroundColor,
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
                        Fix: Text("",
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
                                      textButton1 ?? 'Huỷ',
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color: colorButton1 ?? Colors.black),
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
                                      textButton2 ?? 'Đồng ý',
                                      style: AppStyle.DEFAULT_16_BOLD.copyWith(
                                          color: colorButton1 ?? Colors.black),
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
  String txt = dotenv.env[PreferencesKey.BASE_URL] ?? '';
  if (txt.contains('https://')) {
    return txt.substring(txt.indexOf('//') + 2, txt.lastIndexOf('/'));
  } else {
    return txt;
  }
}
