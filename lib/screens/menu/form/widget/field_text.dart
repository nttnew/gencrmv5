import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../src/models/model_generator/add_customer.dart';
import '../../../../src/src_index.dart';

class FieldText extends StatefulWidget {
  const FieldText({
    Key? key,
    required this.data,
    required this.onChange,
  }) : super(key: key);
  final CustomerIndividualItemData data;
  final Function(String) onChange;

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
      widget.onChange(_textEditingController.text);
    });
    if (widget.data.field_set_value != null &&
        widget.data.field_set_value != '')
      _textEditingController.text = widget.data.field_set_value ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly =
        data.field_special == 'none-edit' || data.field_read_only == '1';
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
                  controller: _textEditingController,
                  minLines: data.field_type == 'TEXTAREA' ? 2 : 1,
                  maxLines: data.field_type == 'TEXTAREA' ? 6 : 1,
                  style: AppStyle.DEFAULT_14_BOLD,
                  keyboardType: data.field_special == 'default'
                      ? TextInputType.text
                      : data.field_special == 'numberic'
                          ? TextInputType.number
                          : data.field_special == 'email-address'
                              ? TextInputType.emailAddress
                              : isReadOnly
                                  ? TextInputType.none
                                  : TextInputType.text,
                  decoration: InputDecoration(
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
        ],
      ),
    );
  }
}
