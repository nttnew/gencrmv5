import 'package:flutter/material.dart';
import 'package:gen_crm/screens/widget/widget_label.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/model_data_add.dart';
import '../../l10n/key_text.dart';
import '../src/models/model_generator/add_customer.dart';
import '../src/src_index.dart';

class SelectMulti extends StatefulWidget {
  SelectMulti({
    Key? key,
    required this.dropdownItemList,
    required this.label,
    required this.required,
    required this.initValue,
    required this.maxLength,
    required this.onChange,
  }) : super(key: key);

  final List<List<dynamic>> dropdownItemList;
  final String label;
  final int required;
  final List<String>? initValue;
  final String maxLength;
  final Function(dynamic data) onChange;

  @override
  State<SelectMulti> createState() => _SelectMultiState();
}

class _SelectMultiState extends State<SelectMulti> {
  late final List<ModelDataAdd> _dropdown;
  List<ModelDataAdd> _dropdownSelect = [];
  bool _showLine = false;

  @override
  void initState() {
    _dropdown = [];
    for (int i = 0; i < widget.dropdownItemList.length; i++) {
      _dropdown.add(ModelDataAdd(
          label: widget.dropdownItemList[i][1],
          value: widget.dropdownItemList[i][0]));
    }

    _dropdown.forEach((element) {
      for (final value in widget.initValue ?? []) {
        if ('$value' == '${element.value}') {
          _showLine = true;
          _dropdownSelect.add(element);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottomFrom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: boxDecorationBaseForm,
            child: MultiSelectDialogField<ModelDataAdd>(
              listType: MultiSelectListType.CHIP,
              items: _dropdown
                  .map((e) => MultiSelectItem(e, e.label ?? ''))
                  .toList(),
              cancelText: Text(
                getT(KeyT.cancel),
                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                  color: COLORS.BLUE,
                ),
              ),
              confirmText: Text(
                getT(KeyT.select),
                style: AppStyle.DEFAULT_16_BOLD.copyWith(
                  color: COLORS.BLUE,
                ),
              ),
              separateSelectedItems: true,
              onConfirm: (values) {
                if (widget.maxLength != '' &&
                    values.length > int.parse(widget.maxLength)) {
                  values.removeRange(
                      int.parse(widget.maxLength) - 1, values.length - 1);
                  _showLine = true;
                  ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content:
                        '${getT(KeyT.you_can_only_choose)} ${getT(KeyT.max)} '
                        '${widget.maxLength} ${getT(KeyT.value)}'
                        '\n(${getT(KeyT.press_once_more_to_cancel_selection)})',
                  );
                } else {
                  List<String> res = [];
                  for (int i = 0; i < values.length; i++) {
                    res.add('${values[i].value}');
                  }
                  _showLine = res.isNotEmpty;
                  widget.onChange(res.join(','));
                }
                setState(() {});
              },
              searchable: true,
              title: WidgetText(
                title: widget.label,
                style: AppStyle.DEFAULT_18_BOLD,
              ),
              buttonText: Text(
                getT(KeyT.select) +
                    ((int.tryParse(widget.maxLength) ?? 0) > 0
                        ? ' ${getT(KeyT.max).toLowerCase()} ${widget.maxLength}'
                        : ''), //+ ' ' + widget.label.toLowerCase(),
                style: AppStyle.DEFAULT_14_BOLD.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              decoration: !_showLine ? BoxDecoration() : null,
              buttonIcon: Icon(
                Icons.arrow_drop_down,
                size: 25,
              ),
              initialValue: _dropdownSelect,
              selectedItemsTextStyle: AppStyle.DEFAULT_14_BOLD,
              itemsTextStyle: AppStyle.DEFAULT_14,
            ),
          ),
          WidgetLabelPo(
            data: CustomerIndividualItemData.two(
              field_label: widget.label,
              field_require: widget.required,
            ),
          ),
        ],
      ),
    );
  }
}
