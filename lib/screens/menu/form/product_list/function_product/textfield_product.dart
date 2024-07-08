import 'package:flutter/material.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';

class TextFieldProduct extends StatefulWidget {
  const TextFieldProduct({
    Key? key,
    required this.formProduct,
    required this.onChange,
  }) : super(key: key);
  final FormProduct formProduct;
  final Function(String) onChange;
  @override
  State<TextFieldProduct> createState() => _TextFieldProductState();
}

class _TextFieldProductState extends State<TextFieldProduct> {
  TextEditingController _controller = TextEditingController();
  FocusNode _myFocusNode = FocusNode();

  @override
  void initState() {
    _setInit();
    _controller.addListener(() {
      widget.onChange(_controller.text);
    });
    _handelFocus();
    super.initState();
  }

  _setInit() {
    final value = widget.formProduct.fieldSetValue;
    if ('${value ?? ''}' != '') {
      _controller.text = value;
    }
  }

  _handelFocus() {
    _myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool fieldReadOnly = widget.formProduct.fieldReadOnly == 1;
    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: fieldReadOnly ? COLORS.GRAY_IMAGE : COLORS.WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(
            4,
          ),
        ),
        border: Border.all(
          color: _myFocusNode.hasFocus ? COLORS.BLUE : COLORS.GREY_400,
        ),
      ),
      child: TextFormField(
        enabled: !fieldReadOnly,
        focusNode: _myFocusNode,
        controller: _controller,
        style: AppStyle.DEFAULT_14W600,
        decoration: InputDecoration(
          hintText: widget.formProduct.fieldLabel,
          contentPadding: EdgeInsets.zero,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          isCollapsed: true,
        ),
      ),
    );
  }
}
