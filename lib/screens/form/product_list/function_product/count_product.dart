import 'package:flutter/material.dart';
import 'package:gen_crm/src/string_ext.dart';
import '../../../../../src/models/model_generator/products_response.dart';
import '../../../../../src/src_index.dart';

class CountProduct extends StatefulWidget {
  const CountProduct({
    Key? key,
    required this.formProduct,
    required this.onChange,
  }) : super(key: key);
  final FormProduct formProduct;
  final Function(String) onChange;

  @override
  State<CountProduct> createState() => _CountProductState();
}

class _CountProductState extends State<CountProduct> {
  TextEditingController _textEditingController =
      TextEditingController(text: '0.00');

  @override
  void initState() {
    _setInit();
    _textEditingController.addListener(() {
      widget.onChange(
        _getCount().toString(),
      );
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CountProduct oldWidget) {
    if (widget.formProduct.isReloadLocal == true) _setInit();
    super.didUpdateWidget(oldWidget);
  }

  _setInit() {
    final value = widget.formProduct.fieldSetValue;
    if (value.toString().toDoubleTry() != 0) {
      _textEditingController.text = '${value ?? ''}';
    }
  }

  double _getCount() {
    return double.tryParse(_textEditingController.text.replaceAll(',', '.')) ??
        0;
  }

  _getCountPlus() {
    double count = _getCount();
    _textEditingController.text = (count + 1).toStringAsFixed(2);
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  _getCountMinus() {
    double count = _getCount();
    _textEditingController.text = (count - 1).toStringAsFixed(2);
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  _getCountZero() {
    _textEditingController.text = '0.00';
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_getCount() > 1) {
              _getCountMinus();
            } else {
              _getCountZero();
            }
          },
          style: ElevatedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(180),
            ),
            backgroundColor: COLORS.WHITE,
          ),
          child: WidgetContainerImage(
            image: ICONS.IC_MINUS_PNG,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(0),
            colorImage: _getCount() >= 1 ? COLORS.BLUE : COLORS.GRAY_IMAGE,
          ),
        ),
        Container(
          width: 80,
          child: TextFormField(
            controller: _textEditingController,
            textAlign: TextAlign.center,
            style: AppStyle.DEFAULT_16_BOLD,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(180),
            ),
            backgroundColor: COLORS.WHITE,
          ),
          onPressed: () {
            _getCountPlus();
          },
          child: WidgetContainerImage(
            image: ICONS.IC_PLUS_PNG,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            colorImage: COLORS.BLUE,
          ),
        ),
      ],
    );
  }
}
