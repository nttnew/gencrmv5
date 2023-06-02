import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetSearch extends StatelessWidget {
  final TextEditingController? inputController;
  // final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? hint, errorText, labelText, initialValue;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final double? height;
  final bool? obscureText;
  final TextInputType? inputType;
  final Widget? leadIcon;
  final Widget? endIcon;
  final Widget? endIconFinal;
  final bool? enabled;
  final FocusNode? focusNode;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextInputAction? textInputAction;
  final BoxDecoration? boxDecoration;
  final TextStyle? hintTextStyle;
  final Function? onClickRight;
  final Function(String) onSubmit;
  const WidgetSearch({
    Key? key,
    this.focusNode,
    this.inputController,
    // this.onChanged,
    this.validator,
    this.hint,
    this.errorText,
    this.labelText,
    this.initialValue,
    this.maxLine = 1,
    this.minLine = 1,
    this.maxLength,
    this.height = 55,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textInputAction = TextInputAction.go,
    this.leadIcon,
    this.endIcon,
    this.endIconFinal,
    this.enabled = true,
    this.boxDecoration,
    this.hintTextStyle,
    this.onClickRight,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: boxDecoration,
      child: Row(
        crossAxisAlignment: crossAxisAlignment!,
        children: [
          leadIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Center(
                      child: Container(height: 25, width: 25, child: leadIcon)),
                )
              : Container(),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: inputController,
                // onChanged: (change) => onChanged!(change),
                onFieldSubmitted: (v) {
                  onSubmit(v);
                },
                enabled: enabled,
                validator: validator,
                style: AppStyle.DEFAULT_14,
                maxLines: maxLine,
                minLines: minLine,
                keyboardType: inputType,
                textAlign: TextAlign.left,
                obscureText: obscureText!,
                initialValue: initialValue,
                focusNode: focusNode,
                textAlignVertical: TextAlignVertical.top,
                textInputAction: textInputAction,
                maxLength: maxLength,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle:
                      AppStyle.DEFAULT_14.copyWith(color: COLORS.PRIMARY_COLOR),
                  hintText: hint,
                  hintStyle: hintTextStyle,
                  errorText: errorText,
                  errorStyle: AppStyle.DEFAULT_14.copyWith(color: COLORS.RED),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          endIcon != null
              ? Container(height: height, width: 1, color: HexColor("#DBDBDB"))
              : Container(),
          endIcon != null
              ? GestureDetector(
                  onTap: () => onClickRight!(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                        child:
                            Container(height: 20, width: 20, child: endIcon)),
                  ),
                )
              : Container(),
          if (endIconFinal != null)
            Container(
              child: endIconFinal,
            ),
        ],
      ),
    );
  }
}
