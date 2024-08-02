import 'package:flutter/material.dart';
import 'package:gen_crm/screens/menu/widget/widget_label.dart';
import 'package:gen_crm/src/src_index.dart';
import '../src/models/model_generator/add_customer.dart';

class FieldInputPercent extends StatefulWidget {
  FieldInputPercent({Key? key, required this.data, required this.onChanged})
      : super(key: key);

  final CustomerIndividualItemData data;
  final Function onChanged;

  @override
  State<FieldInputPercent> createState() => _FieldInputPercentState();
}

class _FieldInputPercentState extends State<FieldInputPercent> {
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    _editingController.text =
        widget.data.field_value != null ? widget.data.field_value! : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottomFrom,
      child: Expanded(
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          style: AppStyle.DEFAULT_14_BOLD,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            if (int.parse(text) >= 0 && int.parse(text) <= 100)
              widget.onChanged(text);
            else {
              _editingController.clear();
            }
          },
          controller: _editingController,
          decoration: InputDecoration(
            suffixText: '%',
            label: WidgetLabel(widget.data),
            contentPadding: paddingBaseForm,
            hintStyle: hintTextStyle,
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
