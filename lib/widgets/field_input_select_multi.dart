import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/model_data_add.dart';
import '../../l10n/key_text.dart';
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
          _dropdownSelect.add(element);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.label,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: COLORS.BLACK,
              ),
              children: <TextSpan>[
                if (widget.required == 1)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: COLORS.RED,
                    ),
                  )
              ],
            ),
          ),
          AppValue.vSpaceTiny,
          MultiSelectDialogField<ModelDataAdd>(
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
                ShowDialogCustom.showDialogBase(
                  title: getT(KeyT.notification),
                  content:
                      "${getT(KeyT.you_can_only_choose)} ${getT(KeyT.max)} "
                      "${widget.maxLength} ${getT(KeyT.value)}"
                      "\n(${getT(KeyT.press_once_more_to_cancel_selection)})",
                );
              } else {
                List<String> res = [];
                for (int i = 0; i < values.length; i++) {
                  res.add('${values[i].value}');
                }
                widget.onChange(res.join(","));
              }
            },
            searchable: true,
            title: WidgetText(
              title: widget.label,
              style: AppStyle.DEFAULT_18_BOLD,
            ),
            buttonText: Text(
              widget.label,
              style: AppStyle.DEFAULT_14_BOLD.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: COLORS.ffBEB4B4)),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              size: 25,
            ),
            initialValue: _dropdownSelect,
            selectedItemsTextStyle: AppStyle.DEFAULT_14_BOLD,
            itemsTextStyle: AppStyle.DEFAULT_14,
          ),
        ],
      ),
    );
  }
}
