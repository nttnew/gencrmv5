import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gen_crm/src/src_index.dart';

class WidgetInput extends StatefulWidget {
  final TextEditingController? inputController;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? hint, errorText, labelText, labelText1, initialValue;
  final int? maxLine;
  final Padding? padding;
  final Color? colorFix;
  final TextStyle? hintStyle;
  final int? minLine;
  final int? maxLength;
  final double?  height,heightIcon,widthIcon;
  final bool? obscureText;
  final TextInputType? inputType;
  final Widget? leadIcon;
  final Widget? endIcon;
  final Widget? Fix;
  final bool? enabled;
  final FocusNode? focusNode;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextInputAction? textInputAction;
  final BoxDecoration? boxDecoration;
  const WidgetInput(
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
        this.Fix,
        this.colorFix, this.labelText1, this.widthIcon, this.heightIcon, this.hintStyle, this.padding
      })
      : super(key: key);

  @override
  _WidgetInputState createState() => _WidgetInputState();
}

class _WidgetInputState extends State<WidgetInput> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      // overflow: Overflow.visible,
      clipBehavior: Clip.none,
      children: [
          Container(
            height: widget.height,
            decoration: widget.boxDecoration,
            child: Row(
              crossAxisAlignment: widget.crossAxisAlignment!,
              children: [
                widget.leadIcon != null ? Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Center(child: Container(height: 25, width: 25, child: widget.leadIcon)),
                ) : Container(),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      key: widget.key,
                      controller: widget.inputController,
                      onChanged: (change){
                        if(widget.onChanged!=null)
                          widget.onChanged!(change);
                        else{}
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
                        labelStyle: AppStyle.DEFAULT_16.copyWith(color: Color(0xff707070)),
                        hintText: widget.hint,
                        hintStyle: widget.hintStyle ?? AppStyle.DEFAULT_12.copyWith(color: Color(0xff707070)),
                        errorText: widget.errorText,
                        errorStyle: AppStyle.DEFAULT_12.copyWith(color: COLORS.RED),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1, height: widget.height,
                  margin: EdgeInsets.only(right: 15),
                  color: widget.colorFix ?? COLORS.COLORS_BA,),
                widget.endIcon != null ? Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(height: widget.heightIcon?? 18, width:widget.widthIcon?? 20, child: widget.endIcon),
                ) : Container()
              ],
            ),
          ),
        Positioned(
          top: -21,
          left: 3,
          child:widget.Fix ?? Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white),
                      left: BorderSide(color: Colors.white),
                      right: BorderSide(color: Colors.white),
                    ),
                  ),
                  height: 11),
              Center(
                child: Text(widget.labelText1.toString(),style: AppStyle.DEFAULT_12.copyWith(color: COLORS.GREY),),
              ),
            ],
            ),
          ),
        ),
      ],
    );
  }
}

