import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/widget/widget_label.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';

Widget fieldTextCar(
  CustomerIndividualItemData data,
  String value,
  Function() onChange,
) {
  onChange();
  return Container(
    margin: marginBottomFrom,
    child: Row(
      children: [
        WidgetLabel(data),
        Expanded(
          child: Text(
            '${value != '' ? value : (data.field_value ?? '')}',
            style: AppStyle.DEFAULT_14_BOLD,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
