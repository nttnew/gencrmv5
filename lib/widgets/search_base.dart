import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gen_crm/src/src_index.dart';
import 'package:hexcolor/hexcolor.dart';

import '../src/app_const.dart';

class SearchBase extends StatefulWidget {
  final TextEditingController? inputController;
  final FormFieldValidator<String>? validator;
  final String? hint, errorText, labelText, initialValue;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? obscureText;
  final TextInputType? inputType;
  final Widget? leadIcon;
  final Widget? endIcon;
  final bool? enabled;
  final FocusNode? focusNode;
  final CrossAxisAlignment crossAxisAlignment;
  final TextInputAction? textInputAction;
  final BoxDecoration? boxDecoration;
  final TextStyle? hintTextStyle;
  final Function? onClickRight;
  final Function(String) onSubmit;
  const SearchBase({
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
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<SearchBase> createState() => _SearchBaseState();
}

class _SearchBaseState extends State<SearchBase> {
  Debounce debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: COLORS.GREY_400,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            6,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          widget.leadIcon != null
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      child: widget.leadIcon,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: TextFormField(
                controller: widget.inputController,
                onChanged: (v) {
                  debounce.run(() {
                    widget.onSubmit(v.trim());
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
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
                  hintStyle: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#707070"),
                  ),
                  errorText: widget.errorText,
                  errorStyle: AppStyle.DEFAULT_14.copyWith(
                    color: COLORS.RED,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          widget.endIcon != null
              ? GestureDetector(
                  onTap: () => widget.onClickRight!(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: COLORS.GREY_400,
                          width: 1,
                        ),
                      ),
                    ),
                    child: widget.endIcon,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
