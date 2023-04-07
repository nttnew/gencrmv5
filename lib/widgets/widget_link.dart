import 'package:flutter/material.dart';
import 'package:gen_crm/src/styles.dart';

class WidgetLink extends StatelessWidget {
  final String text;
  final Function onTap;
  final TextStyle? style;

  const WidgetLink(
      {Key? key, required this.text, required this.onTap, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Text(text,
          style: style ??
              AppStyle.DEFAULT_16_BOLD.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              )),
    );
  }
}
