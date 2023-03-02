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

  static showDialogOneButton({String? title, String? content, String? textButton, Color? colorButton, VoidCallback? onTap}) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return WidgetDialog(
          title: title ?? MESSAGES.NOTIFICATION,
          content: content ?? MESSAGES.SUCCESS,
          onTap1: onTap,
          textButton1: textButton,
          backgroundButton1: colorButton,
        );
      },
    );
  }

  static showDialogTwoButton({String? title, String? content, String? textButton1, Color? colorButton1, VoidCallback? onTap1, String? textButton2, Color? colorButton2, VoidCallback? onTap2}) {
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(title ?? 'Thông báo', style: AppStyle.DEFAULT_16_BOLD.copyWith(fontSize: 18),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content ?? 'Bạn chắc chắn muốn đăng xuất ?', style: AppStyle.DEFAULT_16_BOLD,textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: AppValue.widths,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: onTap1 ?? ()=> Get.back(),
                      child: Container(
                        width: AppValue.widths/2.7,
                        decoration: BoxDecoration(
                            color: COLORS.GREY.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text(textButton1 ?? 'Huỷ',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: colorButton1 ?? Colors.black) ,),),
                      )
                  ),
                  GestureDetector(
                      onTap: onTap2 ?? ()=> AppNavigator.navigateLogin(),
                      child: Container(
                        width: AppValue.widths/2.7,
                        decoration: BoxDecoration(
                            color: COLORS.SECONDS_COLOR,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text(textButton1 ?? 'Đồng ý',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: colorButton1 ?? Colors.black) ,),),
                      )
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  static showDialogTwoButtonAddress({
    String? title, String? content,
    String? textButton1, Color? colorButton1,
    VoidCallback? onTap1, String? textButton2,
    Color? colorButton2, Function? onTap2
  }) {
    String text_r="";
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text(title ?? 'Nhập địa chỉ ứng dụng bên dưới', style: AppStyle.DEFAULT_16.copyWith(fontSize: 14),textAlign:TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                WidgetInput(
                  colorFix: Theme.of(context).scaffoldBackgroundColor,
                  // onChanged: (value) => bloc.add(EmailChanged(email: value)),
                  inputType: TextInputType.text,
                  onChanged: (text){
                    text_r=text;
                  },
                  // focusNode: _emailFocusNode,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:Border.all(color: HexColor("#838A91")),
                  ),
                  initialValue: dotenv.env[PreferencesKey.BASE_URL],
                  // errorText: state.email.invalid ? MESSAGES.EMAIL_ERROR : null,
                  Fix: Text("",style:TextStyle(fontFamily: "Quicksand", fontWeight: FontWeight.w600,fontSize: 14)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: AppValue.widths,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: onTap1 ?? ()=> Get.back(),
                      child: Container(
                        width: AppValue.widths/2.7,
                        decoration: BoxDecoration(
                            color: COLORS.GREY.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text(textButton1 ?? 'Huỷ',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: colorButton1 ?? Colors.black) ,),),
                      )
                  ),
                  GestureDetector(
                      onTap: onTap2!=null ?(){
                        onTap2(text_r);
                      }: ()=> Get.back(),
                      child: Container(
                        width: AppValue.widths/2.7,
                        decoration: BoxDecoration(
                            color: COLORS.SECONDS_COLOR,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: Text(textButton1 ?? 'Đồng ý',style: AppStyle.DEFAULT_16_BOLD.copyWith(color: colorButton1 ?? Colors.black) ,),),
                      )
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}
