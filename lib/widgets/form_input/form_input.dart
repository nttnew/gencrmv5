import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/src/models/model_generator/add_customer.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/widget/widget_label.dart';
import '../../src/src_index.dart';

class FormInputBase extends StatefulWidget {
  const FormInputBase({
    Key? key,
    this.initText,
    this.validateFun,
    this.textInputType,
    this.isClose = false,
    this.maxLength = 255,
    this.icon,
    this.suffixConstraint,
    this.isPass = false,
    required this.onChange,
    this.iconWidget,
    this.enabled = true,
    this.onTap,
    this.controller,
    this.maxLine,
    this.inputFormatters,
    this.suffix,
    this.suffixWidget,
    this.fullWidth = true,
    this.required = true,
    this.title,
    this.prefix,
    this.prefixConstraint,
    this.textInputAction,
    this.colorBorder,
    this.colorText,
    this.isWrap = false,
    this.isBorder = true,
    this.colorTitle,
    this.hint,
    this.onSubmit,
    this.errorText,
    this.focusNode,
    this.label,
  }) : super(key: key);

  final bool isClose;
  final String? icon;
  final String? title;
  final Widget? suffixWidget;
  final BoxConstraints? suffixConstraint;
  final BoxConstraints? prefixConstraint;
  final String? initText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? Function(String)? validateFun;
  final Function(String) onChange;
  final TextInputType? textInputType;
  final bool isPass;
  final bool fullWidth;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;
  final Widget? iconWidget;
  final bool enabled;
  final bool required;
  final Function()? onTap;
  final Function()? onSubmit;
  final int? maxLine;
  final TextInputAction? textInputAction;
  final Color? colorBorder;
  final Color? colorText;
  final Color? colorTitle;
  final bool isWrap;
  final bool isBorder;
  final String? hint;
  final String? errorText;
  final String? label;
  final FocusNode? focusNode;

  @override
  FormInputBaseState createState() => FormInputBaseState();
}

class FormInputBaseState extends State<FormInputBase> {
  late TextEditingController textEditingController;

  bool isPass = false;
  final BehaviorSubject<String?> textValidate = BehaviorSubject<String?>();
  final BehaviorSubject<bool> active = BehaviorSubject<bool>.seeded(false);
  bool validateCall = false;
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    isPass = widget.isPass;
    textEditingController = widget.controller ?? TextEditingController();
    if (widget.initText?.isNotEmpty ?? false) {
      textEditingController.text = widget.initText ?? '';
      widget.onChange(widget.initText ?? '');
      active.add(true);
    }
    textEditingController.addListener(() {
      active.add(textEditingController.value.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      textEditingController.dispose();
    }
  }

  String? validate(String? text) {
    final errorText = widget.validateFun?.call(
      textEditingController.text,
    );
    textValidate.sink.add(errorText);
    return errorText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.fullWidth ? MediaQuery.of(context).size.width : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            WidgetText(
              title: widget.title,
              style: AppStyle.DEFAULT_16_BOLD.copyWith(
                color: COLORS.BLACK,
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon?.isNotEmpty ?? false)
                StreamBuilder<bool>(
                  stream: active,
                  builder: (_, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: widget.maxLine != null ? 2 : 0,
                        right: 12,
                      ),
                      // child: PrefixIcon(
                      //   icon: widget.icon ?? '',
                      //   required: widget.required,
                      // ),
                    );
                  },
                ),
              Expanded(
                child: TextFormField(
                  textInputAction: widget.textInputAction,
                  style: AppStyle.DEFAULT_14.apply(
                    color: widget.colorText ?? COLORS.BLACK,
                  ),
                  validator: (text) {
                    validateCall = true;
                    return validate(text);
                  },
                  onChanged: (text) {
                    widget.onChange(text);
                    validate(text);
                  },
                  focusNode: widget.focusNode ?? focus,
                  onTap: widget.onTap,
                  inputFormatters: widget.inputFormatters,
                  keyboardType: widget.textInputType,
                  controller: textEditingController,
                  maxLength: widget.maxLength,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: isPass,
                  maxLines: widget.maxLine == null ? 1 : null,
                  onFieldSubmitted: (v) {
                    if (widget.onSubmit != null) widget.onSubmit!();
                  },
                  decoration: InputDecoration(
                    label: widget.label != null
                        ? WidgetLabel(CustomerIndividualItemData.two(
                            field_label: widget.label))
                        : null,
                    errorText: widget.errorText,
                    hintText: widget.hint,
                    contentPadding: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                      right: 16,
                      left: 16,
                    ),
                    isCollapsed: true,
                    enabled: widget.enabled,
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLORS.BLUE,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          6,
                        ),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLORS.RED,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          6,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLORS.RED,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          6,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: COLORS.GREY_400,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          6,
                        ),
                      ),
                    ),
                    suffixIconConstraints: widget.suffixConstraint ??
                        const BoxConstraints(
                          minHeight: 30,
                          minWidth: 30,
                          maxHeight: 30,
                          maxWidth: 60,
                        ),
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                    ),
                    prefixIconConstraints: widget.prefixConstraint ??
                        const BoxConstraints(
                          minHeight: 30,
                          minWidth: 36,
                          maxHeight: 36,
                          maxWidth: 60,
                        ),
                    suffixIcon: suffixIcon(),
                    prefixIcon: widget.prefix,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? suffixIcon() {
    if (widget.iconWidget != null) {
      return widget.iconWidget;
    }
    if (widget.isClose) {
      return null;
    } else if (widget.isPass) {
      return StreamBuilder<bool>(
          stream: active,
          builder: (context, snapshot) {
            return snapshot.data == true
                ? GestureDetector(
                    onTap: () => setState(() {
                      isPass = !isPass;
                    }),
                    child: Container(
                      padding: EdgeInsets.only(
                        right: 16,
                      ),
                      child: Image.asset(
                        isPass ? ICONS.IC_SHOW_PNG : ICONS.IC_HIDE_PNG,
                        fit: BoxFit.contain,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  )
                : SizedBox();
          });
    } else {
      return widget.suffix;
    }
  }
}
