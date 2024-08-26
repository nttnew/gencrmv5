import 'package:flutter/material.dart';
import '../../../../../src/app_const.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';
import '../../../../../storages/share_local.dart';

class TextNumericProduct extends StatefulWidget {
  const TextNumericProduct({
    Key? key,
    required this.formProduct,
    this.isShowVND = false,
    required this.onChange,
  }) : super(key: key);
  final FormProduct formProduct;
  final Function(
    String?, {
    bool? isVND,
    bool? isDidUpdate,
  }) onChange;

  final bool isShowVND;

  @override
  State<TextNumericProduct> createState() => _TextNumericProductState();
}

class _TextNumericProductState extends State<TextNumericProduct> {
  TextEditingController _controller = TextEditingController();
  bool isVND = true;
  bool isDidUpdate = false;
  FocusNode _myFocusNode = FocusNode();

  @override
  void initState() {
    isVND = widget.formProduct.typeOfSale != '%';

    _setInit();
    _controller.addListener(() {
      if (!_myFocusNode.hasFocus) {
        _onChangeMain(isDidUpdate: isDidUpdate);
      }
    });
    _handelFocus();
    super.initState();
  }

  _onChangeMain({bool isDidUpdate = false}) {
    widget.onChange(
      isVND
          ? _controller.text.replaceAll('.', '')
          : _controller.text.replaceAll(',', '.'),
      isVND: isVND,
      isDidUpdate: isDidUpdate,
    );
  }

  _setInit() {
    final value = widget.formProduct.fieldSetValue;
    _controller.text = AppValue.formatMoney('${value ?? ''}', isD: false);
  }

  @override
  void didUpdateWidget(covariant TextNumericProduct oldWidget) {
    _setInit();
    isDidUpdate = true;
    super.didUpdateWidget(oldWidget);
  }

  _handelFocus() {
    _myFocusNode.addListener(() {
      if (!_myFocusNode.hasFocus) {
        _onChangeMain();
      }
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
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: fieldReadOnly ? COLORS.GRAY_IMAGE : COLORS.colorFff4d2,
        borderRadius: BorderRadius.all(
          Radius.circular(
            4,
          ),
        ),
        border: Border.all(
          color: _myFocusNode.hasFocus ? COLORS.BLUE : COLORS.GREY_400,
        ),
      ),
      child: Row(
        children: [
          Text(
            widget.formProduct.fieldLabel ?? '',
            style: AppStyle.DEFAULT_14_BOLD,
          ),
          if (widget.isShowVND)
            Container(
              margin: EdgeInsets.only(
                right: 8,
              ),
              child: iconButtonGen(
                onTap: () {
                  if (!fieldReadOnly) {
                    _controller.text = '';
                    isVND = !isVND;
                    setState(() {});
                    _onChangeMain();
                  }
                },
                icon: SizedBox(
                  width: 16,
                  height: 16,
                  child: FittedBox(
                    child: Text(
                      isVND
                          ? '${shareLocal.getString(PreferencesKey.MONEY) ?? ''}'
                          : '%',
                      style: AppStyle.DEFAULT_14_BOLD.copyWith(
                        color: COLORS.WHITE,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: TextFormField(
              enabled: !fieldReadOnly,
              focusNode: _myFocusNode,
              keyboardType: TextInputType.number,
              controller: _controller,
              textAlign: TextAlign.end,
              style: AppStyle.DEFAULT_14W600,
              inputFormatters: isVND ? AppStyle.inputPrice : null,
              onChanged: (v) {
                isDidUpdate = false;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
