import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:rxdart/rxdart.dart';

class WidgetInput extends StatefulWidget {
  final TextEditingController? inputController;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? hint, errorText, labelText, labelText1, initialValue;
  final int? maxLine;
  final Padding? padding;
  final Color? colorTxtLabel;
  final TextStyle? hintStyle;
  final int? minLine;
  final int? maxLength;
  final double? height, heightIcon, widthIcon;
  final bool obscureText;
  final TextInputType? inputType;
  final Widget? leadIcon;
  final Widget? endIcon;
  final Widget? textLabel;
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
      this.textLabel,
      this.colorTxtLabel,
      this.labelText1,
      this.widthIcon,
      this.heightIcon,
      this.hintStyle,
      this.padding})
      : super(key: key);

  @override
  _WidgetInputState createState() => _WidgetInputState();
}

class _WidgetInputState extends State<WidgetInput> {
  BehaviorSubject<String> _text = BehaviorSubject.seeded('');
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  void dispose() {
    _text.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.textLabel ??
            Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: COLORS.WHITE,
              ),
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: COLORS.WHITE),
                          left: BorderSide(color: COLORS.WHITE),
                          right: BorderSide(color: COLORS.WHITE),
                        ),
                      ),
                      height: 11),
                  Center(
                    child: Text(
                      widget.labelText1.toString(),
                      style: AppStyle.DEFAULT_14.copyWith(color: COLORS.GREY),
                    ),
                  ),
                ],
              ),
            ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: widget.height,
          decoration: widget.boxDecoration,
          child: Row(
            crossAxisAlignment: widget.crossAxisAlignment!,
            children: [
              widget.leadIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Center(
                          child: Container(
                              height: 25, width: 25, child: widget.leadIcon)),
                    )
                  : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    key: widget.key,
                    controller: widget.inputController,
                    onChanged: (change) {
                      _text.add(change);
                      if (widget.onChanged != null) widget.onChanged!(change);
                    },
                    enabled: widget.enabled,
                    validator: widget.validator,
                    style: AppStyle.DEFAULT_14,
                    maxLines: widget.maxLine,
                    minLines: widget.minLine,
                    keyboardType: widget.inputType,
                    textAlign: TextAlign.left,
                    obscureText: obscureText,
                    initialValue: widget.initialValue,
                    focusNode: widget.focusNode,
                    textAlignVertical: TextAlignVertical.top,
                    textInputAction: widget.textInputAction,
                    maxLength: widget.maxLength,
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: AppStyle.DEFAULT_16
                          .copyWith(color: Color(0xff707070)),
                      hintText: widget.hint,
                      hintStyle: widget.hintStyle ??
                          AppStyle.DEFAULT_14
                              .copyWith(color: Color(0xff707070)),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              if (widget.obscureText)
                StreamBuilder<String>(
                    stream: _text,
                    builder: (context, snapshot) {
                      final txt = snapshot.data;
                      if (txt == '') {
                        return SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          obscureText = !obscureText;
                          setState(() {});
                        },
                        child: Container(
                          height: 18,
                          width: 20,
                          child: Image.asset(
                            !obscureText
                                ? ICONS.IC_HIDE_PNG
                                : ICONS.IC_SHOW_PNG,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }),
              Container(
                width: 1,
                height: widget.height,
                margin: EdgeInsets.only(right: 15),
                color: widget.colorTxtLabel ?? COLORS.COLORS_BA,
              ),
              widget.endIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Container(
                        height: widget.heightIcon ?? 18,
                        width: widget.widthIcon ?? 20,
                        child: widget.endIcon,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        if (widget.errorText != null && widget.errorText != '') ...[
          SizedBox(
            height: 1,
          ),
          WidgetText(
            title: widget.errorText,
            style: AppStyle.DEFAULT_14.copyWith(color: COLORS.RED),
          )
        ]
      ],
    );
  }
}
