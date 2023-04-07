import 'package:flutter/material.dart';
import 'package:gen_crm/src/color.dart';
import 'package:gen_crm/src/get_snack_bar_utils.dart';
import 'package:gen_crm/src/messages.dart';
import 'package:gen_crm/src/styles.dart';
import 'package:gen_crm/src/values.dart';
import 'package:gen_crm/widgets/widgets.dart';

class WidgetResend extends StatelessWidget {
  final Function onTap;
  final int time;
  final bool isValid;

  const WidgetResend(
      {Key? key,
      required this.onTap,
      required this.time,
      required this.isValid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tmpTime = '';
    if (time < 10) {
      tmpTime = '00:0$time';
    } else {
      tmpTime = '00:$time';
    }
    return Container(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Text(
            MESSAGES.NO_OTP,
            style: AppStyle.DEFAULT_16,
          ),
          AppValue.hSpaceTiny,
          WidgetLink(
            text: !isValid ? MESSAGES.RESEND + '($tmpTime)' : MESSAGES.RESEND,
            style: !isValid
                ? AppStyle.DEFAULT_16_BOLD.copyWith(
                    color: COLORS.GREY_400,
                    decoration: TextDecoration.underline)
                : AppStyle.DEFAULT_16_BOLD.copyWith(
                    color: COLORS.BLACK, decoration: TextDecoration.underline),
            onTap: () {
              !isValid
                  ? GetSnackBarUtils.createWarning(message: MESSAGES.TRY_AGAIN)
                  : onTap();
            },
          )
        ],
      ),
    );
  }
}
