import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
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
        widget.data.field_value != null ? widget.data.field_value! : "";
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
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: AppStyle.DEFAULT_14W600,
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: COLORS.RED))
                    : TextSpan(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: COLORS.WHITE,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: COLORS.ffBEB4B4)),
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        if (int.parse(text) >= 0 && int.parse(text) <= 100)
                          widget.onChanged(text);
                        else {
                          // _editingController.text="";
                          _editingController.clear();
                        }
                      },
                      controller: _editingController,
                      decoration: InputDecoration(
                          hintStyle: AppStyle.DEFAULT_14W500,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true),
                    ),
                  ),
                  WidgetText(
                    title: "%",
                    style: AppStyle.DEFAULT_14
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
