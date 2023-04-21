import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
// ignore: import_of_legacy_library_into_null_safe

class WidgetText extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextOverflow? overflow;

  WidgetText({
    this.title,
    this.style,
    this.textAlign,
    this.maxLine,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      textAlign: textAlign ?? textAlign,
      style: style ??
          AppStyle.DEFAULT_16.copyWith(
            color: COLORS.WHITE,
            fontWeight: FontWeight.bold,
          ),
      overflow: overflow,
      maxLines: maxLine,
    );
  }
}
