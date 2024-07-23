import 'package:flutter/material.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/btn_save.dart';

class ErrorItem extends StatelessWidget {
  const ErrorItem({
    Key? key,
    required this.onPressed,
    required this.error,
  }) : super(key: key);
  final String error;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            error,
            style: AppStyle.DEFAULT_16_T,
          ),
          AppValue.vSpace10,
          ButtonSave(
            onPressed: () {
              onPressed();
            },
            background: getBackgroundWithIsCar(),
            title: getT(KeyT.try_again),
          ),
        ],
      ),
    );
  }
}
