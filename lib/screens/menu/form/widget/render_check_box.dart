import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../../../src/models/model_generator/add_customer.dart';

class RenderCheckBox extends StatefulWidget {
  RenderCheckBox({
    Key? key,
    required this.onChange,
    required this.data,
    this.init,
  }) : super(key: key);

  final Function onChange;
  final CustomerIndividualItemData data;
  final bool? init;

  @override
  State<RenderCheckBox> createState() => _RenderCheckBoxState();
}

class _RenderCheckBoxState extends State<RenderCheckBox> {
  bool isCheck = false;

  @override
  void initState() {
    isCheck = widget.init ?? false;
    widget.onChange(isCheck);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(
              right: 8,
            ),
            child: Checkbox(
              value: isCheck,
              onChanged: (bool? value) {
                widget.onChange(value);
                setState(() {
                  isCheck = value!;
                });
              },
            ),
          ),
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              text: widget.data.field_label ?? '',
              style: AppStyle.DEFAULT_14,
              children: <TextSpan>[
                widget.data.field_require == 1
                    ? TextSpan(
                        text: '*',
                        style: AppStyle.DEFAULT_14W600_RED,
                      )
                    : TextSpan(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
