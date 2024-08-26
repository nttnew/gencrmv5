import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../src/models/model_generator/add_customer.dart';
import '../../../src/src_index.dart';

class WidgetLabelPo extends StatelessWidget {
  const WidgetLabelPo({
    Key? key,
    required this.data,
  }) : super(key: key);
  final CustomerIndividualItemData data;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -(calculateTextHeight(data.field_label ?? '', 10, context) / 2),
      left: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3),
        color: COLORS.WHITE,
        child: WidgetLabel(data, size: 10),
      ),
    );
  }
}

WidgetLabel(
  CustomerIndividualItemData _data, {
  double? size,
}) =>
    RichText(
      textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor,
      text: TextSpan(
        text: _data.field_label ?? '',
        style: AppStyle.DEFAULT_14W600.copyWith(
          fontSize: size,
        ),
        children: <TextSpan>[
          _data.field_require == 1
              ? TextSpan(
                  text: '*',
                  style: AppStyle.DEFAULT_14W600_RED.copyWith(
                    fontSize: size,
                  ),
                )
              : TextSpan(),
        ],
      ),
    );

EdgeInsetsGeometry marginBottomFrom = EdgeInsets.only(bottom: 20);

EdgeInsetsGeometry paddingBaseForm = EdgeInsets.symmetric(
  vertical: 12,
  horizontal: 16,
);

BoxDecoration boxDecorationBaseForm = BoxDecoration(
  borderRadius: BorderRadius.circular(4),
  border: Border.all(
    color: COLORS.COLOR_GRAY,
  ),
);

double calculateTextHeight(String text, double fontSize, BuildContext context) {
  final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
  final double adjustedFontSize = fontSize * textScaleFactor;

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: adjustedFontSize),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  return textPainter.size.height;
}

TextStyle hintTextStyle =
    AppStyle.DEFAULT_14W500.copyWith(color: COLORS.COLOR_GRAY);
