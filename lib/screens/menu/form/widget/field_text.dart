import 'package:flutter/material.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';
import '../../widget/widget_label.dart';

class FieldText extends StatefulWidget {
  const FieldText({
    Key? key,
    required this.data,
    required this.onChange,
    this.init,
    this.soTien,
    this.isNoneEdit = false,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(String) onChange;
  final String? init;
  final double? soTien;
  final bool isNoneEdit;

  @override
  State<FieldText> createState() => _FieldTextState();
}

class _FieldTextState extends State<FieldText> {
  late final CustomerIndividualItemData data;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    data = widget.data;
    _textEditingController.addListener(() {
      widget.onChange(
          data.field_type == 'MONEY' || data.field_type == 'TEXT_NUMERIC'
              ? _textEditingController.text.replaceAll('.', '')
              : _textEditingController.text);
    });
    if ((widget.data.field_set_value != null &&
            widget.data.field_set_value != '') ||
        widget.init != null)
      _textEditingController.text = data.field_type == 'MONEY' ||
              data.field_type == 'TEXT_NUMERIC'
          ? AppValue.formatMoney(
              widget.init ??
                  '${widget.data.field_set_value ?? ''}'.replaceAll('.', ''),
              isD: false,
            )
          : widget.init ?? '${widget.data.field_set_value ?? ''}';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = data.field_special == 'none-edit' ||
        data.field_read_only.toString() == '1' ||
        widget.isNoneEdit;
    return Container(
      margin: marginBottomFrom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              enabled: !isReadOnly,
              inputFormatters: data.field_type == 'MONEY' ||
                      data.field_type == 'TEXT_NUMERIC'
                  ? AppStyle.inputPrice
                  : null,
              controller: _textEditingController,
              minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
              maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                color: isReadOnly ? COLORS.GREY : null,
              ),
              keyboardType: data.field_type == 'MONEY' ||
                      data.field_special == 'numeric' ||
                      data.field_type == 'TEXT_NUMERIC'
                  ? TextInputType.number
                  : data.field_special == 'default'
                      ? TextInputType.text
                      : data.field_special == 'email-address'
                          ? TextInputType.emailAddress
                          : isReadOnly
                              ? TextInputType.none
                              : TextInputType.text,
              decoration: InputDecoration(
                contentPadding: paddingBaseForm,
                label: WidgetLabel(data),
                counterText: '',
                counterStyle: TextStyle(fontSize: 0),
                hintStyle: hintTextStyle,
                border: OutlineInputBorder(),
                isDense: true,
                hintText: getT(KeyT.enter) +
                    ' ' +
                    (data.field_label ?? '').toLowerCase(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          if (data.field_name == hdSoTien && widget.soTien != null) ...[
            SizedBox(
              height: 4,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: '${getT(KeyT.unpaid)}:',
                style: AppStyle.DEFAULT_14W600.copyWith(
                  fontSize: 12,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ' ${AppValue.formatMoney(widget.soTien?.toStringAsFixed(
                              0,
                            ) ?? '')}',
                    style: AppStyle.DEFAULT_14W600.copyWith(
                      fontSize: 12,
                      color: COLORS.TEXT_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
