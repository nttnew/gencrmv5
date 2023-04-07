import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetSearch extends StatefulWidget {
  final TextEditingController? inputController;
  final ValueChanged<String>? onChanged;
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
  final bool? enabled;
  final FocusNode? focusNode;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextInputAction? textInputAction;
  final BoxDecoration? boxDecoration;
  final TextStyle? hintTextStyle;
  final Function? onClickRight;
  final Function? onEditingComplete;
  const WidgetSearch(
      {Key? key,
      this.focusNode,
      this.inputController,
      this.onChanged,
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
      this.enabled = true,
      this.boxDecoration,
      this.hintTextStyle,
      this.onClickRight,
      this.onEditingComplete})
      : super(key: key);

  @override
  _WidgetSearchState createState() => _WidgetSearchState();
}

class _WidgetSearchState extends State<WidgetSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: widget.boxDecoration,
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment!,
        children: [
          widget.leadIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Center(
                      child: Container(
                          height: 25, width: 25, child: widget.leadIcon)),
                )
              : Container(),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                key: widget.key,
                controller: widget.inputController,
                onChanged: (change) => widget.onChanged!(change),
                onEditingComplete: () {
                  widget.onEditingComplete!();
                },
                enabled: widget.enabled,
                validator: widget.validator,
                style: AppStyle.DEFAULT_14,
                maxLines: widget.maxLine,
                minLines: widget.minLine,
                keyboardType: widget.inputType,
                textAlign: TextAlign.left,
                obscureText: widget.obscureText!,
                initialValue: widget.initialValue,
                focusNode: widget.focusNode,
                textAlignVertical: TextAlignVertical.top,
                textInputAction: widget.textInputAction,
                maxLength: widget.maxLength,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle:
                      AppStyle.DEFAULT_14.copyWith(color: COLORS.PRIMARY_COLOR),
                  hintText: widget.hint,
                  hintStyle: widget.hintTextStyle,
                  errorText: widget.errorText,
                  errorStyle: AppStyle.DEFAULT_12.copyWith(color: COLORS.RED),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          widget.endIcon != null
              ? Container(
                  height: widget.height, width: 1, color: HexColor("#DBDBDB"))
              : Container(),
          widget.endIcon != null
              ? GestureDetector(
                  onTap: () => widget.onClickRight!(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                        child: Container(
                            height: 20, width: 20, child: widget.endIcon)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
