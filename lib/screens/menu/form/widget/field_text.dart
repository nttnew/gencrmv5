import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/app_const.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';

class FieldText extends StatefulWidget {
  const FieldText({
    Key? key,
    required this.data,
    required this.onChange,
    this.init,
    this.soTien,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(String) onChange;
  final String? init;
  final double? soTien;

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
          ? AppValue.format_money(
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
        data.field_read_only.toString() == '1';
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor,
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isReadOnly ? COLORS.LIGHT_GREY : COLORS.WHITE,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: COLORS.ffBEB4B4,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                top: 5,
                bottom: 5,
              ),
              child: Container(
                child: TextFormField(
                  enabled: !isReadOnly,
                  inputFormatters: data.field_type == 'MONEY' ||
                          data.field_type == 'TEXT_NUMERIC'
                      ? AppStyle.inputPrice
                      : null,
                  controller: _textEditingController,
                  minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                  maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                  style: AppStyle.DEFAULT_14_BOLD,
                  keyboardType: data.field_type == 'MONEY' ||
                          data.field_special == 'numberic' ||
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
                    counterText: '',
                    counterStyle: TextStyle(fontSize: 0),
                    hintStyle: AppStyle.DEFAULT_14W500,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ),
          if (data.field_name == hdSoTien && widget.soTien != null) ...[
            SizedBox(
              height: 8,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: '${getT(KeyT.unpaid)}:',
                style: AppStyle.DEFAULT_14W600,
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ' ${AppValue.format_money(widget.soTien?.toStringAsFixed(
                              0,
                            ) ?? '')}',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
