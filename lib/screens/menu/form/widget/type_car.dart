import 'package:flutter/material.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../../../widgets/widget_text.dart';
import 'select_car.dart';

Widget TypeCarBase(
  CustomerIndividualItemData data,
  int indexParent,
  int indexChild,
  BuildContext context,
  dynamic _bloc,
  Function(String v) function,
) {
  if (data.field_set_value != '' && data.field_set_value != null) {
    _bloc.loaiXe.add(data.field_set_value);
  }
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            text: data.field_label ?? '',
            style: AppStyle.DEFAULT_14W600,
            children: <TextSpan>[
              data.field_require == 1
                  ? TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: COLORS.RED,
                      ),
                    )
                  : TextSpan(),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      30,
                    ),
                  ),
                ),
                builder: (BuildContext context) {
                  return SelectCar();
                });
          },
          child: StreamBuilder<String>(
              stream: _bloc.loaiXe,
              builder: (context, snapshot) {
                if (_bloc.loaiXe.value.trim() != '') {
                  function(_bloc.loaiXe.value);
                }
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: COLORS.WHITE,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    border: Border.all(
                      color: COLORS.ffBEB4B4,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Container(
                      child: WidgetText(
                        title: (_bloc.loaiXe.value != ''
                            ? _bloc.loaiXe.value
                            : '---${getT(KeyT.select)}---'),
                        style: AppStyle.DEFAULT_14,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
  );
}
